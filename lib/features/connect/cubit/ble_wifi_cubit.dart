import 'dart:developer' as developer;

import 'package:ble_wifi_test/features/connect/repository/ble_wifi_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

part 'ble_wifi_state.dart';
part 'ble_wifi_cubit.freezed.dart';

const blePrefix = 'IB_';

class BleWifiCubit extends Cubit<BleWifiState> {
  final BLEWIFIRepository repository;
  BleWifiCubit(this.repository)
    : super(const BleWifiState(status: BleWifiStatus.initial)) {
    launchNFCSession();
  }

  void launchNFCSession() async {
    final isNfcAvailable =
        (await NfcManager.instance.checkAvailability()) ==
        NfcAvailability.enabled;

    developer.log('repo::launchNFCSession. NFC is available: $isNfcAvailable');
    if (!isNfcAvailable) return;

    await _stopNFCSession();

    await NfcManager.instance.startSession(
      onDiscovered: _onTagDiscovered,
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
    );
  }

  Future<void> _onTagDiscovered(NfcTag tag) async {
    developer.log('repo::_onTagDiscovered. NFC tag found...');
    final ndef = Ndef.from(tag);
    final records = ndef?.cachedMessage?.records;

    if (records == null) return;
    final uri = Uri.tryParse(
      String.fromCharCodes(records[0].payload.sublist(1)),
    ); // 1st byte is type in our case it 0x04 and means "https://"
    developer.log('repo::_onTagDiscovered. uri: $uri');
    final avdName = '$blePrefix${uri?.queryParameters['reader_id'] ?? ''}';

    await _stopNFCSession();

    await _autoconnectToDeviceBLE(avdName, 5);
    await makeMagic();
  }

  Future<void> _stopNFCSession() async {
    try {
      developer.log('repo::_stopNFCSession. NFC session can be stopped...');
      await NfcManager.instance.stopSession();
    } catch (e) {
      developer.log(
        'repo::_stopNFCSession. there is no previous NFC session found...',
      );
    }
  }

  Future<void> searchBLE({int timeout = 15}) async {
    if (state.currentDeviceIndex != -1) {
      disconnectBLE();
    }

    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Searching BLE devices...',
        devices: [],
      ),
    );
    try {
      final devices =
          await repository.scanForDevices(
            withServices: [Guid(BLEWIFIRepository.serviceUuid)],
            timeout: Duration(seconds: timeout),
          ) ??
          [];
      emit(
        state.copyWith(
          status: BleWifiStatus.success,
          devices: devices.map((e) => e.device).toList(),
          hintText: '',
        ),
      );
    } catch (e) {
      _temporaryHint(BleWifiStatus.error, 'Error occured...');
    }
  }

  Future<void> connectToDeviceBLEByIndex(int index) async {
    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Connecting to BLE device...',
      ),
    );
    final (res, hint) = await repository.connectToDevice(state.devices[index]);
    _temporaryHint(
      res ? BleWifiStatus.success : BleWifiStatus.error,
      hint,
      currentDeviceIndex: res ? index : -1,
    );
  }

  Future<void> _autoconnectToDeviceBLE(String avdName, int timeout) async {
    await searchBLE(timeout: timeout);
    final index = state.devices.indexWhere((e) => e.advName == avdName);
    if (index == -1) {
      emit(
        state.copyWith(
          status: BleWifiStatus.error,
          hintText: 'Device not found',
        ),
      );
      return;
    }
    await connectToDeviceBLEByIndex(index);
  }

  Future<void> disconnectBLE() async {
    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Disconnecting BLE device...',
      ),
    );
    await repository.disconnectDeviceBLE();
    _temporaryHint(BleWifiStatus.success, 'Done', currentDeviceIndex: -1);
  }

  Future<void> makeMagic() async {
    if (repository.isBLEDeviceConnected) {
      // turn on wifi
      final resWifiLaunch = await repository.turnOnWifi();
      if (!resWifiLaunch) {
        _temporaryHint(BleWifiStatus.error, 'Failed to turn on wifi');
        return;
      }
      emit(state.copyWith(hintText: 'Wifi is ON'));

      //connect to wifi
      final uuid = state.devices[state.currentDeviceIndex].advName
          .split('IB_')
          .last;

      final resWifiConnect = await repository.connectToDeviceWifi(uuid);

      await repository.disconnectDeviceBLE();
      emit(state.copyWith(hintText: 'BLE device is disconnected'));

      if (!resWifiConnect) {
        _temporaryHint(
          BleWifiStatus.error,
          'Failed to connect on wifi network',
        );
        return;
      }
      emit(
        state.copyWith(
          hintText: 'Connected to device WiFi',
          isWifiConnected: true,
        ),
      );

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

      await repository.disconnectDeviceWifi();
      developer.log('repo::makeMagic. device wifi is disconnected.');
      emit(
        state.copyWith(
          hintText: 'WIFI device is disconnected.',
          isWifiConnected: false,
          currentDeviceIndex: -1,
        ),
      );

      developer.log('repo::makeMagic. reconnecting to internet...');
      emit(state.copyWith(hintText: 'Reconecting to Internet...'));
      while (!await repository.pingInternet()) {
        developer.log(
          'repo::makeMagic. reconnecting to internet... this try failed. trying again in a second...',
        );
        await Future.delayed(const Duration(seconds: 1));
      }
      developer.log('repo::makeMagic. reconnecting to internet... done.');
      emit(state.copyWith(hintText: 'Internet is reconnected.'));
      await Future.delayed(const Duration(seconds: 3));

      _temporaryHint(BleWifiStatus.success, 'Done', currentDeviceIndex: -1);
    } else {
      _temporaryHint(BleWifiStatus.success, 'Connect to device first');
    }
  }

  Future<void> _temporaryHint(
    BleWifiStatus status,
    String hint, {
    int secondsToShow = 3,
    int? currentDeviceIndex,
  }) async {
    emit(
      state.copyWith(
        status: status,
        hintText: hint,
        currentDeviceIndex: currentDeviceIndex ?? state.currentDeviceIndex,
      ),
    );
    await Future.delayed(Duration(seconds: secondsToShow));
    emit(state.copyWith(hintText: ''));
  }
}
