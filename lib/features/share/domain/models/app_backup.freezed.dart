// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppBackup _$AppBackupFromJson(Map<String, dynamic> json) {
  return _AppBackup.fromJson(json);
}

/// @nodoc
mixin _$AppBackup {
  /// 备份格式版本
  int get version => throw _privateConstructorUsedError;

  /// App 版本号
  String get appVersion => throw _privateConstructorUsedError;

  /// 备份创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 所有歌单
  List<BackupPlaylist> get playlists => throw _privateConstructorUsedError;

  /// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
  List<SharedSong> get songs => throw _privateConstructorUsedError;

  /// 歌单-歌曲关联关系
  List<BackupPlaylistSong> get playlistSongs =>
      throw _privateConstructorUsedError;

  /// 用户偏好设置
  BackupPreferences? get preferences => throw _privateConstructorUsedError;

  /// Serializes this AppBackup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppBackup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppBackupCopyWith<AppBackup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppBackupCopyWith<$Res> {
  factory $AppBackupCopyWith(AppBackup value, $Res Function(AppBackup) then) =
      _$AppBackupCopyWithImpl<$Res, AppBackup>;
  @useResult
  $Res call(
      {int version,
      String appVersion,
      DateTime createdAt,
      List<BackupPlaylist> playlists,
      List<SharedSong> songs,
      List<BackupPlaylistSong> playlistSongs,
      BackupPreferences? preferences});

  $BackupPreferencesCopyWith<$Res>? get preferences;
}

/// @nodoc
class _$AppBackupCopyWithImpl<$Res, $Val extends AppBackup>
    implements $AppBackupCopyWith<$Res> {
  _$AppBackupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppBackup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? appVersion = null,
    Object? createdAt = null,
    Object? playlists = null,
    Object? songs = null,
    Object? playlistSongs = null,
    Object? preferences = freezed,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playlists: null == playlists
          ? _value.playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as List<BackupPlaylist>,
      songs: null == songs
          ? _value.songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SharedSong>,
      playlistSongs: null == playlistSongs
          ? _value.playlistSongs
          : playlistSongs // ignore: cast_nullable_to_non_nullable
              as List<BackupPlaylistSong>,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as BackupPreferences?,
    ) as $Val);
  }

  /// Create a copy of AppBackup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackupPreferencesCopyWith<$Res>? get preferences {
    if (_value.preferences == null) {
      return null;
    }

    return $BackupPreferencesCopyWith<$Res>(_value.preferences!, (value) {
      return _then(_value.copyWith(preferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppBackupImplCopyWith<$Res>
    implements $AppBackupCopyWith<$Res> {
  factory _$$AppBackupImplCopyWith(
          _$AppBackupImpl value, $Res Function(_$AppBackupImpl) then) =
      __$$AppBackupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int version,
      String appVersion,
      DateTime createdAt,
      List<BackupPlaylist> playlists,
      List<SharedSong> songs,
      List<BackupPlaylistSong> playlistSongs,
      BackupPreferences? preferences});

  @override
  $BackupPreferencesCopyWith<$Res>? get preferences;
}

/// @nodoc
class __$$AppBackupImplCopyWithImpl<$Res>
    extends _$AppBackupCopyWithImpl<$Res, _$AppBackupImpl>
    implements _$$AppBackupImplCopyWith<$Res> {
  __$$AppBackupImplCopyWithImpl(
      _$AppBackupImpl _value, $Res Function(_$AppBackupImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppBackup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? appVersion = null,
    Object? createdAt = null,
    Object? playlists = null,
    Object? songs = null,
    Object? playlistSongs = null,
    Object? preferences = freezed,
  }) {
    return _then(_$AppBackupImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      playlists: null == playlists
          ? _value._playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as List<BackupPlaylist>,
      songs: null == songs
          ? _value._songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SharedSong>,
      playlistSongs: null == playlistSongs
          ? _value._playlistSongs
          : playlistSongs // ignore: cast_nullable_to_non_nullable
              as List<BackupPlaylistSong>,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as BackupPreferences?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppBackupImpl implements _AppBackup {
  const _$AppBackupImpl(
      {this.version = 1,
      required this.appVersion,
      required this.createdAt,
      required final List<BackupPlaylist> playlists,
      required final List<SharedSong> songs,
      required final List<BackupPlaylistSong> playlistSongs,
      this.preferences})
      : _playlists = playlists,
        _songs = songs,
        _playlistSongs = playlistSongs;

  factory _$AppBackupImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppBackupImplFromJson(json);

  /// 备份格式版本
  @override
  @JsonKey()
  final int version;

  /// App 版本号
  @override
  final String appVersion;

  /// 备份创建时间
  @override
  final DateTime createdAt;

  /// 所有歌单
  final List<BackupPlaylist> _playlists;

  /// 所有歌单
  @override
  List<BackupPlaylist> get playlists {
    if (_playlists is EqualUnmodifiableListView) return _playlists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playlists);
  }

  /// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
  final List<SharedSong> _songs;

  /// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
  @override
  List<SharedSong> get songs {
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_songs);
  }

  /// 歌单-歌曲关联关系
  final List<BackupPlaylistSong> _playlistSongs;

  /// 歌单-歌曲关联关系
  @override
  List<BackupPlaylistSong> get playlistSongs {
    if (_playlistSongs is EqualUnmodifiableListView) return _playlistSongs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playlistSongs);
  }

  /// 用户偏好设置
  @override
  final BackupPreferences? preferences;

  @override
  String toString() {
    return 'AppBackup(version: $version, appVersion: $appVersion, createdAt: $createdAt, playlists: $playlists, songs: $songs, playlistSongs: $playlistSongs, preferences: $preferences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppBackupImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._playlists, _playlists) &&
            const DeepCollectionEquality().equals(other._songs, _songs) &&
            const DeepCollectionEquality()
                .equals(other._playlistSongs, _playlistSongs) &&
            (identical(other.preferences, preferences) ||
                other.preferences == preferences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      version,
      appVersion,
      createdAt,
      const DeepCollectionEquality().hash(_playlists),
      const DeepCollectionEquality().hash(_songs),
      const DeepCollectionEquality().hash(_playlistSongs),
      preferences);

  /// Create a copy of AppBackup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppBackupImplCopyWith<_$AppBackupImpl> get copyWith =>
      __$$AppBackupImplCopyWithImpl<_$AppBackupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppBackupImplToJson(
      this,
    );
  }
}

abstract class _AppBackup implements AppBackup {
  const factory _AppBackup(
      {final int version,
      required final String appVersion,
      required final DateTime createdAt,
      required final List<BackupPlaylist> playlists,
      required final List<SharedSong> songs,
      required final List<BackupPlaylistSong> playlistSongs,
      final BackupPreferences? preferences}) = _$AppBackupImpl;

  factory _AppBackup.fromJson(Map<String, dynamic> json) =
      _$AppBackupImpl.fromJson;

  /// 备份格式版本
  @override
  int get version;

  /// App 版本号
  @override
  String get appVersion;

  /// 备份创建时间
  @override
  DateTime get createdAt;

  /// 所有歌单
  @override
  List<BackupPlaylist> get playlists;

  /// 所有歌曲（去重，全量）— 复用 SharedSong 精简结构
  @override
  List<SharedSong> get songs;

  /// 歌单-歌曲关联关系
  @override
  List<BackupPlaylistSong> get playlistSongs;

  /// 用户偏好设置
  @override
  BackupPreferences? get preferences;

  /// Create a copy of AppBackup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppBackupImplCopyWith<_$AppBackupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackupPlaylist _$BackupPlaylistFromJson(Map<String, dynamic> json) {
  return _BackupPlaylist.fromJson(json);
}

/// @nodoc
mixin _$BackupPlaylist {
  /// 原始 ID（用于关联关系映射）
  int get originalId => throw _privateConstructorUsedError;

  /// 歌单名称
  String get name => throw _privateConstructorUsedError;

  /// 歌单封面 URL
  String? get coverUrl => throw _privateConstructorUsedError;

  /// 排序序号
  int get sortOrder => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BackupPlaylist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupPlaylistCopyWith<BackupPlaylist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupPlaylistCopyWith<$Res> {
  factory $BackupPlaylistCopyWith(
          BackupPlaylist value, $Res Function(BackupPlaylist) then) =
      _$BackupPlaylistCopyWithImpl<$Res, BackupPlaylist>;
  @useResult
  $Res call(
      {int originalId,
      String name,
      String? coverUrl,
      int sortOrder,
      DateTime createdAt});
}

/// @nodoc
class _$BackupPlaylistCopyWithImpl<$Res, $Val extends BackupPlaylist>
    implements $BackupPlaylistCopyWith<$Res> {
  _$BackupPlaylistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalId = null,
    Object? name = null,
    Object? coverUrl = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      originalId: null == originalId
          ? _value.originalId
          : originalId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupPlaylistImplCopyWith<$Res>
    implements $BackupPlaylistCopyWith<$Res> {
  factory _$$BackupPlaylistImplCopyWith(_$BackupPlaylistImpl value,
          $Res Function(_$BackupPlaylistImpl) then) =
      __$$BackupPlaylistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int originalId,
      String name,
      String? coverUrl,
      int sortOrder,
      DateTime createdAt});
}

/// @nodoc
class __$$BackupPlaylistImplCopyWithImpl<$Res>
    extends _$BackupPlaylistCopyWithImpl<$Res, _$BackupPlaylistImpl>
    implements _$$BackupPlaylistImplCopyWith<$Res> {
  __$$BackupPlaylistImplCopyWithImpl(
      _$BackupPlaylistImpl _value, $Res Function(_$BackupPlaylistImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackupPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalId = null,
    Object? name = null,
    Object? coverUrl = freezed,
    Object? sortOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_$BackupPlaylistImpl(
      originalId: null == originalId
          ? _value.originalId
          : originalId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupPlaylistImpl implements _BackupPlaylist {
  const _$BackupPlaylistImpl(
      {required this.originalId,
      required this.name,
      this.coverUrl,
      required this.sortOrder,
      required this.createdAt});

  factory _$BackupPlaylistImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupPlaylistImplFromJson(json);

  /// 原始 ID（用于关联关系映射）
  @override
  final int originalId;

  /// 歌单名称
  @override
  final String name;

  /// 歌单封面 URL
  @override
  final String? coverUrl;

  /// 排序序号
  @override
  final int sortOrder;

  /// 创建时间
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BackupPlaylist(originalId: $originalId, name: $name, coverUrl: $coverUrl, sortOrder: $sortOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupPlaylistImpl &&
            (identical(other.originalId, originalId) ||
                other.originalId == originalId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, originalId, name, coverUrl, sortOrder, createdAt);

  /// Create a copy of BackupPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupPlaylistImplCopyWith<_$BackupPlaylistImpl> get copyWith =>
      __$$BackupPlaylistImplCopyWithImpl<_$BackupPlaylistImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupPlaylistImplToJson(
      this,
    );
  }
}

abstract class _BackupPlaylist implements BackupPlaylist {
  const factory _BackupPlaylist(
      {required final int originalId,
      required final String name,
      final String? coverUrl,
      required final int sortOrder,
      required final DateTime createdAt}) = _$BackupPlaylistImpl;

  factory _BackupPlaylist.fromJson(Map<String, dynamic> json) =
      _$BackupPlaylistImpl.fromJson;

  /// 原始 ID（用于关联关系映射）
  @override
  int get originalId;

  /// 歌单名称
  @override
  String get name;

  /// 歌单封面 URL
  @override
  String? get coverUrl;

  /// 排序序号
  @override
  int get sortOrder;

  /// 创建时间
  @override
  DateTime get createdAt;

  /// Create a copy of BackupPlaylist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupPlaylistImplCopyWith<_$BackupPlaylistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackupPlaylistSong _$BackupPlaylistSongFromJson(Map<String, dynamic> json) {
  return _BackupPlaylistSong.fromJson(json);
}

/// @nodoc
mixin _$BackupPlaylistSong {
  /// 原始歌单 ID
  int get playlistId => throw _privateConstructorUsedError;

  /// 歌曲的 bvid（用于跨设备映射）
  String get bvid => throw _privateConstructorUsedError;

  /// 歌曲的 cid
  int get cid => throw _privateConstructorUsedError;

  /// 排序
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this BackupPlaylistSong to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupPlaylistSong
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupPlaylistSongCopyWith<BackupPlaylistSong> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupPlaylistSongCopyWith<$Res> {
  factory $BackupPlaylistSongCopyWith(
          BackupPlaylistSong value, $Res Function(BackupPlaylistSong) then) =
      _$BackupPlaylistSongCopyWithImpl<$Res, BackupPlaylistSong>;
  @useResult
  $Res call({int playlistId, String bvid, int cid, int sortOrder});
}

/// @nodoc
class _$BackupPlaylistSongCopyWithImpl<$Res, $Val extends BackupPlaylistSong>
    implements $BackupPlaylistSongCopyWith<$Res> {
  _$BackupPlaylistSongCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupPlaylistSong
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = null,
    Object? bvid = null,
    Object? cid = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      playlistId: null == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int,
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupPlaylistSongImplCopyWith<$Res>
    implements $BackupPlaylistSongCopyWith<$Res> {
  factory _$$BackupPlaylistSongImplCopyWith(_$BackupPlaylistSongImpl value,
          $Res Function(_$BackupPlaylistSongImpl) then) =
      __$$BackupPlaylistSongImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int playlistId, String bvid, int cid, int sortOrder});
}

/// @nodoc
class __$$BackupPlaylistSongImplCopyWithImpl<$Res>
    extends _$BackupPlaylistSongCopyWithImpl<$Res, _$BackupPlaylistSongImpl>
    implements _$$BackupPlaylistSongImplCopyWith<$Res> {
  __$$BackupPlaylistSongImplCopyWithImpl(_$BackupPlaylistSongImpl _value,
      $Res Function(_$BackupPlaylistSongImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackupPlaylistSong
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playlistId = null,
    Object? bvid = null,
    Object? cid = null,
    Object? sortOrder = null,
  }) {
    return _then(_$BackupPlaylistSongImpl(
      playlistId: null == playlistId
          ? _value.playlistId
          : playlistId // ignore: cast_nullable_to_non_nullable
              as int,
      bvid: null == bvid
          ? _value.bvid
          : bvid // ignore: cast_nullable_to_non_nullable
              as String,
      cid: null == cid
          ? _value.cid
          : cid // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupPlaylistSongImpl implements _BackupPlaylistSong {
  const _$BackupPlaylistSongImpl(
      {required this.playlistId,
      required this.bvid,
      required this.cid,
      required this.sortOrder});

  factory _$BackupPlaylistSongImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupPlaylistSongImplFromJson(json);

  /// 原始歌单 ID
  @override
  final int playlistId;

  /// 歌曲的 bvid（用于跨设备映射）
  @override
  final String bvid;

  /// 歌曲的 cid
  @override
  final int cid;

  /// 排序
  @override
  final int sortOrder;

  @override
  String toString() {
    return 'BackupPlaylistSong(playlistId: $playlistId, bvid: $bvid, cid: $cid, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupPlaylistSongImpl &&
            (identical(other.playlistId, playlistId) ||
                other.playlistId == playlistId) &&
            (identical(other.bvid, bvid) || other.bvid == bvid) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, playlistId, bvid, cid, sortOrder);

  /// Create a copy of BackupPlaylistSong
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupPlaylistSongImplCopyWith<_$BackupPlaylistSongImpl> get copyWith =>
      __$$BackupPlaylistSongImplCopyWithImpl<_$BackupPlaylistSongImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupPlaylistSongImplToJson(
      this,
    );
  }
}

abstract class _BackupPlaylistSong implements BackupPlaylistSong {
  const factory _BackupPlaylistSong(
      {required final int playlistId,
      required final String bvid,
      required final int cid,
      required final int sortOrder}) = _$BackupPlaylistSongImpl;

  factory _BackupPlaylistSong.fromJson(Map<String, dynamic> json) =
      _$BackupPlaylistSongImpl.fromJson;

  /// 原始歌单 ID
  @override
  int get playlistId;

  /// 歌曲的 bvid（用于跨设备映射）
  @override
  String get bvid;

  /// 歌曲的 cid
  @override
  int get cid;

  /// 排序
  @override
  int get sortOrder;

  /// Create a copy of BackupPlaylistSong
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupPlaylistSongImplCopyWith<_$BackupPlaylistSongImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackupPreferences _$BackupPreferencesFromJson(Map<String, dynamic> json) {
  return _BackupPreferences.fromJson(json);
}

/// @nodoc
mixin _$BackupPreferences {
  /// 主题模式
  String? get themeMode => throw _privateConstructorUsedError;

  /// 语言
  String? get locale => throw _privateConstructorUsedError;

  /// 首选音质
  int? get preferredQuality => throw _privateConstructorUsedError;

  /// 缓存路径
  String? get cachePath => throw _privateConstructorUsedError;

  /// Serializes this BackupPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackupPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackupPreferencesCopyWith<BackupPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupPreferencesCopyWith<$Res> {
  factory $BackupPreferencesCopyWith(
          BackupPreferences value, $Res Function(BackupPreferences) then) =
      _$BackupPreferencesCopyWithImpl<$Res, BackupPreferences>;
  @useResult
  $Res call(
      {String? themeMode,
      String? locale,
      int? preferredQuality,
      String? cachePath});
}

/// @nodoc
class _$BackupPreferencesCopyWithImpl<$Res, $Val extends BackupPreferences>
    implements $BackupPreferencesCopyWith<$Res> {
  _$BackupPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackupPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = freezed,
    Object? locale = freezed,
    Object? preferredQuality = freezed,
    Object? cachePath = freezed,
  }) {
    return _then(_value.copyWith(
      themeMode: freezed == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredQuality: freezed == preferredQuality
          ? _value.preferredQuality
          : preferredQuality // ignore: cast_nullable_to_non_nullable
              as int?,
      cachePath: freezed == cachePath
          ? _value.cachePath
          : cachePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupPreferencesImplCopyWith<$Res>
    implements $BackupPreferencesCopyWith<$Res> {
  factory _$$BackupPreferencesImplCopyWith(_$BackupPreferencesImpl value,
          $Res Function(_$BackupPreferencesImpl) then) =
      __$$BackupPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? themeMode,
      String? locale,
      int? preferredQuality,
      String? cachePath});
}

/// @nodoc
class __$$BackupPreferencesImplCopyWithImpl<$Res>
    extends _$BackupPreferencesCopyWithImpl<$Res, _$BackupPreferencesImpl>
    implements _$$BackupPreferencesImplCopyWith<$Res> {
  __$$BackupPreferencesImplCopyWithImpl(_$BackupPreferencesImpl _value,
      $Res Function(_$BackupPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackupPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = freezed,
    Object? locale = freezed,
    Object? preferredQuality = freezed,
    Object? cachePath = freezed,
  }) {
    return _then(_$BackupPreferencesImpl(
      themeMode: freezed == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      preferredQuality: freezed == preferredQuality
          ? _value.preferredQuality
          : preferredQuality // ignore: cast_nullable_to_non_nullable
              as int?,
      cachePath: freezed == cachePath
          ? _value.cachePath
          : cachePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupPreferencesImpl implements _BackupPreferences {
  const _$BackupPreferencesImpl(
      {this.themeMode, this.locale, this.preferredQuality, this.cachePath});

  factory _$BackupPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupPreferencesImplFromJson(json);

  /// 主题模式
  @override
  final String? themeMode;

  /// 语言
  @override
  final String? locale;

  /// 首选音质
  @override
  final int? preferredQuality;

  /// 缓存路径
  @override
  final String? cachePath;

  @override
  String toString() {
    return 'BackupPreferences(themeMode: $themeMode, locale: $locale, preferredQuality: $preferredQuality, cachePath: $cachePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupPreferencesImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.preferredQuality, preferredQuality) ||
                other.preferredQuality == preferredQuality) &&
            (identical(other.cachePath, cachePath) ||
                other.cachePath == cachePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, themeMode, locale, preferredQuality, cachePath);

  /// Create a copy of BackupPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupPreferencesImplCopyWith<_$BackupPreferencesImpl> get copyWith =>
      __$$BackupPreferencesImplCopyWithImpl<_$BackupPreferencesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupPreferencesImplToJson(
      this,
    );
  }
}

abstract class _BackupPreferences implements BackupPreferences {
  const factory _BackupPreferences(
      {final String? themeMode,
      final String? locale,
      final int? preferredQuality,
      final String? cachePath}) = _$BackupPreferencesImpl;

  factory _BackupPreferences.fromJson(Map<String, dynamic> json) =
      _$BackupPreferencesImpl.fromJson;

  /// 主题模式
  @override
  String? get themeMode;

  /// 语言
  @override
  String? get locale;

  /// 首选音质
  @override
  int? get preferredQuality;

  /// 缓存路径
  @override
  String? get cachePath;

  /// Create a copy of BackupPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackupPreferencesImplCopyWith<_$BackupPreferencesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
