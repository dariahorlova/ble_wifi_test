import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/reader_connection.dart';
import 'device_config.dart';

part 'reader_device.freezed.dart';

/// A single reader device as the app knows it: the underlying BLE handle, the
/// current [connection] transport and, once read, its [config].
///
/// This is the unit the UI renders and the cubit mutates. Keeping the transport
/// on the device (instead of separate index/bool fields on the state) means the
/// UI can ask each card directly how it is connected.
@freezed
abstract class ReaderDevice with _$ReaderDevice {
  const ReaderDevice._();

  const factory ReaderDevice({
    required BluetoothDevice bleDevice,
    @Default(ReaderConnection.none) ReaderConnection connection,
    DeviceConfig? config,
  }) = _ReaderDevice;

  /// BLE advertised name = [blePrefix] + reader id.
  /// WiFi SSID = `INFINIBOOK_` + that same reader id.
  static const blePrefix = 'IB_';

  /// Stable identity across scans — the BLE remote id.
  String get id => bleDevice.remoteId.str;

  /// Advertised name as shown to the user (may be empty for some devices).
  String get name => bleDevice.advName.trim();

  /// Reader id without the [blePrefix]; used to build the WiFi SSID.
  String get readerId =>
      name.startsWith(blePrefix) ? name.substring(blePrefix.length) : name;

  bool get isConnected => connection != ReaderConnection.none;
  bool get isBleConnected => connection == ReaderConnection.ble;
  bool get isWifiConnected => connection == ReaderConnection.wifi;
}
