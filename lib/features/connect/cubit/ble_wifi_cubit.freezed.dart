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

 BleWifiStatus get status;//@Default(-1) int currentDeviceIndex,
//@Default(false) bool isWifiConnected,
 String get hintText; ReaderDevice? get readerDevice;
/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleWifiStateCopyWith<BleWifiState> get copyWith => _$BleWifiStateCopyWithImpl<BleWifiState>(this as BleWifiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleWifiState&&(identical(other.status, status) || other.status == status)&&(identical(other.hintText, hintText) || other.hintText == hintText)&&(identical(other.readerDevice, readerDevice) || other.readerDevice == readerDevice));
}


@override
int get hashCode => Object.hash(runtimeType,status,hintText,readerDevice);

@override
String toString() {
  return 'BleWifiState(status: $status, hintText: $hintText, readerDevice: $readerDevice)';
}


}

/// @nodoc
abstract mixin class $BleWifiStateCopyWith<$Res>  {
  factory $BleWifiStateCopyWith(BleWifiState value, $Res Function(BleWifiState) _then) = _$BleWifiStateCopyWithImpl;
@useResult
$Res call({
 BleWifiStatus status, String hintText, ReaderDevice? readerDevice
});


$ReaderDeviceCopyWith<$Res>? get readerDevice;

}
/// @nodoc
class _$BleWifiStateCopyWithImpl<$Res>
    implements $BleWifiStateCopyWith<$Res> {
  _$BleWifiStateCopyWithImpl(this._self, this._then);

  final BleWifiState _self;
  final $Res Function(BleWifiState) _then;

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? hintText = null,Object? readerDevice = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BleWifiStatus,hintText: null == hintText ? _self.hintText : hintText // ignore: cast_nullable_to_non_nullable
as String,readerDevice: freezed == readerDevice ? _self.readerDevice : readerDevice // ignore: cast_nullable_to_non_nullable
as ReaderDevice?,
  ));
}
/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReaderDeviceCopyWith<$Res>? get readerDevice {
    if (_self.readerDevice == null) {
    return null;
  }

  return $ReaderDeviceCopyWith<$Res>(_self.readerDevice!, (value) {
    return _then(_self.copyWith(readerDevice: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BleWifiStatus status,  String hintText,  ReaderDevice? readerDevice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BleWifiState() when $default != null:
return $default(_that.status,_that.hintText,_that.readerDevice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BleWifiStatus status,  String hintText,  ReaderDevice? readerDevice)  $default,) {final _that = this;
switch (_that) {
case _BleWifiState():
return $default(_that.status,_that.hintText,_that.readerDevice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BleWifiStatus status,  String hintText,  ReaderDevice? readerDevice)?  $default,) {final _that = this;
switch (_that) {
case _BleWifiState() when $default != null:
return $default(_that.status,_that.hintText,_that.readerDevice);case _:
  return null;

}
}

}

/// @nodoc


class _BleWifiState implements BleWifiState {
  const _BleWifiState({required this.status, this.hintText = '', this.readerDevice});
  

@override final  BleWifiStatus status;
//@Default(-1) int currentDeviceIndex,
//@Default(false) bool isWifiConnected,
@override@JsonKey() final  String hintText;
@override final  ReaderDevice? readerDevice;

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BleWifiStateCopyWith<_BleWifiState> get copyWith => __$BleWifiStateCopyWithImpl<_BleWifiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BleWifiState&&(identical(other.status, status) || other.status == status)&&(identical(other.hintText, hintText) || other.hintText == hintText)&&(identical(other.readerDevice, readerDevice) || other.readerDevice == readerDevice));
}


@override
int get hashCode => Object.hash(runtimeType,status,hintText,readerDevice);

@override
String toString() {
  return 'BleWifiState(status: $status, hintText: $hintText, readerDevice: $readerDevice)';
}


}

/// @nodoc
abstract mixin class _$BleWifiStateCopyWith<$Res> implements $BleWifiStateCopyWith<$Res> {
  factory _$BleWifiStateCopyWith(_BleWifiState value, $Res Function(_BleWifiState) _then) = __$BleWifiStateCopyWithImpl;
@override @useResult
$Res call({
 BleWifiStatus status, String hintText, ReaderDevice? readerDevice
});


@override $ReaderDeviceCopyWith<$Res>? get readerDevice;

}
/// @nodoc
class __$BleWifiStateCopyWithImpl<$Res>
    implements _$BleWifiStateCopyWith<$Res> {
  __$BleWifiStateCopyWithImpl(this._self, this._then);

  final _BleWifiState _self;
  final $Res Function(_BleWifiState) _then;

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? hintText = null,Object? readerDevice = freezed,}) {
  return _then(_BleWifiState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BleWifiStatus,hintText: null == hintText ? _self.hintText : hintText // ignore: cast_nullable_to_non_nullable
as String,readerDevice: freezed == readerDevice ? _self.readerDevice : readerDevice // ignore: cast_nullable_to_non_nullable
as ReaderDevice?,
  ));
}

/// Create a copy of BleWifiState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReaderDeviceCopyWith<$Res>? get readerDevice {
    if (_self.readerDevice == null) {
    return null;
  }

  return $ReaderDeviceCopyWith<$Res>(_self.readerDevice!, (value) {
    return _then(_self.copyWith(readerDevice: value));
  });
}
}

// dart format on
