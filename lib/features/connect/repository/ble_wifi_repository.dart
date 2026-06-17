import 'dart:async';
import 'dart:developer' as developer;

import 'package:ble_wifi_test/features/connect/services/internet_service.dart';
import 'package:ble_wifi_test/features/connect/services/wifi_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../services/ble_service.dart';

class BLEWIFIRepository {
  BLEWIFIRepository(this._bleService, this._wifiService, this._internetService);

  final BLEService _bleService;
  final WifiService _wifiService;
  final InternetService _internetService;
  //BLE settings
  static const String serviceUuid = 'ca23911f-cbb4-43ef-8509-87f7c9852d71';
  static const commandCharacteristicId = '26fd90a8-75a2-b5a2-774d-5fbd530c10a7';
  //WIFI settings
  static const wifiPassword = 'INFINIBOOK';
  static const wifiSsid = 'INFINIBOOK_';

  bool get isBLEDeviceConnected => _bleService.isBLEDeviceConnected;

  Future<(bool, String)> connectToDevice(BluetoothDevice device) =>
      _bleService.connectToDevice(device);

  /// disconnect connectedDevice
  Future<void> disconnectDeviceBLE() => _bleService.disconnect();

  /// scan for devices. we need in function that we can launch and get all it found
  /// as a list. we dont want to use a stream [FlutterBluePlus.scanResults] as is
  Future<List<ScanResult>?> scanForDevices({
    List<String> withServices = const [],
    Duration? timeout,
  }) =>
      _bleService.scanForDevices(withServices: withServices, timeout: timeout);

  Future<void> dispose() async {
    await disconnectDeviceBLE();
    await disconnectDeviceWifi();
  }

  Future<bool> turnOnWifi() async {
    try {
      developer.log('repo::turnOnWifi. sending BLE command to turn on wifi...');

      final commandBytes = [9, 4];
      await _bleService.write(
        _bleService.getCharacteristicByUuidString(commandCharacteristicId),
        commandBytes,
      );
      developer.log(
        'repo::turnOnWifi. sending BLE command to turn on wifi... done',
      );
      return true;
    } catch (e) {
      developer.log('repo::turnOnWifi. failed to turn on wifi: $e');
    }
    return false;
  }

  Future<bool> connectToDeviceWifi(String uuid) async {
    try {
      developer.log(
        'repo::connectToDeviceWifi. connecting to device wifi...  $wifiSsid$uuid :: $wifiPassword',
      );
      final res = await _wifiService.connectToDeviceWifi(
        '$wifiSsid$uuid',
        wifiPassword,
      );
      developer.log(
        'repo::connectToDeviceWifi. connecting to device wifi... $res',
      );
      return res;
    } catch (e) {
      developer.log('repo::connectToDeviceWifi. failed to connect on wifi: $e');
    }
    return false;
  }

  Future<String?> get currentWifiSsid => _wifiService.currentWifiSsid;

  Future<bool> disconnectDeviceWifi() => _wifiService.disconnect();

  Future<bool> connectToWifi(String ssid) => _wifiService.connectToWifi(ssid);

  Future<bool> pingInternet() => _internetService.hasInternet();
}
