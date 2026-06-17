import 'dart:developer' as developer;

import 'package:tm_wifi_connect/tm_wifi_connect.dart';

class WifiService {
  factory WifiService() => _singleton;
  WifiService._();

  static final WifiService _singleton = WifiService._();

  Future<bool> connectToDeviceWifi(String ssid, String password) async {
    try {
      final resWifiEnabled = await TechmagicWifiConnect.isEnabled;
      if (!resWifiEnabled) {
        final resTurnOn = await TechmagicWifiConnect.activateWifi();
        if (!resTurnOn) {
          developer.log(
            "wifiservice:: wifi module is off. Turn it on and try again",
          );
          return false;
        }
      }

      for (var i = 0; i < 5; i++) {
        developer.log(
          "wifiservice:: trying(${i + 1}) to connect to device's Wifi",
        );
        bool? isConnected = await TechmagicWifiConnect.connectToSecureNetwork(
          ssid,
          password,
          saveNetwork: true,
        );
        if (isConnected == true) {
          return true;
        }
        await Future.delayed(const Duration(seconds: 1));
      }

      return false;
    } catch (e) {
      developer.log("wifiservice:: connectToWifi error: $e");
    }
    return false;
  }

  Future<bool> disconnect() async {
    try {
      bool? isDisconnected = await TechmagicWifiConnect.disconnect();
      if (isDisconnected == true) {
        return true;
      }
    } catch (e) {
      developer.log("Disconnect error: $e");
    }
    return false;
  }

  Future<String?> get currentWifiSsid => TechmagicWifiConnect.ssid;
}
