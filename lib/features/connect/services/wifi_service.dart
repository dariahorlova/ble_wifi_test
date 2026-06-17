import 'dart:developer' as developer;
import 'dart:io';

//import 'package:flutter_wifi_connect/flutter_wifi_connect.dart';

import 'package:plugin_wifi_connect/plugin_wifi_connect.dart';

class WifiService {
  factory WifiService() => _singleton;
  WifiService._();

  static final WifiService _singleton = WifiService._();

  Future<bool> connectToDeviceWifi(String ssid, String password) async {
    try {
      if (Platform.isAndroid) {
        final resWifiEnabled = await PluginWifiConnect.isEnabled;
        if (!resWifiEnabled) {
          await PluginWifiConnect.activateWifi();
        }
      }

      for (var i = 0; i < 5; i++) {
        developer.log(
          "wifiservice:: trying(${i + 1}) to connect to device's Wifi",
        );
        bool? isConnected = await PluginWifiConnect.connectToSecureNetwork(
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
      bool? isDisconnected = await PluginWifiConnect.disconnect();
      if (isDisconnected == true) {
        return true;
      }
    } catch (e) {
      developer.log("Disconnect error: $e");
    }
    return false;
  }

  Future<bool> connectToWifi(String ssid) async {
    try {
      bool? isConnected = await PluginWifiConnect.connect(
        ssid,
        saveNetwork: true,
      );

      if (isConnected == true) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log("wifiservice:: connectToWifi error: $e");
    }
    return false;
  }

  Future<String?> get currentWifiSsid => PluginWifiConnect.ssid;
}
