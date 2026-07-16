import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/reader_connection.dart';
import '../repository/ble_repository.dart';
import 'device_config.dart';

part 'reader_device.freezed.dart';

@freezed
abstract class ReaderDevice with _$ReaderDevice {
  const factory ReaderDevice({
    String? readerId,
    @Default(ReaderConnection.none) ReaderConnection connection,
    DeviceConfig? config,
  }) = _ReaderDevice;
}

extension ReaderDeviceExtension on ReaderDevice {
  String get name =>
      readerId != null ? '${BleRepository.blePrefix}$readerId' : '';
}
