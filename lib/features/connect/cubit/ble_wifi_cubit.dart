import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/reader_connection.dart';
import '../models/reader_device.dart';
import '../repository/ble_repository.dart';
import '../repository/common_repository.dart';

part 'ble_wifi_cubit.freezed.dart';
part 'ble_wifi_state.dart';

class BleWifiCubit extends Cubit<BleWifiState> {
  BleWifiCubit(this.repository, this._bleRepository)
    : super(const BleWifiState()) {
    _bleRepository.setLogLevel(BLERepoLogLevel.debug);
    // Reconcile state when the device drops the BLE link on its own
    // (reboot/reset/wifi-enable/timeout all cause this).
    _bleConnectionSub = _bleRepository.connectionStream.listen(
      _onBleConnectionChanged,
    );
    launchNFC();
  }

  final CommonRepository repository;
  final BleRepository _bleRepository;

  StreamSubscription<bool>? _bleConnectionSub;

  @override
  Future<void> close() {
    _bleConnectionSub?.cancel();
    return super.close();
  }

  // --- NFC ------------------------------------------------------------------

  Future<void> launchNFC() => repository.launchNFC(_nfcCallback);

  Future<void> _nfcCallback({String? ndefData, String? error}) async {
    if (error != null) {
      _temporaryHint(BleWifiStatus.error, error);
      return;
    }
    if (ndefData == null || ndefData.isEmpty) {
      _temporaryHint(BleWifiStatus.error, 'No NDEF data found');
      return;
    }

    final advName = '${ReaderDevice.blePrefix}$ndefData';

    await _autoconnectToDeviceBLE(advName, 5);
    final connected = state.connectedDevice;
    if (connected == null) return;

    await updateDateTimeOnBle();
    await getDeviceConfig(connected);
    // await makeMagic();
  }

  // --- BLE discovery & connection ------------------------------------------

  Future<void> searchBLE({int timeout = 15}) async {
    // Tear down any active connection before scanning again.
    if (state.connectedDevice != null) {
      await _bleRepository.disconnect();
    }

    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Searching BLE devices...',
        devices: const [],
      ),
    );
    try {
      final results =
          await _bleRepository.scanForDevices(
            withServices: [BleRepository.serviceUuid],
            timeout: Duration(seconds: timeout),
          ) ??
          [];
      emit(
        state.copyWith(
          status: BleWifiStatus.success,
          hintText: '',
          devices: results
              .map((r) => ReaderDevice(bleDevice: r.device))
              .toList(),
        ),
      );
    } catch (e) {
      _temporaryHint(BleWifiStatus.error, 'Error occured...');
    }
  }

  Future<void> connectToDevice(ReaderDevice reader) async {
    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Connecting to BLE device...',
      ),
    );
    final (ok, hint) = await _bleRepository.connectToDevice(reader.bleDevice);
    if (ok) {
      _setConnection(reader.id, ReaderConnection.ble);
    }
    _temporaryHint(ok ? BleWifiStatus.success : BleWifiStatus.error, hint);
  }

  Future<void> _autoconnectToDeviceBLE(String advName, int timeout) async {
    await searchBLE(timeout: timeout);
    final reader = _deviceWhere((d) => d.name == advName);
    if (reader == null) {
      emit(
        state.copyWith(
          status: BleWifiStatus.error,
          hintText: 'Device not found',
        ),
      );
      return;
    }
    await connectToDevice(reader);
  }

  Future<void> disconnectBLE() async {
    final device = state.connectedDevice;
    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Disconnecting BLE device...',
      ),
    );
    await _bleRepository.disconnect();
    if (device != null) {
      _updateDevice(
        device.id,
        (d) => d.copyWith(connection: ReaderConnection.none, config: null),
      );
    }
    _temporaryHint(BleWifiStatus.success, 'Done');
  }

  void _onBleConnectionChanged(bool connected) {
    if (connected) return;
    final device = state.connectedDevice;
    if (device != null && device.connection == ReaderConnection.ble) {
      _temporaryHint(BleWifiStatus.error, 'Device disconnected');
      _setConnection(device.id, ReaderConnection.none);
    }
  }

  void deleteReaderFromCache(ReaderDevice reader) {
    final updatedDevieList = state.devices
        .where((device) => device.id != reader.id)
        .toList();

    emit(state.copyWith(devices: updatedDevieList));
  }

  // --- BLE commands ---------------------------------------------------------

  Future<void> getDeviceConfig(ReaderDevice reader) async {
    final (ok, config) = await _bleRepository.getConfig();
    if (ok && config != null) {
      _updateDevice(reader.id, (d) => d.copyWith(config: config));
      _temporaryHint(
        BleWifiStatus.success,
        'Config was successfully retrieved via BLE!',
      );
    }

    if (!ok) {
      _temporaryHint(BleWifiStatus.error, 'Failed to retrieve config via BLE!');
    }
  }

  Future<void> updateDateTimeOnBle() => _bleRepository.setDateTime();

  // --- BLE → WiFi handoff ---------------------------------------------------

  Future<void> connectUsingWiFi() async {
    final device = state.connectedDevice;
    if (device == null || device.connection != ReaderConnection.ble) {
      _temporaryHint(BleWifiStatus.success, 'Connect to device first');
      return;
    }

    try {
      // 1. ask the device to bring up its WiFi hotspot.
      final turnOnWiFiSuccessful = await _bleRepository.turnOnWifi();

      if (!turnOnWiFiSuccessful) {
        _temporaryHint(BleWifiStatus.error, 'Failed to turn on wifi');
        return;
      }

      emit(state.copyWith(hintText: 'WiFi turn on command is sent!'));

      await _bleRepository.disconnect();

      emit(state.copyWith(hintText: 'Disconnected from BLE!'));

      // 2. join the hotspot and drop the (now defunct) BLE link.
      final connectedToWiFi = await repository.connectToDeviceWifi(
        device.readerId,
      );

      if (!connectedToWiFi) {
        _setConnection(device.id, ReaderConnection.none);
        _temporaryHint(
          BleWifiStatus.error,
          'Failed to connect on wifi network',
        );
        return;
      }
      _setConnection(device.id, ReaderConnection.wifi);

      emit(state.copyWith(hintText: 'Connected using WiFi!'));

      // 3. while joined the phone has no internet (hotspot has no uplink) — this
      // is the window to exchange data. Current code just pings a few times.
      for (var i = 10; i > 0; i--) {
        emit(state.copyWith(hintText: 'Disconnect in $i seconds...'));
        await Future.delayed(const Duration(seconds: 1));
      }

      // 4. leave the hotspot and wait for normal internet to come back.
      final disconnectSuccessful = await repository.disconnectDeviceWifi();

      if (disconnectSuccessful) {
        _setConnection(device.id, ReaderConnection.none);
        _temporaryHint(BleWifiStatus.success, 'Done');
      }
    } catch (_) {
      _temporaryHint(
        BleWifiStatus.error,
        'Something went wrong during connetion!',
      );
    }
  }

  // --- helpers --------------------------------------------------------------

  ReaderDevice? _deviceWhere(bool Function(ReaderDevice) test) {
    for (final device in state.devices) {
      if (test(device)) return device;
    }
    return null;
  }

  /// Replace a single device in the list, identified by [id].
  void _updateDevice(String id, ReaderDevice Function(ReaderDevice) update) {
    emit(
      state.copyWith(
        devices: [
          for (final device in state.devices)
            device.id == id ? update(device) : device,
        ],
      ),
    );
  }

  /// Set [id]'s transport and ensure it is the only connected device.
  void _setConnection(String id, ReaderConnection connection) {
    emit(
      state.copyWith(
        devices: [
          for (final device in state.devices)
            if (device.id == id)
              device.copyWith(connection: connection)
            else if (device.connection != ReaderConnection.none)
              device.copyWith(connection: ReaderConnection.none)
            else
              device,
        ],
      ),
    );
  }

  Future<void> _temporaryHint(
    BleWifiStatus status,
    String hint, {
    int secondsToShow = 3,
  }) async {
    emit(state.copyWith(status: status, hintText: hint));
    await Future.delayed(Duration(seconds: secondsToShow));
    if (state.hintText == hint) {
      emit(state.copyWith(hintText: ''));
    }
  }
}
