import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/transfer_status.dart';
import 'device_booklets.dart';

part 'device_config.freezed.dart';

@freezed
abstract class DeviceConfig with _$DeviceConfig {
  const factory DeviceConfig({
    required String childName,
    required String readerId,
    @Default(null) String? firmwareVersion,
    @Default(0) int transferStatus,
    @Default(0) int batteryLevel,
    @Default(null) String? currentStoryKey,
    @Default(0) int remainingStorageMb,
    @Default(null) List<DeviceBooklets>? booklets,
    @Default(null) String? readerBleId,
    @Default(null) List<String>? possibleConnectedBookletIds,
  }) = _DeviceConfig;

  factory DeviceConfig.fromBytes(Uint8List bytes) {
    final data = ByteData.sublistView(bytes);

    return DeviceConfig(
      childName: 'child',
      readerId: data.buffer
          .asUint8List(4, 6)
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join(),
      firmwareVersion:
          '${data.getUint8(0)}.${data.getUint8(1)}.${data.getUint8(2)}',
      transferStatus: TransferStatus.fromValue(data.getUint8(3)).value,
      batteryLevel: data.getUint8(10),
      currentStoryKey: utf8.decode(data.buffer.asUint8List(11, 16)),
    );
  }
}
