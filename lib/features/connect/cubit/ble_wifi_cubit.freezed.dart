// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_wifi_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleWifiState {

 BleWifiStatus get status; int get currentDeviceIndex; bool get isWifiConnected; String get hintText; List<BluetoothDevice> get devices; DeviceConfig? get deviceConfig;
/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleWifiStateCopyWith<BleWifiState> get copyWith => _$BleWifiStateCopyWithImpl<BleWifiState>(this as BleWifiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleWifiState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentDeviceIndex, currentDeviceIndex) || other.currentDeviceIndex == currentDeviceIndex)&&(identical(other.isWifiConnected, isWifiConnected) || other.isWifiConnected == isWifiConnected)&&(identical(other.hintText, hintText) || other.hintText == hintText)&&const DeepCollectionEquality().equals(other.devices, devices)&&(identical(other.deviceConfig, deviceConfig) || other.deviceConfig == deviceConfig));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentDeviceIndex,isWifiConnected,hintText,const DeepCollectionEquality().hash(devices),deviceConfig);

@override
String toString() {
  return 'BleWifiState(status: $status, currentDeviceIndex: $currentDeviceIndex, isWifiConnected: $isWifiConnected, hintText: $hintText, devices: $devices, deviceConfig: $deviceConfig)';
}


}

/// @nodoc
abstract mixin class $BleWifiStateCopyWith<$Res>  {
  factory $BleWifiStateCopyWith(BleWifiState value, $Res Function(BleWifiState) _then) = _$BleWifiStateCopyWithImpl;
@useResult
$Res call({
 BleWifiStatus status, int currentDeviceIndex, bool isWifiConnected, String hintText, List<BluetoothDevice> devices, DeviceConfig? deviceConfig
});


$DeviceConfigCopyWith<$Res>? get deviceConfig;

}
/// @nodoc
class _$BleWifiStateCopyWithImpl<$Res>
    implements $BleWifiStateCopyWith<$Res> {
  _$BleWifiStateCopyWithImpl(this._self, this._then);

  final BleWifiState _self;
  final $Res Function(BleWifiState) _then;

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? currentDeviceIndex = null,Object? isWifiConnected = null,Object? hintText = null,Object? devices = null,Object? deviceConfig = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BleWifiStatus,currentDeviceIndex: null == currentDeviceIndex ? _self.currentDeviceIndex : currentDeviceIndex // ignore: cast_nullable_to_non_nullable
as int,isWifiConnected: null == isWifiConnected ? _self.isWifiConnected : isWifiConnected // ignore: cast_nullable_to_non_nullable
as bool,hintText: null == hintText ? _self.hintText : hintText // ignore: cast_nullable_to_non_nullable
as String,devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<BluetoothDevice>,deviceConfig: freezed == deviceConfig ? _self.deviceConfig : deviceConfig // ignore: cast_nullable_to_non_nullable
as DeviceConfig?,
  ));
}
/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceConfigCopyWith<$Res>? get deviceConfig {
    if (_self.deviceConfig == null) {
    return null;
  }

  return $DeviceConfigCopyWith<$Res>(_self.deviceConfig!, (value) {
    return _then(_self.copyWith(deviceConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [BleWifiState].
extension BleWifiStatePatterns on BleWifiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BleWifiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BleWifiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BleWifiState value)  $default,){
final _that = this;
switch (_that) {
case _BleWifiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BleWifiState value)?  $default,){
final _that = this;
switch (_that) {
case _BleWifiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BleWifiStatus status,  int currentDeviceIndex,  bool isWifiConnected,  String hintText,  List<BluetoothDevice> devices,  DeviceConfig? deviceConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BleWifiState() when $default != null:
return $default(_that.status,_that.currentDeviceIndex,_that.isWifiConnected,_that.hintText,_that.devices,_that.deviceConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BleWifiStatus status,  int currentDeviceIndex,  bool isWifiConnected,  String hintText,  List<BluetoothDevice> devices,  DeviceConfig? deviceConfig)  $default,) {final _that = this;
switch (_that) {
case _BleWifiState():
return $default(_that.status,_that.currentDeviceIndex,_that.isWifiConnected,_that.hintText,_that.devices,_that.deviceConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BleWifiStatus status,  int currentDeviceIndex,  bool isWifiConnected,  String hintText,  List<BluetoothDevice> devices,  DeviceConfig? deviceConfig)?  $default,) {final _that = this;
switch (_that) {
case _BleWifiState() when $default != null:
return $default(_that.status,_that.currentDeviceIndex,_that.isWifiConnected,_that.hintText,_that.devices,_that.deviceConfig);case _:
  return null;

}
}

}

/// @nodoc


class _BleWifiState implements BleWifiState {
  const _BleWifiState({required this.status, this.currentDeviceIndex = -1, this.isWifiConnected = false, this.hintText = '', final  List<BluetoothDevice> devices = const <BluetoothDevice>[], this.deviceConfig = null}): _devices = devices;
  

@override final  BleWifiStatus status;
@override@JsonKey() final  int currentDeviceIndex;
@override@JsonKey() final  bool isWifiConnected;
@override@JsonKey() final  String hintText;
 final  List<BluetoothDevice> _devices;
@override@JsonKey() List<BluetoothDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

@override@JsonKey() final  DeviceConfig? deviceConfig;

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BleWifiStateCopyWith<_BleWifiState> get copyWith => __$BleWifiStateCopyWithImpl<_BleWifiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BleWifiState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentDeviceIndex, currentDeviceIndex) || other.currentDeviceIndex == currentDeviceIndex)&&(identical(other.isWifiConnected, isWifiConnected) || other.isWifiConnected == isWifiConnected)&&(identical(other.hintText, hintText) || other.hintText == hintText)&&const DeepCollectionEquality().equals(other._devices, _devices)&&(identical(other.deviceConfig, deviceConfig) || other.deviceConfig == deviceConfig));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentDeviceIndex,isWifiConnected,hintText,const DeepCollectionEquality().hash(_devices),deviceConfig);

@override
String toString() {
  return 'BleWifiState(status: $status, currentDeviceIndex: $currentDeviceIndex, isWifiConnected: $isWifiConnected, hintText: $hintText, devices: $devices, deviceConfig: $deviceConfig)';
}


}

/// @nodoc
abstract mixin class _$BleWifiStateCopyWith<$Res> implements $BleWifiStateCopyWith<$Res> {
  factory _$BleWifiStateCopyWith(_BleWifiState value, $Res Function(_BleWifiState) _then) = __$BleWifiStateCopyWithImpl;
@override @useResult
$Res call({
 BleWifiStatus status, int currentDeviceIndex, bool isWifiConnected, String hintText, List<BluetoothDevice> devices, DeviceConfig? deviceConfig
});


@override $DeviceConfigCopyWith<$Res>? get deviceConfig;

}
/// @nodoc
class __$BleWifiStateCopyWithImpl<$Res>
    implements _$BleWifiStateCopyWith<$Res> {
  __$BleWifiStateCopyWithImpl(this._self, this._then);

  final _BleWifiState _self;
  final $Res Function(_BleWifiState) _then;

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? currentDeviceIndex = null,Object? isWifiConnected = null,Object? hintText = null,Object? devices = null,Object? deviceConfig = freezed,}) {
  return _then(_BleWifiState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BleWifiStatus,currentDeviceIndex: null == currentDeviceIndex ? _self.currentDeviceIndex : currentDeviceIndex // ignore: cast_nullable_to_non_nullable
as int,isWifiConnected: null == isWifiConnected ? _self.isWifiConnected : isWifiConnected // ignore: cast_nullable_to_non_nullable
as bool,hintText: null == hintText ? _self.hintText : hintText // ignore: cast_nullable_to_non_nullable
as String,devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<BluetoothDevice>,deviceConfig: freezed == deviceConfig ? _self.deviceConfig : deviceConfig // ignore: cast_nullable_to_non_nullable
as DeviceConfig?,
  ));
}

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceConfigCopyWith<$Res>? get deviceConfig {
    if (_self.deviceConfig == null) {
    return null;
  }

  return $DeviceConfigCopyWith<$Res>(_self.deviceConfig!, (value) {
    return _then(_self.copyWith(deviceConfig: value));
  });
}
}

// dart format on
