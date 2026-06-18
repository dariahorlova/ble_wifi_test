import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_booklets.freezed.dart';
part 'device_booklets.g.dart';

@freezed
abstract class DeviceBooklets with _$DeviceBooklets {
  const factory DeviceBooklets({
    required String id,
    @JsonKey(name: 'variants') required List<String> variantIds,
    @JsonKey(name: 'custom_recordings') required List<String> customRecordings,
  }) = _DeviceBooklets;

  factory DeviceBooklets.fromJson(Map<String, dynamic> json) =>
      _$DeviceBookletsFromJson(json);
}
