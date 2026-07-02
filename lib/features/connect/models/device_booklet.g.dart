// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_booklet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceBooklet _$DeviceBookletFromJson(Map<String, dynamic> json) =>
    _DeviceBooklet(
      id: json['id'] as String,
      variantIds: (json['variants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customRecordings: (json['custom_recordings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DeviceBookletToJson(_DeviceBooklet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variants': instance.variantIds,
      'custom_recordings': instance.customRecordings,
    };
