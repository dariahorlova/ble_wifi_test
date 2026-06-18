part of 'ble_wifi_cubit.dart';

enum BleWifiStatus { initial, loading, success, error }

@freezed
abstract class BleWifiState with _$BleWifiState {
  const factory BleWifiState({
    required BleWifiStatus status,
    @Default(-1) int currentDeviceIndex,
    @Default(false) bool isWifiConnected,
    @Default('') String hintText,
    @Default(<BluetoothDevice>[]) List<BluetoothDevice> devices,
    @Default(null) DeviceConfig? deviceConfig,
  }) = _BleWifiState;
}
