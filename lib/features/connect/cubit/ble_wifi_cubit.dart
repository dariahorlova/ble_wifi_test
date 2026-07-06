import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/reader_connection.dart';
import '../models/reader_device.dart';
import '../repository/ble_repository.dart';
import '../repository/common_repository.dart';

part 'ble_wifi_state.dart';
part 'ble_wifi_cubit.freezed.dart';

class BleWifiCubit extends Cubit<BleWifiState> {
  BleWifiCubit(this.repository, this._bleRepository)
    : super(const BleWifiState(status: BleWifiStatus.initial)) {
    _bleRepository.setLogLevel(BLERepoLogLevel.debug);
    _bleConnectionStateSubscription = _bleRepository.connectionStream.listen((
      isConnected,
    ) {
      // just to update UI if we suddenly lost connection to BLE device.
      if (!isConnected) {
        emit(
          state.copyWith(
            readerDevice: state.readerDevice?.copyWith(
              connection: ReaderConnection.none,
            ),
          ),
        );
      }
    });
    launchNFC();
  }

  @override
  Future<void> close() async {
    await _bleConnectionStateSubscription?.cancel();
    await super.close();
  }

  final CommonRepository repository;
  final BleRepository _bleRepository;
  StreamSubscription<bool>? _bleConnectionStateSubscription;

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

    //create an advName from ndef
    final advName = '${BleRepository.blePrefix}$ndefData';

    // launch flow
    await _autoconnectToDeviceBLE(advName, 5);
    if (!_bleRepository.isBLEDeviceConnected) {
      _temporaryHint(BleWifiStatus.error, 'Failed to connect to BLE device');
      return;
    }
    await updateDateTimeOnBle();
    await getDeviceConfigByBle();
  }

  Future<List<BluetoothDevice>?> _searchBLE({int timeout = 15}) async {
    if (_bleRepository.isBLEDeviceConnected) {
      disconnectBLE();
    }

    _temporaryHint(BleWifiStatus.loading, 'Searching BLE devices...');
    try {
      final devices =
          await _bleRepository.scanForDevices(
            withServices: [BleRepository.serviceUuid],
            timeout: Duration(seconds: timeout),
          ) ??
          [];
      _temporaryHint(BleWifiStatus.success, '');

      return devices.map((e) => e.device).toList();
    } catch (e) {
      _temporaryHint(BleWifiStatus.error, 'Error occured...');
    }
    return null;
  }

  Future<void> _autoconnectToDeviceBLE(String advName, int timeout) async {
    final devicesList = await _searchBLE(timeout: timeout);
    final index = devicesList?.indexWhere((e) => e.advName == advName);
    if (devicesList == null || index == null || index == -1) {
      _temporaryHint(BleWifiStatus.error, 'Device not found');
      return;
    }

    final (res, hint) = await _bleRepository.connectToDevice(
      devicesList[index],
    );

    _temporaryHint(
      res ? BleWifiStatus.success : BleWifiStatus.error,
      hint,
      readerDevice: res
          ? ReaderDevice(
              readerId: devicesList[index].advName.replaceFirst(
                BleRepository.blePrefix,
                '',
              ),
              // actually we can just use ReaderConnection.ble
              connection: _bleRepository.isBLEDeviceConnected
                  ? ReaderConnection.ble
                  : ReaderConnection.none,
            )
          : null,
    );
  }

  Future<void> getDeviceConfigByBle() async {
    final (res, config) = await _bleRepository.getConfig();

    _temporaryHint(
      res ? BleWifiStatus.success : BleWifiStatus.error,
      'got config from BLE: $res',
      readerDevice: state.readerDevice?.copyWith(config: config),
    );
  }

  Future<bool> updateDateTimeOnBle() => _bleRepository.setDateTime();

  Future<void> disconnectBLE() async {
    _temporaryHint(BleWifiStatus.loading, 'Disconnecting BLE device...');
    await _bleRepository.disconnect();
    _temporaryHint(BleWifiStatus.success, 'Done', readerDevice: null);
  }

  Future<void> connectToDeviceWifi() async {
    if (_bleRepository.isBLEDeviceConnected) {
      var currentSsid = await repository.currentWifiSsid;
      developer.log('current SSID: $currentSsid');
      // turn on wifi
      final resWifiLaunch = await _bleRepository.turnOnWifi();
      if (!resWifiLaunch) {
        _temporaryHint(BleWifiStatus.error, 'Failed to turn on wifi');
        return;
      }
      _temporaryHint(BleWifiStatus.success, 'Wifi is ON');

      //connect to wifi
      final uuid = state.readerDevice?.readerId ?? '';
      final resWifiConnect = await repository.connectToDeviceWifi(uuid);

      if (resWifiConnect && !_bleRepository.isBLEDeviceConnected) {
        //todo: !!! here is a correct place to establish soccet connection,
        // cuz we are really connected to device's wifi hotspot

        _temporaryHint(
          BleWifiStatus.success,
          'Connected to device WiFi',
          readerDevice: state.readerDevice?.copyWith(
            connection: ReaderConnection.wifi,
          ),
        );
      } else {
        // we are stiion on ble connection.
        _temporaryHint(
          BleWifiStatus.error,
          'Failed to connect on wifi network.',
        );
        // we can transfer data through ble connection or show an error,
        // or try to launch wifi again...
        return;
      }

      //-> now we don't have internet. we are connected to device's wifi hotspot.
      // let's check internet connection for 5 seconds.
      // here we can upload some data to the device or get some data from it through wifi hotspot
      developer.log(
        'repo::makeMagic. just to be sure, we are using device wifi we will try to ping internet here...',
      );
      var i = 0;
      while (i < 5) {
        final resInternet = await repository.pingInternet();
        developer.log(
          'repo::makeMagic. life without internet: $resInternet. fry(${i++})',
        );
        await Future.delayed(const Duration(seconds: 1));
      }
      //<-

      // actually, we don't nned to launch this in prod, cuz we have to switch
      // to ble again. so, this should be done automatically, when ble raises
      // but for now, it's ok
      await repository.disconnectDeviceWifi();

      developer.log('repo::makeMagic. reconnecting to internet...');
      _temporaryHint(BleWifiStatus.loading, 'Reconnecting to Internet...');

      while (!await repository.pingInternet()) {
        developer.log(
          'repo::makeMagic. reconnecting to internet... this try failed. trying again in a second...',
        );
        await Future.delayed(const Duration(seconds: 1));
      }

      developer.log('repo::makeMagic. reconnecting to internet... done.');
      _temporaryHint(
        BleWifiStatus.success,
        'Done',
        readerDevice: state.readerDevice?.copyWith(
          connection: ReaderConnection.none, // for now
        ),
      );
      //todo: !!! here we already have an internet connection and can update backend
      // with new data...
    } else {
      _temporaryHint(BleWifiStatus.success, 'Connect to device first');
    }
  }

  Future<void> _temporaryHint(
    BleWifiStatus status,
    String hint, {
    int secondsToShow = 3,
    ReaderDevice? readerDevice,
  }) async {
    emit(
      state.copyWith(
        status: status,
        hintText: hint,
        readerDevice: readerDevice ?? state.readerDevice,
      ),
    );
    await Future.delayed(Duration(seconds: secondsToShow));
    emit(state.copyWith(hintText: ''));
  }
}
