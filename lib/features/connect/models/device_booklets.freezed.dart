// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_booklets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
DeviceBooklet _$DeviceBookletFromJson(
  Map<String, dynamic> json
) {
    return _DeviceBooklets.fromJson(
      json
    );
}

/// @nodoc
mixin _$DeviceBooklet {

 String get id;@JsonKey(name: 'variants') List<String> get variantIds;@JsonKey(name: 'custom_recordings') List<String> get customRecordings;
/// Create a copy of DeviceBooklet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceBookletCopyWith<DeviceBooklet> get copyWith => _$DeviceBookletCopyWithImpl<DeviceBooklet>(this as DeviceBooklet, _$identity);

  /// Serializes this DeviceBooklet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceBooklet&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.variantIds, variantIds)&&const DeepCollectionEquality().equals(other.customRecordings, customRecordings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(variantIds),const DeepCollectionEquality().hash(customRecordings));

@override
String toString() {
  return 'DeviceBooklet(id: $id, variantIds: $variantIds, customRecordings: $customRecordings)';
}


}

/// @nodoc
abstract mixin class $DeviceBookletCopyWith<$Res>  {
  factory $DeviceBookletCopyWith(DeviceBooklet value, $Res Function(DeviceBooklet) _then) = _$DeviceBookletCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'variants') List<String> variantIds,@JsonKey(name: 'custom_recordings') List<String> customRecordings
});




}
/// @nodoc
class _$DeviceBookletCopyWithImpl<$Res>
    implements $DeviceBookletCopyWith<$Res> {
  _$DeviceBookletCopyWithImpl(this._self, this._then);

  final DeviceBooklet _self;
  final $Res Function(DeviceBooklet) _then;

/// Create a copy of DeviceBooklet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? variantIds = null,Object? customRecordings = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variantIds: null == variantIds ? _self.variantIds : variantIds // ignore: cast_nullable_to_non_nullable
as List<String>,customRecordings: null == customRecordings ? _self.customRecordings : customRecordings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceBooklet].
extension DeviceBookletPatterns on DeviceBooklet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceBooklets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceBooklets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceBooklets value)  $default,){
final _that = this;
switch (_that) {
case _DeviceBooklets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceBooklets value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceBooklets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'variants')  List<String> variantIds, @JsonKey(name: 'custom_recordings')  List<String> customRecordings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceBooklets() when $default != null:
return $default(_that.id,_that.variantIds,_that.customRecordings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'variants')  List<String> variantIds, @JsonKey(name: 'custom_recordings')  List<String> customRecordings)  $default,) {final _that = this;
switch (_that) {
case _DeviceBooklets():
return $default(_that.id,_that.variantIds,_that.customRecordings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'variants')  List<String> variantIds, @JsonKey(name: 'custom_recordings')  List<String> customRecordings)?  $default,) {final _that = this;
switch (_that) {
case _DeviceBooklets() when $default != null:
return $default(_that.id,_that.variantIds,_that.customRecordings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceBooklets implements DeviceBooklet {
  const _DeviceBooklets({required this.id, @JsonKey(name: 'variants') required final  List<String> variantIds, @JsonKey(name: 'custom_recordings') required final  List<String> customRecordings}): _variantIds = variantIds,_customRecordings = customRecordings;
  factory _DeviceBooklets.fromJson(Map<String, dynamic> json) => _$DeviceBookletsFromJson(json);

@override final  String id;
 final  List<String> _variantIds;
@override@JsonKey(name: 'variants') List<String> get variantIds {
  if (_variantIds is EqualUnmodifiableListView) return _variantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variantIds);
}

 final  List<String> _customRecordings;
@override@JsonKey(name: 'custom_recordings') List<String> get customRecordings {
  if (_customRecordings is EqualUnmodifiableListView) return _customRecordings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customRecordings);
}


/// Create a copy of DeviceBooklet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceBookletsCopyWith<_DeviceBooklets> get copyWith => __$DeviceBookletsCopyWithImpl<_DeviceBooklets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceBookletsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceBooklets&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._variantIds, _variantIds)&&const DeepCollectionEquality().equals(other._customRecordings, _customRecordings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_variantIds),const DeepCollectionEquality().hash(_customRecordings));

@override
String toString() {
  return 'DeviceBooklet(id: $id, variantIds: $variantIds, customRecordings: $customRecordings)';
}


}

/// @nodoc
abstract mixin class _$DeviceBookletsCopyWith<$Res> implements $DeviceBookletCopyWith<$Res> {
  factory _$DeviceBookletsCopyWith(_DeviceBooklets value, $Res Function(_DeviceBooklets) _then) = __$DeviceBookletsCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'variants') List<String> variantIds,@JsonKey(name: 'custom_recordings') List<String> customRecordings
});




}
/// @nodoc
class __$DeviceBookletsCopyWithImpl<$Res>
    implements _$DeviceBookletsCopyWith<$Res> {
  __$DeviceBookletsCopyWithImpl(this._self, this._then);

  final _DeviceBooklets _self;
  final $Res Function(_DeviceBooklets) _then;

/// Create a copy of DeviceBooklet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? variantIds = null,Object? customRecordings = null,}) {
  return _then(_DeviceBooklets(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,variantIds: null == variantIds ? _self._variantIds : variantIds // ignore: cast_nullable_to_non_nullable
as List<String>,customRecordings: null == customRecordings ? _self._customRecordings : customRecordings // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
