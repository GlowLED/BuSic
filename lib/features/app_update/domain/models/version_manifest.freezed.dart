// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'version_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VersionManifest _$VersionManifestFromJson(Map<String, dynamic> json) {
  return _VersionManifest.fromJson(json);
}

/// @nodoc
mixin _$VersionManifest {
  String get latest => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_supported')
  String get minSupported => throw _privateConstructorUsedError;
  List<VersionEntry> get versions => throw _privateConstructorUsedError;

  /// Serializes this VersionManifest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VersionManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VersionManifestCopyWith<VersionManifest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VersionManifestCopyWith<$Res> {
  factory $VersionManifestCopyWith(
          VersionManifest value, $Res Function(VersionManifest) then) =
      _$VersionManifestCopyWithImpl<$Res, VersionManifest>;
  @useResult
  $Res call(
      {String latest,
      @JsonKey(name: 'min_supported') String minSupported,
      List<VersionEntry> versions});
}

/// @nodoc
class _$VersionManifestCopyWithImpl<$Res, $Val extends VersionManifest>
    implements $VersionManifestCopyWith<$Res> {
  _$VersionManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VersionManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latest = null,
    Object? minSupported = null,
    Object? versions = null,
  }) {
    return _then(_value.copyWith(
      latest: null == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as String,
      minSupported: null == minSupported
          ? _value.minSupported
          : minSupported // ignore: cast_nullable_to_non_nullable
              as String,
      versions: null == versions
          ? _value.versions
          : versions // ignore: cast_nullable_to_non_nullable
              as List<VersionEntry>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VersionManifestImplCopyWith<$Res>
    implements $VersionManifestCopyWith<$Res> {
  factory _$$VersionManifestImplCopyWith(_$VersionManifestImpl value,
          $Res Function(_$VersionManifestImpl) then) =
      __$$VersionManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String latest,
      @JsonKey(name: 'min_supported') String minSupported,
      List<VersionEntry> versions});
}

/// @nodoc
class __$$VersionManifestImplCopyWithImpl<$Res>
    extends _$VersionManifestCopyWithImpl<$Res, _$VersionManifestImpl>
    implements _$$VersionManifestImplCopyWith<$Res> {
  __$$VersionManifestImplCopyWithImpl(
      _$VersionManifestImpl _value, $Res Function(_$VersionManifestImpl) _then)
      : super(_value, _then);

  /// Create a copy of VersionManifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latest = null,
    Object? minSupported = null,
    Object? versions = null,
  }) {
    return _then(_$VersionManifestImpl(
      latest: null == latest
          ? _value.latest
          : latest // ignore: cast_nullable_to_non_nullable
              as String,
      minSupported: null == minSupported
          ? _value.minSupported
          : minSupported // ignore: cast_nullable_to_non_nullable
              as String,
      versions: null == versions
          ? _value._versions
          : versions // ignore: cast_nullable_to_non_nullable
              as List<VersionEntry>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VersionManifestImpl implements _VersionManifest {
  const _$VersionManifestImpl(
      {required this.latest,
      @JsonKey(name: 'min_supported') required this.minSupported,
      required final List<VersionEntry> versions})
      : _versions = versions;

  factory _$VersionManifestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VersionManifestImplFromJson(json);

  @override
  final String latest;
  @override
  @JsonKey(name: 'min_supported')
  final String minSupported;
  final List<VersionEntry> _versions;
  @override
  List<VersionEntry> get versions {
    if (_versions is EqualUnmodifiableListView) return _versions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_versions);
  }

  @override
  String toString() {
    return 'VersionManifest(latest: $latest, minSupported: $minSupported, versions: $versions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VersionManifestImpl &&
            (identical(other.latest, latest) || other.latest == latest) &&
            (identical(other.minSupported, minSupported) ||
                other.minSupported == minSupported) &&
            const DeepCollectionEquality().equals(other._versions, _versions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latest, minSupported,
      const DeepCollectionEquality().hash(_versions));

  /// Create a copy of VersionManifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VersionManifestImplCopyWith<_$VersionManifestImpl> get copyWith =>
      __$$VersionManifestImplCopyWithImpl<_$VersionManifestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VersionManifestImplToJson(
      this,
    );
  }
}

abstract class _VersionManifest implements VersionManifest {
  const factory _VersionManifest(
      {required final String latest,
      @JsonKey(name: 'min_supported') required final String minSupported,
      required final List<VersionEntry> versions}) = _$VersionManifestImpl;

  factory _VersionManifest.fromJson(Map<String, dynamic> json) =
      _$VersionManifestImpl.fromJson;

  @override
  String get latest;
  @override
  @JsonKey(name: 'min_supported')
  String get minSupported;
  @override
  List<VersionEntry> get versions;

  /// Create a copy of VersionManifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VersionManifestImplCopyWith<_$VersionManifestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VersionEntry _$VersionEntryFromJson(Map<String, dynamic> json) {
  return _VersionEntry.fromJson(json);
}

/// @nodoc
mixin _$VersionEntry {
  String get version => throw _privateConstructorUsedError;
  int get build => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get changelog => throw _privateConstructorUsedError;
  @JsonKey(name: 'force_update_below')
  String? get forceUpdateBelow => throw _privateConstructorUsedError;
  Map<String, PlatformAssets> get assets => throw _privateConstructorUsedError;
  Map<String, String> get checksums => throw _privateConstructorUsedError;

  /// Serializes this VersionEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VersionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VersionEntryCopyWith<VersionEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VersionEntryCopyWith<$Res> {
  factory $VersionEntryCopyWith(
          VersionEntry value, $Res Function(VersionEntry) then) =
      _$VersionEntryCopyWithImpl<$Res, VersionEntry>;
  @useResult
  $Res call(
      {String version,
      int build,
      String date,
      String changelog,
      @JsonKey(name: 'force_update_below') String? forceUpdateBelow,
      Map<String, PlatformAssets> assets,
      Map<String, String> checksums});
}

/// @nodoc
class _$VersionEntryCopyWithImpl<$Res, $Val extends VersionEntry>
    implements $VersionEntryCopyWith<$Res> {
  _$VersionEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VersionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? build = null,
    Object? date = null,
    Object? changelog = null,
    Object? forceUpdateBelow = freezed,
    Object? assets = null,
    Object? checksums = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      build: null == build
          ? _value.build
          : build // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      changelog: null == changelog
          ? _value.changelog
          : changelog // ignore: cast_nullable_to_non_nullable
              as String,
      forceUpdateBelow: freezed == forceUpdateBelow
          ? _value.forceUpdateBelow
          : forceUpdateBelow // ignore: cast_nullable_to_non_nullable
              as String?,
      assets: null == assets
          ? _value.assets
          : assets // ignore: cast_nullable_to_non_nullable
              as Map<String, PlatformAssets>,
      checksums: null == checksums
          ? _value.checksums
          : checksums // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VersionEntryImplCopyWith<$Res>
    implements $VersionEntryCopyWith<$Res> {
  factory _$$VersionEntryImplCopyWith(
          _$VersionEntryImpl value, $Res Function(_$VersionEntryImpl) then) =
      __$$VersionEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String version,
      int build,
      String date,
      String changelog,
      @JsonKey(name: 'force_update_below') String? forceUpdateBelow,
      Map<String, PlatformAssets> assets,
      Map<String, String> checksums});
}

/// @nodoc
class __$$VersionEntryImplCopyWithImpl<$Res>
    extends _$VersionEntryCopyWithImpl<$Res, _$VersionEntryImpl>
    implements _$$VersionEntryImplCopyWith<$Res> {
  __$$VersionEntryImplCopyWithImpl(
      _$VersionEntryImpl _value, $Res Function(_$VersionEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of VersionEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? build = null,
    Object? date = null,
    Object? changelog = null,
    Object? forceUpdateBelow = freezed,
    Object? assets = null,
    Object? checksums = null,
  }) {
    return _then(_$VersionEntryImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      build: null == build
          ? _value.build
          : build // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      changelog: null == changelog
          ? _value.changelog
          : changelog // ignore: cast_nullable_to_non_nullable
              as String,
      forceUpdateBelow: freezed == forceUpdateBelow
          ? _value.forceUpdateBelow
          : forceUpdateBelow // ignore: cast_nullable_to_non_nullable
              as String?,
      assets: null == assets
          ? _value._assets
          : assets // ignore: cast_nullable_to_non_nullable
              as Map<String, PlatformAssets>,
      checksums: null == checksums
          ? _value._checksums
          : checksums // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VersionEntryImpl implements _VersionEntry {
  const _$VersionEntryImpl(
      {required this.version,
      required this.build,
      required this.date,
      required this.changelog,
      @JsonKey(name: 'force_update_below') this.forceUpdateBelow,
      required final Map<String, PlatformAssets> assets,
      final Map<String, String> checksums = const {}})
      : _assets = assets,
        _checksums = checksums;

  factory _$VersionEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$VersionEntryImplFromJson(json);

  @override
  final String version;
  @override
  final int build;
  @override
  final String date;
  @override
  final String changelog;
  @override
  @JsonKey(name: 'force_update_below')
  final String? forceUpdateBelow;
  final Map<String, PlatformAssets> _assets;
  @override
  Map<String, PlatformAssets> get assets {
    if (_assets is EqualUnmodifiableMapView) return _assets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assets);
  }

  final Map<String, String> _checksums;
  @override
  @JsonKey()
  Map<String, String> get checksums {
    if (_checksums is EqualUnmodifiableMapView) return _checksums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_checksums);
  }

  @override
  String toString() {
    return 'VersionEntry(version: $version, build: $build, date: $date, changelog: $changelog, forceUpdateBelow: $forceUpdateBelow, assets: $assets, checksums: $checksums)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VersionEntryImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.build, build) || other.build == build) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.changelog, changelog) ||
                other.changelog == changelog) &&
            (identical(other.forceUpdateBelow, forceUpdateBelow) ||
                other.forceUpdateBelow == forceUpdateBelow) &&
            const DeepCollectionEquality().equals(other._assets, _assets) &&
            const DeepCollectionEquality()
                .equals(other._checksums, _checksums));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      version,
      build,
      date,
      changelog,
      forceUpdateBelow,
      const DeepCollectionEquality().hash(_assets),
      const DeepCollectionEquality().hash(_checksums));

  /// Create a copy of VersionEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VersionEntryImplCopyWith<_$VersionEntryImpl> get copyWith =>
      __$$VersionEntryImplCopyWithImpl<_$VersionEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VersionEntryImplToJson(
      this,
    );
  }
}

abstract class _VersionEntry implements VersionEntry {
  const factory _VersionEntry(
      {required final String version,
      required final int build,
      required final String date,
      required final String changelog,
      @JsonKey(name: 'force_update_below') final String? forceUpdateBelow,
      required final Map<String, PlatformAssets> assets,
      final Map<String, String> checksums}) = _$VersionEntryImpl;

  factory _VersionEntry.fromJson(Map<String, dynamic> json) =
      _$VersionEntryImpl.fromJson;

  @override
  String get version;
  @override
  int get build;
  @override
  String get date;
  @override
  String get changelog;
  @override
  @JsonKey(name: 'force_update_below')
  String? get forceUpdateBelow;
  @override
  Map<String, PlatformAssets> get assets;
  @override
  Map<String, String> get checksums;

  /// Create a copy of VersionEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VersionEntryImplCopyWith<_$VersionEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformAssets _$PlatformAssetsFromJson(Map<String, dynamic> json) {
  return _PlatformAssets.fromJson(json);
}

/// @nodoc
mixin _$PlatformAssets {
  String? get github => throw _privateConstructorUsedError;
  LanzouAsset? get lanzou => throw _privateConstructorUsedError;

  /// Serializes this PlatformAssets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformAssetsCopyWith<PlatformAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformAssetsCopyWith<$Res> {
  factory $PlatformAssetsCopyWith(
          PlatformAssets value, $Res Function(PlatformAssets) then) =
      _$PlatformAssetsCopyWithImpl<$Res, PlatformAssets>;
  @useResult
  $Res call({String? github, LanzouAsset? lanzou});

  $LanzouAssetCopyWith<$Res>? get lanzou;
}

/// @nodoc
class _$PlatformAssetsCopyWithImpl<$Res, $Val extends PlatformAssets>
    implements $PlatformAssetsCopyWith<$Res> {
  _$PlatformAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? github = freezed,
    Object? lanzou = freezed,
  }) {
    return _then(_value.copyWith(
      github: freezed == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as String?,
      lanzou: freezed == lanzou
          ? _value.lanzou
          : lanzou // ignore: cast_nullable_to_non_nullable
              as LanzouAsset?,
    ) as $Val);
  }

  /// Create a copy of PlatformAssets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LanzouAssetCopyWith<$Res>? get lanzou {
    if (_value.lanzou == null) {
      return null;
    }

    return $LanzouAssetCopyWith<$Res>(_value.lanzou!, (value) {
      return _then(_value.copyWith(lanzou: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlatformAssetsImplCopyWith<$Res>
    implements $PlatformAssetsCopyWith<$Res> {
  factory _$$PlatformAssetsImplCopyWith(_$PlatformAssetsImpl value,
          $Res Function(_$PlatformAssetsImpl) then) =
      __$$PlatformAssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? github, LanzouAsset? lanzou});

  @override
  $LanzouAssetCopyWith<$Res>? get lanzou;
}

/// @nodoc
class __$$PlatformAssetsImplCopyWithImpl<$Res>
    extends _$PlatformAssetsCopyWithImpl<$Res, _$PlatformAssetsImpl>
    implements _$$PlatformAssetsImplCopyWith<$Res> {
  __$$PlatformAssetsImplCopyWithImpl(
      _$PlatformAssetsImpl _value, $Res Function(_$PlatformAssetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlatformAssets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? github = freezed,
    Object? lanzou = freezed,
  }) {
    return _then(_$PlatformAssetsImpl(
      github: freezed == github
          ? _value.github
          : github // ignore: cast_nullable_to_non_nullable
              as String?,
      lanzou: freezed == lanzou
          ? _value.lanzou
          : lanzou // ignore: cast_nullable_to_non_nullable
              as LanzouAsset?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformAssetsImpl implements _PlatformAssets {
  const _$PlatformAssetsImpl({this.github, this.lanzou});

  factory _$PlatformAssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformAssetsImplFromJson(json);

  @override
  final String? github;
  @override
  final LanzouAsset? lanzou;

  @override
  String toString() {
    return 'PlatformAssets(github: $github, lanzou: $lanzou)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformAssetsImpl &&
            (identical(other.github, github) || other.github == github) &&
            (identical(other.lanzou, lanzou) || other.lanzou == lanzou));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, github, lanzou);

  /// Create a copy of PlatformAssets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformAssetsImplCopyWith<_$PlatformAssetsImpl> get copyWith =>
      __$$PlatformAssetsImplCopyWithImpl<_$PlatformAssetsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformAssetsImplToJson(
      this,
    );
  }
}

abstract class _PlatformAssets implements PlatformAssets {
  const factory _PlatformAssets(
      {final String? github, final LanzouAsset? lanzou}) = _$PlatformAssetsImpl;

  factory _PlatformAssets.fromJson(Map<String, dynamic> json) =
      _$PlatformAssetsImpl.fromJson;

  @override
  String? get github;
  @override
  LanzouAsset? get lanzou;

  /// Create a copy of PlatformAssets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformAssetsImplCopyWith<_$PlatformAssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LanzouAsset _$LanzouAssetFromJson(Map<String, dynamic> json) {
  return _LanzouAsset.fromJson(json);
}

/// @nodoc
mixin _$LanzouAsset {
  String get url => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;

  /// Serializes this LanzouAsset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanzouAsset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanzouAssetCopyWith<LanzouAsset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanzouAssetCopyWith<$Res> {
  factory $LanzouAssetCopyWith(
          LanzouAsset value, $Res Function(LanzouAsset) then) =
      _$LanzouAssetCopyWithImpl<$Res, LanzouAsset>;
  @useResult
  $Res call({String url, String? password});
}

/// @nodoc
class _$LanzouAssetCopyWithImpl<$Res, $Val extends LanzouAsset>
    implements $LanzouAssetCopyWith<$Res> {
  _$LanzouAssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanzouAsset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? password = freezed,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanzouAssetImplCopyWith<$Res>
    implements $LanzouAssetCopyWith<$Res> {
  factory _$$LanzouAssetImplCopyWith(
          _$LanzouAssetImpl value, $Res Function(_$LanzouAssetImpl) then) =
      __$$LanzouAssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String? password});
}

/// @nodoc
class __$$LanzouAssetImplCopyWithImpl<$Res>
    extends _$LanzouAssetCopyWithImpl<$Res, _$LanzouAssetImpl>
    implements _$$LanzouAssetImplCopyWith<$Res> {
  __$$LanzouAssetImplCopyWithImpl(
      _$LanzouAssetImpl _value, $Res Function(_$LanzouAssetImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanzouAsset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? password = freezed,
  }) {
    return _then(_$LanzouAssetImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanzouAssetImpl implements _LanzouAsset {
  const _$LanzouAssetImpl({required this.url, this.password});

  factory _$LanzouAssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanzouAssetImplFromJson(json);

  @override
  final String url;
  @override
  final String? password;

  @override
  String toString() {
    return 'LanzouAsset(url: $url, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanzouAssetImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, password);

  /// Create a copy of LanzouAsset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanzouAssetImplCopyWith<_$LanzouAssetImpl> get copyWith =>
      __$$LanzouAssetImplCopyWithImpl<_$LanzouAssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanzouAssetImplToJson(
      this,
    );
  }
}

abstract class _LanzouAsset implements LanzouAsset {
  const factory _LanzouAsset(
      {required final String url, final String? password}) = _$LanzouAssetImpl;

  factory _LanzouAsset.fromJson(Map<String, dynamic> json) =
      _$LanzouAssetImpl.fromJson;

  @override
  String get url;
  @override
  String? get password;

  /// Create a copy of LanzouAsset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanzouAssetImplCopyWith<_$LanzouAssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
