// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_playlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SharedPlaylist _$SharedPlaylistFromJson(Map<String, dynamic> json) {
  return _SharedPlaylist.fromJson(json);
}

/// @nodoc
mixin _$SharedPlaylist {
  /// 格式版本号，用于向前兼容
  @JsonKey(name: 'v')
  int get version => throw _privateConstructorUsedError;

  /// 歌单名称
  @JsonKey(name: 'n')
  String get name => throw _privateConstructorUsedError;

  /// 歌曲列表
  @JsonKey(name: 's')
  List<SharedSong> get songs => throw _privateConstructorUsedError;

  /// Serializes this SharedPlaylist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SharedPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedPlaylistCopyWith<SharedPlaylist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedPlaylistCopyWith<$Res> {
  factory $SharedPlaylistCopyWith(
          SharedPlaylist value, $Res Function(SharedPlaylist) then) =
      _$SharedPlaylistCopyWithImpl<$Res, SharedPlaylist>;
  @useResult
  $Res call(
      {@JsonKey(name: 'v') int version,
      @JsonKey(name: 'n') String name,
      @JsonKey(name: 's') List<SharedSong> songs});
}

/// @nodoc
class _$SharedPlaylistCopyWithImpl<$Res, $Val extends SharedPlaylist>
    implements $SharedPlaylistCopyWith<$Res> {
  _$SharedPlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? name = null,
    Object? songs = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songs: null == songs
          ? _value.songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SharedSong>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedPlaylistImplCopyWith<$Res>
    implements $SharedPlaylistCopyWith<$Res> {
  factory _$$SharedPlaylistImplCopyWith(_$SharedPlaylistImpl value,
          $Res Function(_$SharedPlaylistImpl) then) =
      __$$SharedPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'v') int version,
      @JsonKey(name: 'n') String name,
      @JsonKey(name: 's') List<SharedSong> songs});
}

/// @nodoc
class __$$SharedPlaylistImplCopyWithImpl<$Res>
    extends _$SharedPlaylistCopyWithImpl<$Res, _$SharedPlaylistImpl>
    implements _$$SharedPlaylistImplCopyWith<$Res> {
  __$$SharedPlaylistImplCopyWithImpl(
      _$SharedPlaylistImpl _value, $Res Function(_$SharedPlaylistImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? name = null,
    Object? songs = null,
  }) {
    return _then(_$SharedPlaylistImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      songs: null == songs
          ? _value._songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SharedSong>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedPlaylistImpl implements _SharedPlaylist {
  const _$SharedPlaylistImpl(
      {@JsonKey(name: 'v') this.version = 1,
      @JsonKey(name: 'n') required this.name,
      @JsonKey(name: 's') required final List<SharedSong> songs})
      : _songs = songs;

  factory _$SharedPlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedPlaylistImplFromJson(json);

  /// 格式版本号，用于向前兼容
  @override
  @JsonKey(name: 'v')
  final int version;

  /// 歌单名称
  @override
  @JsonKey(name: 'n')
  final String name;

  /// 歌曲列表
  final List<SharedSong> _songs;

  /// 歌曲列表
  @override
  @JsonKey(name: 's')
  List<SharedSong> get songs {
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songs);
  }

  @override
  String toString() {
    return 'SharedPlaylist(version: $version, name: $name, songs: $songs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedPlaylistImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._songs, _songs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, version, name, const DeepCollectionEquality().hash(_songs));

  /// Create a copy of SharedPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedPlaylistImplCopyWith<_$SharedPlaylistImpl> get copyWith =>
      __$$SharedPlaylistImplCopyWithImpl<_$SharedPlaylistImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedPlaylistImplToJson(
      this,
    );
  }
}

abstract class _SharedPlaylist implements SharedPlaylist {
  const factory _SharedPlaylist(
          {@JsonKey(name: 'v') final int version,
          @JsonKey(name: 'n') required final String name,
          @JsonKey(name: 's') required final List<SharedSong> songs}) =
      _$SharedPlaylistImpl;

  factory _SharedPlaylist.fromJson(Map<String, dynamic> json) =
      _$SharedPlaylistImpl.fromJson;

  /// 格式版本号，用于向前兼容
  @override
  @JsonKey(name: 'v')
  int get version;

  /// 歌单名称
  @override
  @JsonKey(name: 'n')
  String get name;

  /// 歌曲列表
  @override
  @JsonKey(name: 's')
  List<SharedSong> get songs;

  /// Create a copy of SharedPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedPlaylistImplCopyWith<_$SharedPlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharedSong _$SharedSongFromJson(Map<String, dynamic> json) {
  return _SharedSong.fromJson(json);
}

/// @nodoc
mixin _$SharedSong {
  /// Bilibili BV 号（全局唯一标识之一）
  @JsonKey(name: 'b')
  String get bvid => throw _privateConstructorUsedError;

  /// Bilibili CID（全局唯一标识之二）
  @JsonKey(name: 'c')
  int get cid => throw _privateConstructorUsedError;

  /// 用户自定义标题（仅在用户修改过时包含，否则省略）
  @JsonKey(name: 'ct', includeIfNull: false)
  String? get customTitle => throw _privateConstructorUsedError;

  /// 用户自定义作者（仅在用户修改过时包含，否则省略）
  @JsonKey(name: 'ca', includeIfNull: false)
  String? get customArtist => throw _privateConstructorUsedError;

  /// Serializes this SharedSong to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SharedSong
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SharedSongCopyWith<SharedSong> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharedSongCopyWith<$Res> {
  factory $SharedSongCopyWith(
          SharedSong value, $Res Function(SharedSong) then) =
      _$SharedSongCopyWithImpl<$Res, SharedSong>;
  @useResult
  $Res call(
      {@JsonKey(name: 'b') String bvid,
      @JsonKey(name: 'c') int cid,
      @JsonKey(name: 'ct', includeIfNull: false) String? customTitle,
      @JsonKey(name: 'ca', includeIfNull: false) String? customArtist});
}

/// @nodoc
class _$SharedSongCopyWithImpl<$Res, $Val extends SharedSong>
    implements $SharedSongCopyWith<$Res> {
  _$SharedSongCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SharedSong
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bvid = null,
    Object? cid = null,
    Object? customTitle = freezed,
    Object? customArtist = freezed,
  }) {
    return _then(_value.copyWith(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      customArtist: freezed == customArtist
          ? _value.customArtist
          : customArtist // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharedSongImplCopyWith<$Res>
    implements $SharedSongCopyWith<$Res> {
  factory _$$SharedSongImplCopyWith(
          _$SharedSongImpl value, $Res Function(_$SharedSongImpl) then) =
      __$$SharedSongImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'b') String bvid,
      @JsonKey(name: 'c') int cid,
      @JsonKey(name: 'ct', includeIfNull: false) String? customTitle,
      @JsonKey(name: 'ca', includeIfNull: false) String? customArtist});
}

/// @nodoc
class __$$SharedSongImplCopyWithImpl<$Res>
    extends _$SharedSongCopyWithImpl<$Res, _$SharedSongImpl>
    implements _$$SharedSongImplCopyWith<$Res> {
  __$$SharedSongImplCopyWithImpl(
      _$SharedSongImpl _value, $Res Function(_$SharedSongImpl) _then)
      : super(_value, _then);

  /// Create a copy of SharedSong
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bvid = null,
    Object? cid = null,
    Object? customTitle = freezed,
    Object? customArtist = freezed,
  }) {
    return _then(_$SharedSongImpl(
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      customArtist: freezed == customArtist
          ? _value.customArtist
          : customArtist // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharedSongImpl implements _SharedSong {
  const _$SharedSongImpl(
      {@JsonKey(name: 'b') required this.bvid,
      @JsonKey(name: 'c') required this.cid,
      @JsonKey(name: 'ct', includeIfNull: false) this.customTitle,
      @JsonKey(name: 'ca', includeIfNull: false) this.customArtist});

  factory _$SharedSongImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharedSongImplFromJson(json);

  /// Bilibili BV 号（全局唯一标识之一）
  @override
  @JsonKey(name: 'b')
  final String bvid;

  /// Bilibili CID（全局唯一标识之二）
  @override
  @JsonKey(name: 'c')
  final int cid;

  /// 用户自定义标题（仅在用户修改过时包含，否则省略）
  @override
  @JsonKey(name: 'ct', includeIfNull: false)
  final String? customTitle;

  /// 用户自定义作者（仅在用户修改过时包含，否则省略）
  @override
  @JsonKey(name: 'ca', includeIfNull: false)
  final String? customArtist;

  @override
  String toString() {
    return 'SharedSong(bvid: $bvid, cid: $cid, customTitle: $customTitle, customArtist: $customArtist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharedSongImpl &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.customTitle, customTitle) ||
                other.customTitle == customTitle) &&
            (identical(other.customArtist, customArtist) ||
                other.customArtist == customArtist));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, bvid, cid, customTitle, customArtist);

  /// Create a copy of SharedSong
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SharedSongImplCopyWith<_$SharedSongImpl> get copyWith =>
      __$$SharedSongImplCopyWithImpl<_$SharedSongImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharedSongImplToJson(
      this,
    );
  }
}

abstract class _SharedSong implements SharedSong {
  const factory _SharedSong(
      {@JsonKey(name: 'b') required final String bvid,
      @JsonKey(name: 'c') required final int cid,
      @JsonKey(name: 'ct', includeIfNull: false) final String? customTitle,
      @JsonKey(name: 'ca', includeIfNull: false)
      final String? customArtist}) = _$SharedSongImpl;

  factory _SharedSong.fromJson(Map<String, dynamic> json) =
      _$SharedSongImpl.fromJson;

  /// Bilibili BV 号（全局唯一标识之一）
  @override
  @JsonKey(name: 'b')
  String get bvid;

  /// Bilibili CID（全局唯一标识之二）
  @override
  @JsonKey(name: 'c')
  int get cid;

  /// 用户自定义标题（仅在用户修改过时包含，否则省略）
  @override
  @JsonKey(name: 'ct', includeIfNull: false)
  String? get customTitle;

  /// 用户自定义作者（仅在用户修改过时包含，否则省略）
  @override
  @JsonKey(name: 'ca', includeIfNull: false)
  String? get customArtist;

  /// Create a copy of SharedSong
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SharedSongImplCopyWith<_$SharedSongImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
