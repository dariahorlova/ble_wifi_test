import 'dart:async';
import 'dart:developer' as developer;

import 'package:ble_wifi_test/features/connect/services/internet_service.dart';
import 'package:ble_wifi_test/features/connect/services/nfc_service.dart';
import 'package:ble_wifi_test/features/connect/services/wifi_service.dart';

class CommonRepository {
  CommonRepository(this._nfcService, this._wifiService, this._internetService) {
    _nfcService.setLogLevel(NFCLogLevel.debug);
  }

  final NFCService _nfcService;
  final WifiService _wifiService;
  final InternetService _internetService;
  //WIFI settings
  static const wifiPassword = 'INFINIBOOK';
  static const wifiSsid = 'INFINIBOOK_';

  Future<void> dispose() async {
    await disconnectDeviceWifi();
  }

  //... wifi
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

  //... internet
  Future<bool> pingInternet() => _internetService.hasInternet();

  //... nfc
  Future<void> launchNFC(
    Future<void> Function({String? ndefData, String? error})? callback,
  ) => _nfcService.launch(callback);
}
