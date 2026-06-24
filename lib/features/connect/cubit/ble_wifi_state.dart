part of 'ble_wifi_cubit.dart';

enum BleWifiStatus { initial, loading, success, error }

@freezed
abstract class BleWifiState with _$BleWifiState {
  const BleWifiState._();

  const factory BleWifiState({
    @Default(BleWifiStatus.initial) BleWifiStatus status,
    @Default('') String hintText,
    @Default(<ReaderDevice>[]) List<ReaderDevice> devices,
  }) = _BleWifiState;

  /// The single device the app is currently talking to (over BLE or WiFi),
  /// or `null` if nothing is connected. Derived from [devices] so there is no
  /// separate index/flag to keep in sync.
  ReaderDevice? get connectedDevice {
    for (final device in devices) {
      if (device.isConnected) return device;
    }
    return null;
  }

  bool get isBusy => status == BleWifiStatus.loading;
}
