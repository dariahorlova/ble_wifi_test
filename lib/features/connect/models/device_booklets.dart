import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_booklets.freezed.dart';
part 'device_booklets.g.dart';

@freezed
abstract class DeviceBooklet with _$DeviceBooklet {
  const factory DeviceBooklet({
    required String id,
    @JsonKey(name: 'variants') required List<String> variantIds,
    @JsonKey(name: 'custom_recordings') required List<String> customRecordings,
  }) = _DeviceBooklets;

  factory DeviceBooklet.fromJson(Map<String, dynamic> json) =>
      _$DeviceBookletsFromJson(json);
}
