// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_booklets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceBooklets _$DeviceBookletsFromJson(Map<String, dynamic> json) =>
    _DeviceBooklets(
      id: json['id'] as String,
      variantIds: (json['variants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customRecordings: (json['custom_recordings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DeviceBookletsToJson(_DeviceBooklets instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variants': instance.variantIds,
      'custom_recordings': instance.customRecordings,
    };
