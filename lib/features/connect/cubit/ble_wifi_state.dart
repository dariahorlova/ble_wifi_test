part of 'ble_wifi_cubit.dart';

enum BleWifiStatus { initial, loading, success, error }

@freezed
abstract class BleWifiState with _$BleWifiState {
  const factory BleWifiState({
    required BleWifiStatus status,
    @Default('') String hintText,
    ReaderDevice? readerDevice,
  }) = _BleWifiState;
}
