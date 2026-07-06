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
      final desiredNerworkSsid = '$wifiSsid$uuid';
      developer.log(
        'repo::connectToDeviceWifi. connecting to device wifi...  $desiredNerworkSsid :: $wifiPassword',
      );
      var res = await _wifiService.connectToDeviceWifi(
        desiredNerworkSsid,
        wifiPassword,
      );

      if (res) {
        // if we are really connecting, we have to wait until the device is connected to the wifi network
        // or until we reach the timeout of 10 seconds
        var count = 0;
        var currentSsid = await currentWifiSsid;
        developer.log('current SSID: $currentSsid');
        while (desiredNerworkSsid != currentSsid || count < 20) {
          await Future.delayed(const Duration(milliseconds: 500));
          currentSsid = await currentWifiSsid;
          count++;
        }
        if (desiredNerworkSsid != currentSsid) {
          res = false;
        }
      }

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
