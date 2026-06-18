// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeviceConfig {

 String get childName; String get readerId; String? get firmwareVersion; int get transferStatus; int get batteryLevel; String? get currentStoryKey; int get remainingStorageMb; List<DeviceBooklets>? get booklets; String? get readerBleId; List<String>? get possibleConnectedBookletIds;
/// Create a copy of DeviceConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceConfigCopyWith<DeviceConfig> get copyWith => _$DeviceConfigCopyWithImpl<DeviceConfig>(this as DeviceConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceConfig&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.readerId, readerId) || other.readerId == readerId)&&(identical(other.firmwareVersion, firmwareVersion) || other.firmwareVersion == firmwareVersion)&&(identical(other.transferStatus, transferStatus) || other.transferStatus == transferStatus)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.currentStoryKey, currentStoryKey) || other.currentStoryKey == currentStoryKey)&&(identical(other.remainingStorageMb, remainingStorageMb) || other.remainingStorageMb == remainingStorageMb)&&const DeepCollectionEquality().equals(other.booklets, booklets)&&(identical(other.readerBleId, readerBleId) || other.readerBleId == readerBleId)&&const DeepCollectionEquality().equals(other.possibleConnectedBookletIds, possibleConnectedBookletIds));
}


@override
int get hashCode => Object.hash(runtimeType,childName,readerId,firmwareVersion,transferStatus,batteryLevel,currentStoryKey,remainingStorageMb,const DeepCollectionEquality().hash(booklets),readerBleId,const DeepCollectionEquality().hash(possibleConnectedBookletIds));

@override
String toString() {
  return 'DeviceConfig(childName: $childName, readerId: $readerId, firmwareVersion: $firmwareVersion, transferStatus: $transferStatus, batteryLevel: $batteryLevel, currentStoryKey: $currentStoryKey, remainingStorageMb: $remainingStorageMb, booklets: $booklets, readerBleId: $readerBleId, possibleConnectedBookletIds: $possibleConnectedBookletIds)';
}


}

/// @nodoc
abstract mixin class $DeviceConfigCopyWith<$Res>  {
  factory $DeviceConfigCopyWith(DeviceConfig value, $Res Function(DeviceConfig) _then) = _$DeviceConfigCopyWithImpl;
@useResult
$Res call({
 String childName, String readerId, String? firmwareVersion, int transferStatus, int batteryLevel, String? currentStoryKey, int remainingStorageMb, List<DeviceBooklets>? booklets, String? readerBleId, List<String>? possibleConnectedBookletIds
});




}
/// @nodoc
class _$DeviceConfigCopyWithImpl<$Res>
    implements $DeviceConfigCopyWith<$Res> {
  _$DeviceConfigCopyWithImpl(this._self, this._then);

  final DeviceConfig _self;
  final $Res Function(DeviceConfig) _then;

/// Create a copy of DeviceConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childName = null,Object? readerId = null,Object? firmwareVersion = freezed,Object? transferStatus = null,Object? batteryLevel = null,Object? currentStoryKey = freezed,Object? remainingStorageMb = null,Object? booklets = freezed,Object? readerBleId = freezed,Object? possibleConnectedBookletIds = freezed,}) {
  return _then(_self.copyWith(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,readerId: null == readerId ? _self.readerId : readerId // ignore: cast_nullable_to_non_nullable
as String,firmwareVersion: freezed == firmwareVersion ? _self.firmwareVersion : firmwareVersion // ignore: cast_nullable_to_non_nullable
as String?,transferStatus: null == transferStatus ? _self.transferStatus : transferStatus // ignore: cast_nullable_to_non_nullable
as int,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,currentStoryKey: freezed == currentStoryKey ? _self.currentStoryKey : currentStoryKey // ignore: cast_nullable_to_non_nullable
as String?,remainingStorageMb: null == remainingStorageMb ? _self.remainingStorageMb : remainingStorageMb // ignore: cast_nullable_to_non_nullable
as int,booklets: freezed == booklets ? _self.booklets : booklets // ignore: cast_nullable_to_non_nullable
as List<DeviceBooklets>?,readerBleId: freezed == readerBleId ? _self.readerBleId : readerBleId // ignore: cast_nullable_to_non_nullable
as String?,possibleConnectedBookletIds: freezed == possibleConnectedBookletIds ? _self.possibleConnectedBookletIds : possibleConnectedBookletIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceConfig].
extension DeviceConfigPatterns on DeviceConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceConfig value)  $default,){
final _that = this;
switch (_that) {
case _DeviceConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childName,  String readerId,  String? firmwareVersion,  int transferStatus,  int batteryLevel,  String? currentStoryKey,  int remainingStorageMb,  List<DeviceBooklets>? booklets,  String? readerBleId,  List<String>? possibleConnectedBookletIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceConfig() when $default != null:
return $default(_that.childName,_that.readerId,_that.firmwareVersion,_that.transferStatus,_that.batteryLevel,_that.currentStoryKey,_that.remainingStorageMb,_that.booklets,_that.readerBleId,_that.possibleConnectedBookletIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childName,  String readerId,  String? firmwareVersion,  int transferStatus,  int batteryLevel,  String? currentStoryKey,  int remainingStorageMb,  List<DeviceBooklets>? booklets,  String? readerBleId,  List<String>? possibleConnectedBookletIds)  $default,) {final _that = this;
switch (_that) {
case _DeviceConfig():
return $default(_that.childName,_that.readerId,_that.firmwareVersion,_that.transferStatus,_that.batteryLevel,_that.currentStoryKey,_that.remainingStorageMb,_that.booklets,_that.readerBleId,_that.possibleConnectedBookletIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childName,  String readerId,  String? firmwareVersion,  int transferStatus,  int batteryLevel,  String? currentStoryKey,  int remainingStorageMb,  List<DeviceBooklets>? booklets,  String? readerBleId,  List<String>? possibleConnectedBookletIds)?  $default,) {final _that = this;
switch (_that) {
case _DeviceConfig() when $default != null:
return $default(_that.childName,_that.readerId,_that.firmwareVersion,_that.transferStatus,_that.batteryLevel,_that.currentStoryKey,_that.remainingStorageMb,_that.booklets,_that.readerBleId,_that.possibleConnectedBookletIds);case _:
  return null;

}
}

}

/// @nodoc


class _DeviceConfig implements DeviceConfig {
  const _DeviceConfig({required this.childName, required this.readerId, this.firmwareVersion = null, this.transferStatus = 0, this.batteryLevel = 0, this.currentStoryKey = null, this.remainingStorageMb = 0, final  List<DeviceBooklets>? booklets = null, this.readerBleId = null, final  List<String>? possibleConnectedBookletIds = null}): _booklets = booklets,_possibleConnectedBookletIds = possibleConnectedBookletIds;
  

@override final  String childName;
@override final  String readerId;
@override@JsonKey() final  String? firmwareVersion;
@override@JsonKey() final  int transferStatus;
@override@JsonKey() final  int batteryLevel;
@override@JsonKey() final  String? currentStoryKey;
@override@JsonKey() final  int remainingStorageMb;
 final  List<DeviceBooklets>? _booklets;
@override@JsonKey() List<DeviceBooklets>? get booklets {
  final value = _booklets;
  if (value == null) return null;
  if (_booklets is EqualUnmodifiableListView) return _booklets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  String? readerBleId;
 final  List<String>? _possibleConnectedBookletIds;
@override@JsonKey() List<String>? get possibleConnectedBookletIds {
  final value = _possibleConnectedBookletIds;
  if (value == null) return null;
  if (_possibleConnectedBookletIds is EqualUnmodifiableListView) return _possibleConnectedBookletIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of DeviceConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceConfigCopyWith<_DeviceConfig> get copyWith => __$DeviceConfigCopyWithImpl<_DeviceConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceConfig&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.readerId, readerId) || other.readerId == readerId)&&(identical(other.firmwareVersion, firmwareVersion) || other.firmwareVersion == firmwareVersion)&&(identical(other.transferStatus, transferStatus) || other.transferStatus == transferStatus)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.currentStoryKey, currentStoryKey) || other.currentStoryKey == currentStoryKey)&&(identical(other.remainingStorageMb, remainingStorageMb) || other.remainingStorageMb == remainingStorageMb)&&const DeepCollectionEquality().equals(other._booklets, _booklets)&&(identical(other.readerBleId, readerBleId) || other.readerBleId == readerBleId)&&const DeepCollectionEquality().equals(other._possibleConnectedBookletIds, _possibleConnectedBookletIds));
}


@override
int get hashCode => Object.hash(runtimeType,childName,readerId,firmwareVersion,transferStatus,batteryLevel,currentStoryKey,remainingStorageMb,const DeepCollectionEquality().hash(_booklets),readerBleId,const DeepCollectionEquality().hash(_possibleConnectedBookletIds));

@override
String toString() {
  return 'DeviceConfig(childName: $childName, readerId: $readerId, firmwareVersion: $firmwareVersion, transferStatus: $transferStatus, batteryLevel: $batteryLevel, currentStoryKey: $currentStoryKey, remainingStorageMb: $remainingStorageMb, booklets: $booklets, readerBleId: $readerBleId, possibleConnectedBookletIds: $possibleConnectedBookletIds)';
}


}

/// @nodoc
abstract mixin class _$DeviceConfigCopyWith<$Res> implements $DeviceConfigCopyWith<$Res> {
  factory _$DeviceConfigCopyWith(_DeviceConfig value, $Res Function(_DeviceConfig) _then) = __$DeviceConfigCopyWithImpl;
@override @useResult
$Res call({
 String childName, String readerId, String? firmwareVersion, int transferStatus, int batteryLevel, String? currentStoryKey, int remainingStorageMb, List<DeviceBooklets>? booklets, String? readerBleId, List<String>? possibleConnectedBookletIds
});




}
/// @nodoc
class __$DeviceConfigCopyWithImpl<$Res>
    implements _$DeviceConfigCopyWith<$Res> {
  __$DeviceConfigCopyWithImpl(this._self, this._then);

  final _DeviceConfig _self;
  final $Res Function(_DeviceConfig) _then;

/// Create a copy of DeviceConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childName = null,Object? readerId = null,Object? firmwareVersion = freezed,Object? transferStatus = null,Object? batteryLevel = null,Object? currentStoryKey = freezed,Object? remainingStorageMb = null,Object? booklets = freezed,Object? readerBleId = freezed,Object? possibleConnectedBookletIds = freezed,}) {
  return _then(_DeviceConfig(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,readerId: null == readerId ? _self.readerId : readerId // ignore: cast_nullable_to_non_nullable
as String,firmwareVersion: freezed == firmwareVersion ? _self.firmwareVersion : firmwareVersion // ignore: cast_nullable_to_non_nullable
as String?,transferStatus: null == transferStatus ? _self.transferStatus : transferStatus // ignore: cast_nullable_to_non_nullable
as int,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int,currentStoryKey: freezed == currentStoryKey ? _self.currentStoryKey : currentStoryKey // ignore: cast_nullable_to_non_nullable
as String?,remainingStorageMb: null == remainingStorageMb ? _self.remainingStorageMb : remainingStorageMb // ignore: cast_nullable_to_non_nullable
as int,booklets: freezed == booklets ? _self._booklets : booklets // ignore: cast_nullable_to_non_nullable
as List<DeviceBooklets>?,readerBleId: freezed == readerBleId ? _self.readerBleId : readerBleId // ignore: cast_nullable_to_non_nullable
as String?,possibleConnectedBookletIds: freezed == possibleConnectedBookletIds ? _self._possibleConnectedBookletIds : possibleConnectedBookletIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
