// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reader_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReaderDevice {

 BluetoothDevice get bleDevice; ReaderConnection get connection; DeviceConfig? get config;
/// Create a copy of ReaderDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReaderDeviceCopyWith<ReaderDevice> get copyWith => _$ReaderDeviceCopyWithImpl<ReaderDevice>(this as ReaderDevice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReaderDevice&&(identical(other.bleDevice, bleDevice) || other.bleDevice == bleDevice)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,bleDevice,connection,config);

@override
String toString() {
  return 'ReaderDevice(bleDevice: $bleDevice, connection: $connection, config: $config)';
}


}

/// @nodoc
abstract mixin class $ReaderDeviceCopyWith<$Res>  {
  factory $ReaderDeviceCopyWith(ReaderDevice value, $Res Function(ReaderDevice) _then) = _$ReaderDeviceCopyWithImpl;
@useResult
$Res call({
 BluetoothDevice bleDevice, ReaderConnection connection, DeviceConfig? config
});


$DeviceConfigCopyWith<$Res>? get config;

}
/// @nodoc
class _$ReaderDeviceCopyWithImpl<$Res>
    implements $ReaderDeviceCopyWith<$Res> {
  _$ReaderDeviceCopyWithImpl(this._self, this._then);

  final ReaderDevice _self;
  final $Res Function(ReaderDevice) _then;

/// Create a copy of ReaderDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bleDevice = null,Object? connection = null,Object? config = freezed,}) {
  return _then(_self.copyWith(
bleDevice: null == bleDevice ? _self.bleDevice : bleDevice // ignore: cast_nullable_to_non_nullable
as BluetoothDevice,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as ReaderConnection,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as DeviceConfig?,
  ));
}
/// Create a copy of ReaderDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceConfigCopyWith<$Res>? get config {
    if (_self.config == null) {
    return null;
  }

  return $DeviceConfigCopyWith<$Res>(_self.config!, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReaderDevice].
extension ReaderDevicePatterns on ReaderDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReaderDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReaderDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReaderDevice value)  $default,){
final _that = this;
switch (_that) {
case _ReaderDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReaderDevice value)?  $default,){
final _that = this;
switch (_that) {
case _ReaderDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BluetoothDevice bleDevice,  ReaderConnection connection,  DeviceConfig? config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReaderDevice() when $default != null:
return $default(_that.bleDevice,_that.connection,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BluetoothDevice bleDevice,  ReaderConnection connection,  DeviceConfig? config)  $default,) {final _that = this;
switch (_that) {
case _ReaderDevice():
return $default(_that.bleDevice,_that.connection,_that.config);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BluetoothDevice bleDevice,  ReaderConnection connection,  DeviceConfig? config)?  $default,) {final _that = this;
switch (_that) {
case _ReaderDevice() when $default != null:
return $default(_that.bleDevice,_that.connection,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _ReaderDevice extends ReaderDevice {
  const _ReaderDevice({required this.bleDevice, this.connection = ReaderConnection.none, this.config}): super._();
  

@override final  BluetoothDevice bleDevice;
@override@JsonKey() final  ReaderConnection connection;
@override final  DeviceConfig? config;

/// Create a copy of ReaderDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReaderDeviceCopyWith<_ReaderDevice> get copyWith => __$ReaderDeviceCopyWithImpl<_ReaderDevice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReaderDevice&&(identical(other.bleDevice, bleDevice) || other.bleDevice == bleDevice)&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,bleDevice,connection,config);

@override
String toString() {
  return 'ReaderDevice(bleDevice: $bleDevice, connection: $connection, config: $config)';
}


}

/// @nodoc
abstract mixin class _$ReaderDeviceCopyWith<$Res> implements $ReaderDeviceCopyWith<$Res> {
  factory _$ReaderDeviceCopyWith(_ReaderDevice value, $Res Function(_ReaderDevice) _then) = __$ReaderDeviceCopyWithImpl;
@override @useResult
$Res call({
 BluetoothDevice bleDevice, ReaderConnection connection, DeviceConfig? config
});


@override $DeviceConfigCopyWith<$Res>? get config;

}
/// @nodoc
class __$ReaderDeviceCopyWithImpl<$Res>
    implements _$ReaderDeviceCopyWith<$Res> {
  __$ReaderDeviceCopyWithImpl(this._self, this._then);

  final _ReaderDevice _self;
  final $Res Function(_ReaderDevice) _then;

/// Create a copy of ReaderDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bleDevice = null,Object? connection = null,Object? config = freezed,}) {
  return _then(_ReaderDevice(
bleDevice: null == bleDevice ? _self.bleDevice : bleDevice // ignore: cast_nullable_to_non_nullable
as BluetoothDevice,connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as ReaderConnection,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as DeviceConfig?,
  ));
}

/// Create a copy of ReaderDevice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceConfigCopyWith<$Res>? get config {
    if (_self.config == null) {
    return null;
  }

  return $DeviceConfigCopyWith<$Res>(_self.config!, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
