import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/device_config.dart';
import '../repository/ble_repository.dart';
import '../repository/common_repository.dart';

part 'ble_wifi_state.dart';
part 'ble_wifi_cubit.freezed.dart';

class BleWifiCubit extends Cubit<BleWifiState> {
  BleWifiCubit(this.repository, this._bleRepository)
    : super(const BleWifiState(status: BleWifiStatus.initial)) {
    _bleRepository.setLogLevel(BLERepoLogLevel.debug);
    launchNFC();
  }

  final CommonRepository repository;
  final BleRepository _bleRepository;

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

    //create an avdName from ndef
    final avdName = '${BleRepository.blePrefix}$ndefData';

    // launch flow
    await _autoconnectToDeviceBLE(avdName, 5);
    await updateDateTimeOnBle();
    await getDeviceConfigByBle();
    //await makeMagic();
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
          await _bleRepository.scanForDevices(
            withServices: [BleRepository.serviceUuid],
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
    final (res, hint) = await _bleRepository.connectToDevice(
      state.devices[index],
    );
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

  Future<void> getDeviceConfigByBle() async {
    final (res, config) = await _bleRepository.getConfig();
    emit(state.copyWith(deviceConfig: config));
    _temporaryHint(
      res ? BleWifiStatus.success : BleWifiStatus.error,
      'got config from BLE: $res',
    );
  }

  Future<void> updateDateTimeOnBle() => _bleRepository.setDateTime();

  Future<void> disconnectBLE() async {
    emit(
      state.copyWith(
        status: BleWifiStatus.loading,
        hintText: 'Disconnecting BLE device...',
        deviceConfig: null,
      ),
    );
    await _bleRepository.disconnect();
    _temporaryHint(BleWifiStatus.success, 'Done', currentDeviceIndex: -1);
  }

  Future<void> makeMagic() async {
    if (_bleRepository.isBLEDeviceConnected) {
      // turn on wifi
      final resWifiLaunch = await _bleRepository.turnOnWifi();
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
      await _bleRepository.disconnect();

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
