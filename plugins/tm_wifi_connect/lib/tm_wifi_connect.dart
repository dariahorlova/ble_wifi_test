import 'dart:async';
import 'package:flutter/services.dart';

/// Techmagic WiFi connect plugin.
///
/// Drop-in replacement for `plugin_wifi_connect` that additionally implements
/// [isEnabled], [activateWifi] and [deactivateWifi] on iOS (the original
/// package only supports those on Android).
///
/// Because neither modern Android (API 29+) nor iOS expose a public API to
/// toggle the WiFi radio programmatically, [activateWifi]/[deactivateWifi]
/// open the system WiFi settings and then poll [isEnabled] for up to 30
/// seconds (twice per second), resolving to `true` once the radio reaches the
/// requested state or `false` on timeout.
class TechmagicWifiConnect {
  static const MethodChannel _channel = MethodChannel('tm_wifi_connect');

  /// Returns `true` if the WiFi radio is currently enabled.
  ///
  /// On Android this reflects `WifiManager.isWifiEnabled`. On iOS it is a
  /// best-effort detection based on the `awdl0` interface state.
  static Future<bool> get isEnabled async {
    final bool enabled =
        await _channel.invokeMethod<bool>('isWifiEnabled') ?? false;
    return enabled;
  }

  /// Turns WiFi on.
  ///
  /// Resolves to `true` once the radio is enabled, or `false` if it is still
  /// disabled after the 30s timeout. May send the user to the system WiFi
  /// settings (Android 10+, iOS) since the radio cannot be toggled silently.
  static Future<bool> activateWifi() async {
    final bool result =
        await _channel.invokeMethod<bool>('activateWifi') ?? false;
    return result;
  }

  /// Turns WiFi off.
  ///
  /// Resolves to `true` once the radio is disabled, or `false` if it is still
  /// enabled after the 30s timeout. May send the user to the system WiFi
  /// settings (Android 10+, iOS).
  static Future<bool> deactivateWifi() async {
    final bool result =
        await _channel.invokeMethod<bool>('deactivateWifi') ?? false;
    return result;
  }

  /// Attempts to connect to the WiFi network matching exactly [ssid].
  static Future<bool?> connect(String ssid, {bool saveNetwork = false}) async {
    final bool? connected = await _channel.invokeMethod<bool>(
        'connect', {'ssid': ssid, 'saveNetwork': saveNetwork});
    return connected;
  }

  /// Attempts to connect to the nearest WiFi network whose SSID starts with
  /// [ssidPrefix].
  static Future<bool?> connectByPrefix(String ssidPrefix,
      {bool saveNetwork = false}) async {
    final bool? connected = await _channel.invokeMethod<bool>(
        'prefixConnect', {'ssid': ssidPrefix, 'saveNetwork': saveNetwork});
    return connected;
  }

  /// Attempts to connect to the secured WiFi network matching exactly [ssid]
  /// using [password]. Android does not support WEP networks.
  static Future<bool?> connectToSecureNetwork(String ssid, String password,
      {bool isWep = false,
      bool isWpa3 = false,
      bool saveNetwork = false,
      bool isHidden = false}) async {
    final bool? connected = await _channel.invokeMethod<bool>('secureConnect', {
      'ssid': ssid,
      'password': password,
      'saveNetwork': saveNetwork,
      'isWep': isWep,
      'isWpa3': isWpa3,
      'isHidden': isHidden,
    });
    return connected;
  }

  /// Attempts to connect to the nearest secured WiFi network whose SSID starts
  /// with [ssidPrefix] using [password]. Android does not support WEP networks.
  static Future<bool?> connectToSecureNetworkByPrefix(
      String ssidPrefix, String password,
      {bool isWep = false,
      bool isWpa3 = false,
      bool saveNetwork = false}) async {
    final bool? connected =
        await _channel.invokeMethod<bool>('securePrefixConnect', {
      'ssid': ssidPrefix,
      'password': password,
      'saveNetwork': saveNetwork,
      'isWep': isWep,
      'isWpa3': isWpa3,
    });
    return connected;
  }

  /// Disconnects from the WiFi network if it was joined via one of the
  /// `connect` methods.
  static Future<bool?> disconnect() => _channel.invokeMethod('disconnect');

  /// Reserved for future use. No-op.
  static Future<void> register() async {}

  /// Reserved for future use. No-op.
  static Future<void> unregister() async {}

  /// Returns the currently connected SSID, or `null` if not connected.
  static Future<String?> get ssid async {
    final String? ssid = await _channel.invokeMethod<String>('getSSID');
    return ssid;
  }
}
