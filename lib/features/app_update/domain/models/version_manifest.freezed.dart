// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'version_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VersionManifest {

 String get latest;@JsonKey(name: 'min_supported') String get minSupported; List<VersionEntry> get versions;
/// Create a copy of VersionManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VersionManifestCopyWith<VersionManifest> get copyWith => _$VersionManifestCopyWithImpl<VersionManifest>(this as VersionManifest, _$identity);

  /// Serializes this VersionManifest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionManifest&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.minSupported, minSupported) || other.minSupported == minSupported)&&const DeepCollectionEquality().equals(other.versions, versions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latest,minSupported,const DeepCollectionEquality().hash(versions));

@override
String toString() {
  return 'VersionManifest(latest: $latest, minSupported: $minSupported, versions: $versions)';
}


}

/// @nodoc
abstract mixin class $VersionManifestCopyWith<$Res>  {
  factory $VersionManifestCopyWith(VersionManifest value, $Res Function(VersionManifest) _then) = _$VersionManifestCopyWithImpl;
@useResult
$Res call({
 String latest,@JsonKey(name: 'min_supported') String minSupported, List<VersionEntry> versions
});




}
/// @nodoc
class _$VersionManifestCopyWithImpl<$Res>
    implements $VersionManifestCopyWith<$Res> {
  _$VersionManifestCopyWithImpl(this._self, this._then);

  final VersionManifest _self;
  final $Res Function(VersionManifest) _then;

/// Create a copy of VersionManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latest = null,Object? minSupported = null,Object? versions = null,}) {
  return _then(_self.copyWith(
latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as String,minSupported: null == minSupported ? _self.minSupported : minSupported // ignore: cast_nullable_to_non_nullable
as String,versions: null == versions ? _self.versions : versions // ignore: cast_nullable_to_non_nullable
as List<VersionEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [VersionManifest].
extension VersionManifestPatterns on VersionManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VersionManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VersionManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VersionManifest value)  $default,){
final _that = this;
switch (_that) {
case _VersionManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VersionManifest value)?  $default,){
final _that = this;
switch (_that) {
case _VersionManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String latest, @JsonKey(name: 'min_supported')  String minSupported,  List<VersionEntry> versions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VersionManifest() when $default != null:
return $default(_that.latest,_that.minSupported,_that.versions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String latest, @JsonKey(name: 'min_supported')  String minSupported,  List<VersionEntry> versions)  $default,) {final _that = this;
switch (_that) {
case _VersionManifest():
return $default(_that.latest,_that.minSupported,_that.versions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String latest, @JsonKey(name: 'min_supported')  String minSupported,  List<VersionEntry> versions)?  $default,) {final _that = this;
switch (_that) {
case _VersionManifest() when $default != null:
return $default(_that.latest,_that.minSupported,_that.versions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VersionManifest implements VersionManifest {
  const _VersionManifest({required this.latest, @JsonKey(name: 'min_supported') required this.minSupported, required final  List<VersionEntry> versions}): _versions = versions;
  factory _VersionManifest.fromJson(Map<String, dynamic> json) => _$VersionManifestFromJson(json);

@override final  String latest;
@override@JsonKey(name: 'min_supported') final  String minSupported;
 final  List<VersionEntry> _versions;
@override List<VersionEntry> get versions {
  if (_versions is EqualUnmodifiableListView) return _versions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_versions);
}


/// Create a copy of VersionManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VersionManifestCopyWith<_VersionManifest> get copyWith => __$VersionManifestCopyWithImpl<_VersionManifest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VersionManifestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VersionManifest&&(identical(other.latest, latest) || other.latest == latest)&&(identical(other.minSupported, minSupported) || other.minSupported == minSupported)&&const DeepCollectionEquality().equals(other._versions, _versions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latest,minSupported,const DeepCollectionEquality().hash(_versions));

@override
String toString() {
  return 'VersionManifest(latest: $latest, minSupported: $minSupported, versions: $versions)';
}


}

/// @nodoc
abstract mixin class _$VersionManifestCopyWith<$Res> implements $VersionManifestCopyWith<$Res> {
  factory _$VersionManifestCopyWith(_VersionManifest value, $Res Function(_VersionManifest) _then) = __$VersionManifestCopyWithImpl;
@override @useResult
$Res call({
 String latest,@JsonKey(name: 'min_supported') String minSupported, List<VersionEntry> versions
});




}
/// @nodoc
class __$VersionManifestCopyWithImpl<$Res>
    implements _$VersionManifestCopyWith<$Res> {
  __$VersionManifestCopyWithImpl(this._self, this._then);

  final _VersionManifest _self;
  final $Res Function(_VersionManifest) _then;

/// Create a copy of VersionManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latest = null,Object? minSupported = null,Object? versions = null,}) {
  return _then(_VersionManifest(
latest: null == latest ? _self.latest : latest // ignore: cast_nullable_to_non_nullable
as String,minSupported: null == minSupported ? _self.minSupported : minSupported // ignore: cast_nullable_to_non_nullable
as String,versions: null == versions ? _self._versions : versions // ignore: cast_nullable_to_non_nullable
as List<VersionEntry>,
  ));
}


}


/// @nodoc
mixin _$VersionEntry {

 String get version; int get build; String get date; String get changelog;@JsonKey(name: 'force_update_below') String? get forceUpdateBelow; Map<String, PlatformAssets> get assets; Map<String, String> get checksums;
/// Create a copy of VersionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VersionEntryCopyWith<VersionEntry> get copyWith => _$VersionEntryCopyWithImpl<VersionEntry>(this as VersionEntry, _$identity);

  /// Serializes this VersionEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionEntry&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.date, date) || other.date == date)&&(identical(other.changelog, changelog) || other.changelog == changelog)&&(identical(other.forceUpdateBelow, forceUpdateBelow) || other.forceUpdateBelow == forceUpdateBelow)&&const DeepCollectionEquality().equals(other.assets, assets)&&const DeepCollectionEquality().equals(other.checksums, checksums));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,build,date,changelog,forceUpdateBelow,const DeepCollectionEquality().hash(assets),const DeepCollectionEquality().hash(checksums));

@override
String toString() {
  return 'VersionEntry(version: $version, build: $build, date: $date, changelog: $changelog, forceUpdateBelow: $forceUpdateBelow, assets: $assets, checksums: $checksums)';
}


}

/// @nodoc
abstract mixin class $VersionEntryCopyWith<$Res>  {
  factory $VersionEntryCopyWith(VersionEntry value, $Res Function(VersionEntry) _then) = _$VersionEntryCopyWithImpl;
@useResult
$Res call({
 String version, int build, String date, String changelog,@JsonKey(name: 'force_update_below') String? forceUpdateBelow, Map<String, PlatformAssets> assets, Map<String, String> checksums
});




}
/// @nodoc
class _$VersionEntryCopyWithImpl<$Res>
    implements $VersionEntryCopyWith<$Res> {
  _$VersionEntryCopyWithImpl(this._self, this._then);

  final VersionEntry _self;
  final $Res Function(VersionEntry) _then;

/// Create a copy of VersionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? build = null,Object? date = null,Object? changelog = null,Object? forceUpdateBelow = freezed,Object? assets = null,Object? checksums = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as String,forceUpdateBelow: freezed == forceUpdateBelow ? _self.forceUpdateBelow : forceUpdateBelow // ignore: cast_nullable_to_non_nullable
as String?,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as Map<String, PlatformAssets>,checksums: null == checksums ? _self.checksums : checksums // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [VersionEntry].
extension VersionEntryPatterns on VersionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VersionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VersionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VersionEntry value)  $default,){
final _that = this;
switch (_that) {
case _VersionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VersionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _VersionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  int build,  String date,  String changelog, @JsonKey(name: 'force_update_below')  String? forceUpdateBelow,  Map<String, PlatformAssets> assets,  Map<String, String> checksums)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VersionEntry() when $default != null:
return $default(_that.version,_that.build,_that.date,_that.changelog,_that.forceUpdateBelow,_that.assets,_that.checksums);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  int build,  String date,  String changelog, @JsonKey(name: 'force_update_below')  String? forceUpdateBelow,  Map<String, PlatformAssets> assets,  Map<String, String> checksums)  $default,) {final _that = this;
switch (_that) {
case _VersionEntry():
return $default(_that.version,_that.build,_that.date,_that.changelog,_that.forceUpdateBelow,_that.assets,_that.checksums);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  int build,  String date,  String changelog, @JsonKey(name: 'force_update_below')  String? forceUpdateBelow,  Map<String, PlatformAssets> assets,  Map<String, String> checksums)?  $default,) {final _that = this;
switch (_that) {
case _VersionEntry() when $default != null:
return $default(_that.version,_that.build,_that.date,_that.changelog,_that.forceUpdateBelow,_that.assets,_that.checksums);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VersionEntry implements VersionEntry {
  const _VersionEntry({required this.version, required this.build, required this.date, required this.changelog, @JsonKey(name: 'force_update_below') this.forceUpdateBelow, required final  Map<String, PlatformAssets> assets, final  Map<String, String> checksums = const {}}): _assets = assets,_checksums = checksums;
  factory _VersionEntry.fromJson(Map<String, dynamic> json) => _$VersionEntryFromJson(json);

@override final  String version;
@override final  int build;
@override final  String date;
@override final  String changelog;
@override@JsonKey(name: 'force_update_below') final  String? forceUpdateBelow;
 final  Map<String, PlatformAssets> _assets;
@override Map<String, PlatformAssets> get assets {
  if (_assets is EqualUnmodifiableMapView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_assets);
}

 final  Map<String, String> _checksums;
@override@JsonKey() Map<String, String> get checksums {
  if (_checksums is EqualUnmodifiableMapView) return _checksums;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_checksums);
}


/// Create a copy of VersionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VersionEntryCopyWith<_VersionEntry> get copyWith => __$VersionEntryCopyWithImpl<_VersionEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VersionEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VersionEntry&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.date, date) || other.date == date)&&(identical(other.changelog, changelog) || other.changelog == changelog)&&(identical(other.forceUpdateBelow, forceUpdateBelow) || other.forceUpdateBelow == forceUpdateBelow)&&const DeepCollectionEquality().equals(other._assets, _assets)&&const DeepCollectionEquality().equals(other._checksums, _checksums));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,build,date,changelog,forceUpdateBelow,const DeepCollectionEquality().hash(_assets),const DeepCollectionEquality().hash(_checksums));

@override
String toString() {
  return 'VersionEntry(version: $version, build: $build, date: $date, changelog: $changelog, forceUpdateBelow: $forceUpdateBelow, assets: $assets, checksums: $checksums)';
}


}

/// @nodoc
abstract mixin class _$VersionEntryCopyWith<$Res> implements $VersionEntryCopyWith<$Res> {
  factory _$VersionEntryCopyWith(_VersionEntry value, $Res Function(_VersionEntry) _then) = __$VersionEntryCopyWithImpl;
@override @useResult
$Res call({
 String version, int build, String date, String changelog,@JsonKey(name: 'force_update_below') String? forceUpdateBelow, Map<String, PlatformAssets> assets, Map<String, String> checksums
});




}
/// @nodoc
class __$VersionEntryCopyWithImpl<$Res>
    implements _$VersionEntryCopyWith<$Res> {
  __$VersionEntryCopyWithImpl(this._self, this._then);

  final _VersionEntry _self;
  final $Res Function(_VersionEntry) _then;

/// Create a copy of VersionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? build = null,Object? date = null,Object? changelog = null,Object? forceUpdateBelow = freezed,Object? assets = null,Object? checksums = null,}) {
  return _then(_VersionEntry(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as String,forceUpdateBelow: freezed == forceUpdateBelow ? _self.forceUpdateBelow : forceUpdateBelow // ignore: cast_nullable_to_non_nullable
as String?,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as Map<String, PlatformAssets>,checksums: null == checksums ? _self._checksums : checksums // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$PlatformAssets {

 String? get github; LanzouAsset? get lanzou;
/// Create a copy of PlatformAssets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformAssetsCopyWith<PlatformAssets> get copyWith => _$PlatformAssetsCopyWithImpl<PlatformAssets>(this as PlatformAssets, _$identity);

  /// Serializes this PlatformAssets to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformAssets&&(identical(other.github, github) || other.github == github)&&(identical(other.lanzou, lanzou) || other.lanzou == lanzou));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,github,lanzou);

@override
String toString() {
  return 'PlatformAssets(github: $github, lanzou: $lanzou)';
}


}

/// @nodoc
abstract mixin class $PlatformAssetsCopyWith<$Res>  {
  factory $PlatformAssetsCopyWith(PlatformAssets value, $Res Function(PlatformAssets) _then) = _$PlatformAssetsCopyWithImpl;
@useResult
$Res call({
 String? github, LanzouAsset? lanzou
});


$LanzouAssetCopyWith<$Res>? get lanzou;

}
/// @nodoc
class _$PlatformAssetsCopyWithImpl<$Res>
    implements $PlatformAssetsCopyWith<$Res> {
  _$PlatformAssetsCopyWithImpl(this._self, this._then);

  final PlatformAssets _self;
  final $Res Function(PlatformAssets) _then;

/// Create a copy of PlatformAssets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? github = freezed,Object? lanzou = freezed,}) {
  return _then(_self.copyWith(
github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,lanzou: freezed == lanzou ? _self.lanzou : lanzou // ignore: cast_nullable_to_non_nullable
as LanzouAsset?,
  ));
}
/// Create a copy of PlatformAssets
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LanzouAssetCopyWith<$Res>? get lanzou {
    if (_self.lanzou == null) {
    return null;
  }

  return $LanzouAssetCopyWith<$Res>(_self.lanzou!, (value) {
    return _then(_self.copyWith(lanzou: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlatformAssets].
extension PlatformAssetsPatterns on PlatformAssets {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformAssets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformAssets() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformAssets value)  $default,){
final _that = this;
switch (_that) {
case _PlatformAssets():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformAssets value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformAssets() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? github,  LanzouAsset? lanzou)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformAssets() when $default != null:
return $default(_that.github,_that.lanzou);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? github,  LanzouAsset? lanzou)  $default,) {final _that = this;
switch (_that) {
case _PlatformAssets():
return $default(_that.github,_that.lanzou);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? github,  LanzouAsset? lanzou)?  $default,) {final _that = this;
switch (_that) {
case _PlatformAssets() when $default != null:
return $default(_that.github,_that.lanzou);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformAssets implements PlatformAssets {
  const _PlatformAssets({this.github, this.lanzou});
  factory _PlatformAssets.fromJson(Map<String, dynamic> json) => _$PlatformAssetsFromJson(json);

@override final  String? github;
@override final  LanzouAsset? lanzou;

/// Create a copy of PlatformAssets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformAssetsCopyWith<_PlatformAssets> get copyWith => __$PlatformAssetsCopyWithImpl<_PlatformAssets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformAssetsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformAssets&&(identical(other.github, github) || other.github == github)&&(identical(other.lanzou, lanzou) || other.lanzou == lanzou));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,github,lanzou);

@override
String toString() {
  return 'PlatformAssets(github: $github, lanzou: $lanzou)';
}


}

/// @nodoc
abstract mixin class _$PlatformAssetsCopyWith<$Res> implements $PlatformAssetsCopyWith<$Res> {
  factory _$PlatformAssetsCopyWith(_PlatformAssets value, $Res Function(_PlatformAssets) _then) = __$PlatformAssetsCopyWithImpl;
@override @useResult
$Res call({
 String? github, LanzouAsset? lanzou
});


@override $LanzouAssetCopyWith<$Res>? get lanzou;

}
/// @nodoc
class __$PlatformAssetsCopyWithImpl<$Res>
    implements _$PlatformAssetsCopyWith<$Res> {
  __$PlatformAssetsCopyWithImpl(this._self, this._then);

  final _PlatformAssets _self;
  final $Res Function(_PlatformAssets) _then;

/// Create a copy of PlatformAssets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? github = freezed,Object? lanzou = freezed,}) {
  return _then(_PlatformAssets(
github: freezed == github ? _self.github : github // ignore: cast_nullable_to_non_nullable
as String?,lanzou: freezed == lanzou ? _self.lanzou : lanzou // ignore: cast_nullable_to_non_nullable
as LanzouAsset?,
  ));
}

/// Create a copy of PlatformAssets
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LanzouAssetCopyWith<$Res>? get lanzou {
    if (_self.lanzou == null) {
    return null;
  }

  return $LanzouAssetCopyWith<$Res>(_self.lanzou!, (value) {
    return _then(_self.copyWith(lanzou: value));
  });
}
}


/// @nodoc
mixin _$LanzouAsset {

 String get url; String? get password;
/// Create a copy of LanzouAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LanzouAssetCopyWith<LanzouAsset> get copyWith => _$LanzouAssetCopyWithImpl<LanzouAsset>(this as LanzouAsset, _$identity);

  /// Serializes this LanzouAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LanzouAsset&&(identical(other.url, url) || other.url == url)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,password);

@override
String toString() {
  return 'LanzouAsset(url: $url, password: $password)';
}


}

/// @nodoc
abstract mixin class $LanzouAssetCopyWith<$Res>  {
  factory $LanzouAssetCopyWith(LanzouAsset value, $Res Function(LanzouAsset) _then) = _$LanzouAssetCopyWithImpl;
@useResult
$Res call({
 String url, String? password
});




}
/// @nodoc
class _$LanzouAssetCopyWithImpl<$Res>
    implements $LanzouAssetCopyWith<$Res> {
  _$LanzouAssetCopyWithImpl(this._self, this._then);

  final LanzouAsset _self;
  final $Res Function(LanzouAsset) _then;

/// Create a copy of LanzouAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? password = freezed,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LanzouAsset].
extension LanzouAssetPatterns on LanzouAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LanzouAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LanzouAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LanzouAsset value)  $default,){
final _that = this;
switch (_that) {
case _LanzouAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LanzouAsset value)?  $default,){
final _that = this;
switch (_that) {
case _LanzouAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LanzouAsset() when $default != null:
return $default(_that.url,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? password)  $default,) {final _that = this;
switch (_that) {
case _LanzouAsset():
return $default(_that.url,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? password)?  $default,) {final _that = this;
switch (_that) {
case _LanzouAsset() when $default != null:
return $default(_that.url,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LanzouAsset implements LanzouAsset {
  const _LanzouAsset({required this.url, this.password});
  factory _LanzouAsset.fromJson(Map<String, dynamic> json) => _$LanzouAssetFromJson(json);

@override final  String url;
@override final  String? password;

/// Create a copy of LanzouAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LanzouAssetCopyWith<_LanzouAsset> get copyWith => __$LanzouAssetCopyWithImpl<_LanzouAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LanzouAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LanzouAsset&&(identical(other.url, url) || other.url == url)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,password);

@override
String toString() {
  return 'LanzouAsset(url: $url, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LanzouAssetCopyWith<$Res> implements $LanzouAssetCopyWith<$Res> {
  factory _$LanzouAssetCopyWith(_LanzouAsset value, $Res Function(_LanzouAsset) _then) = __$LanzouAssetCopyWithImpl;
@override @useResult
$Res call({
 String url, String? password
});




}
/// @nodoc
class __$LanzouAssetCopyWithImpl<$Res>
    implements _$LanzouAssetCopyWith<$Res> {
  __$LanzouAssetCopyWithImpl(this._self, this._then);

  final _LanzouAsset _self;
  final $Res Function(_LanzouAsset) _then;

/// Create a copy of LanzouAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? password = freezed,}) {
  return _then(_LanzouAsset(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
