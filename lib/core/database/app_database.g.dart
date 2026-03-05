// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bvidMeta = const VerificationMeta('bvid');
  @override
  late final GeneratedColumn<String> bvid = GeneratedColumn<String>(
      'bvid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<int> cid = GeneratedColumn<int>(
      'cid', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _originTitleMeta =
      const VerificationMeta('originTitle');
  @override
  late final GeneratedColumn<String> originTitle = GeneratedColumn<String>(
      'origin_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originArtistMeta =
      const VerificationMeta('originArtist');
  @override
  late final GeneratedColumn<String> originArtist = GeneratedColumn<String>(
      'origin_artist', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customTitleMeta =
      const VerificationMeta('customTitle');
  @override
  late final GeneratedColumn<String> customTitle = GeneratedColumn<String>(
      'custom_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customArtistMeta =
      const VerificationMeta('customArtist');
  @override
  late final GeneratedColumn<String> customArtist = GeneratedColumn<String>(
      'custom_artist', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverUrlMeta =
      const VerificationMeta('coverUrl');
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
      'cover_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _audioQualityMeta =
      const VerificationMeta('audioQuality');
  @override
  late final GeneratedColumn<int> audioQuality = GeneratedColumn<int>(
      'audio_quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bvid,
        cid,
        originTitle,
        originArtist,
        customTitle,
        customArtist,
        coverUrl,
        duration,
        audioQuality,
        localPath,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bvid')) {
      context.handle(
          _bvidMeta, bvid.isAcceptableOrUnknown(data['bvid']!, _bvidMeta));
    } else if (isInserting) {
      context.missing(_bvidMeta);
    }
    if (data.containsKey('cid')) {
      context.handle(
          _cidMeta, cid.isAcceptableOrUnknown(data['cid']!, _cidMeta));
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (data.containsKey('origin_title')) {
      context.handle(
          _originTitleMeta,
          originTitle.isAcceptableOrUnknown(
              data['origin_title']!, _originTitleMeta));
    } else if (isInserting) {
      context.missing(_originTitleMeta);
    }
    if (data.containsKey('origin_artist')) {
      context.handle(
          _originArtistMeta,
          originArtist.isAcceptableOrUnknown(
              data['origin_artist']!, _originArtistMeta));
    } else if (isInserting) {
      context.missing(_originArtistMeta);
    }
    if (data.containsKey('custom_title')) {
      context.handle(
          _customTitleMeta,
          customTitle.isAcceptableOrUnknown(
              data['custom_title']!, _customTitleMeta));
    }
    if (data.containsKey('custom_artist')) {
      context.handle(
          _customArtistMeta,
          customArtist.isAcceptableOrUnknown(
              data['custom_artist']!, _customArtistMeta));
    }
    if (data.containsKey('cover_url')) {
      context.handle(_coverUrlMeta,
          coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('audio_quality')) {
      context.handle(
          _audioQualityMeta,
          audioQuality.isAcceptableOrUnknown(
              data['audio_quality']!, _audioQualityMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bvid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bvid'])!,
      cid: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cid'])!,
      originTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin_title'])!,
      originArtist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin_artist'])!,
      customTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_title']),
      customArtist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_artist']),
      coverUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_url']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      audioQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}audio_quality'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  /// Auto-incrementing primary key.
  final int id;

  /// Bilibili BV number (e.g., "BV1xx411c7mD").
  final String bvid;

  /// Bilibili CID (unique per video page/part).
  final int cid;

  /// Original title fetched from Bilibili.
  final String originTitle;

  /// Original artist (UP主 name) fetched from Bilibili.
  final String originArtist;

  /// User-customized title (nullable, overrides originTitle when set).
  final String? customTitle;

  /// User-customized artist (nullable, overrides originArtist when set).
  final String? customArtist;

  /// Cover image URL.
  final String? coverUrl;

  /// Duration in seconds.
  final int duration;

  /// Audio quality identifier (e.g., 30280 for 192kbps).
  final int audioQuality;

  /// Local file path if cached/downloaded.
  final String? localPath;

  /// Timestamp when the song was added.
  final DateTime createdAt;
  const Song(
      {required this.id,
      required this.bvid,
      required this.cid,
      required this.originTitle,
      required this.originArtist,
      this.customTitle,
      this.customArtist,
      this.coverUrl,
      required this.duration,
      required this.audioQuality,
      this.localPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bvid'] = Variable<String>(bvid);
    map['cid'] = Variable<int>(cid);
    map['origin_title'] = Variable<String>(originTitle);
    map['origin_artist'] = Variable<String>(originArtist);
    if (!nullToAbsent || customTitle != null) {
      map['custom_title'] = Variable<String>(customTitle);
    }
    if (!nullToAbsent || customArtist != null) {
      map['custom_artist'] = Variable<String>(customArtist);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    map['duration'] = Variable<int>(duration);
    map['audio_quality'] = Variable<int>(audioQuality);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      bvid: Value(bvid),
      cid: Value(cid),
      originTitle: Value(originTitle),
      originArtist: Value(originArtist),
      customTitle: customTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(customTitle),
      customArtist: customArtist == null && nullToAbsent
          ? const Value.absent()
          : Value(customArtist),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      duration: Value(duration),
      audioQuality: Value(audioQuality),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      createdAt: Value(createdAt),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      bvid: serializer.fromJson<String>(json['bvid']),
      cid: serializer.fromJson<int>(json['cid']),
      originTitle: serializer.fromJson<String>(json['originTitle']),
      originArtist: serializer.fromJson<String>(json['originArtist']),
      customTitle: serializer.fromJson<String?>(json['customTitle']),
      customArtist: serializer.fromJson<String?>(json['customArtist']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      duration: serializer.fromJson<int>(json['duration']),
      audioQuality: serializer.fromJson<int>(json['audioQuality']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bvid': serializer.toJson<String>(bvid),
      'cid': serializer.toJson<int>(cid),
      'originTitle': serializer.toJson<String>(originTitle),
      'originArtist': serializer.toJson<String>(originArtist),
      'customTitle': serializer.toJson<String?>(customTitle),
      'customArtist': serializer.toJson<String?>(customArtist),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'duration': serializer.toJson<int>(duration),
      'audioQuality': serializer.toJson<int>(audioQuality),
      'localPath': serializer.toJson<String?>(localPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Song copyWith(
          {int? id,
          String? bvid,
          int? cid,
          String? originTitle,
          String? originArtist,
          Value<String?> customTitle = const Value.absent(),
          Value<String?> customArtist = const Value.absent(),
          Value<String?> coverUrl = const Value.absent(),
          int? duration,
          int? audioQuality,
          Value<String?> localPath = const Value.absent(),
          DateTime? createdAt}) =>
      Song(
        id: id ?? this.id,
        bvid: bvid ?? this.bvid,
        cid: cid ?? this.cid,
        originTitle: originTitle ?? this.originTitle,
        originArtist: originArtist ?? this.originArtist,
        customTitle: customTitle.present ? customTitle.value : this.customTitle,
        customArtist:
            customArtist.present ? customArtist.value : this.customArtist,
        coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
        duration: duration ?? this.duration,
        audioQuality: audioQuality ?? this.audioQuality,
        localPath: localPath.present ? localPath.value : this.localPath,
        createdAt: createdAt ?? this.createdAt,
      );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      bvid: data.bvid.present ? data.bvid.value : this.bvid,
      cid: data.cid.present ? data.cid.value : this.cid,
      originTitle:
          data.originTitle.present ? data.originTitle.value : this.originTitle,
      originArtist: data.originArtist.present
          ? data.originArtist.value
          : this.originArtist,
      customTitle:
          data.customTitle.present ? data.customTitle.value : this.customTitle,
      customArtist: data.customArtist.present
          ? data.customArtist.value
          : this.customArtist,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      duration: data.duration.present ? data.duration.value : this.duration,
      audioQuality: data.audioQuality.present
          ? data.audioQuality.value
          : this.audioQuality,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('originTitle: $originTitle, ')
          ..write('originArtist: $originArtist, ')
          ..write('customTitle: $customTitle, ')
          ..write('customArtist: $customArtist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('duration: $duration, ')
          ..write('audioQuality: $audioQuality, ')
          ..write('localPath: $localPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      bvid,
      cid,
      originTitle,
      originArtist,
      customTitle,
      customArtist,
      coverUrl,
      duration,
      audioQuality,
      localPath,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.bvid == this.bvid &&
          other.cid == this.cid &&
          other.originTitle == this.originTitle &&
          other.originArtist == this.originArtist &&
          other.customTitle == this.customTitle &&
          other.customArtist == this.customArtist &&
          other.coverUrl == this.coverUrl &&
          other.duration == this.duration &&
          other.audioQuality == this.audioQuality &&
          other.localPath == this.localPath &&
          other.createdAt == this.createdAt);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> bvid;
  final Value<int> cid;
  final Value<String> originTitle;
  final Value<String> originArtist;
  final Value<String?> customTitle;
  final Value<String?> customArtist;
  final Value<String?> coverUrl;
  final Value<int> duration;
  final Value<int> audioQuality;
  final Value<String?> localPath;
  final Value<DateTime> createdAt;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.originTitle = const Value.absent(),
    this.originArtist = const Value.absent(),
    this.customTitle = const Value.absent(),
    this.customArtist = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.audioQuality = const Value.absent(),
    this.localPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String bvid,
    required int cid,
    required String originTitle,
    required String originArtist,
    this.customTitle = const Value.absent(),
    this.customArtist = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.audioQuality = const Value.absent(),
    this.localPath = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : bvid = Value(bvid),
        cid = Value(cid),
        originTitle = Value(originTitle),
        originArtist = Value(originArtist);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? bvid,
    Expression<int>? cid,
    Expression<String>? originTitle,
    Expression<String>? originArtist,
    Expression<String>? customTitle,
    Expression<String>? customArtist,
    Expression<String>? coverUrl,
    Expression<int>? duration,
    Expression<int>? audioQuality,
    Expression<String>? localPath,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bvid != null) 'bvid': bvid,
      if (cid != null) 'cid': cid,
      if (originTitle != null) 'origin_title': originTitle,
      if (originArtist != null) 'origin_artist': originArtist,
      if (customTitle != null) 'custom_title': customTitle,
      if (customArtist != null) 'custom_artist': customArtist,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (duration != null) 'duration': duration,
      if (audioQuality != null) 'audio_quality': audioQuality,
      if (localPath != null) 'local_path': localPath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bvid,
      Value<int>? cid,
      Value<String>? originTitle,
      Value<String>? originArtist,
      Value<String?>? customTitle,
      Value<String?>? customArtist,
      Value<String?>? coverUrl,
      Value<int>? duration,
      Value<int>? audioQuality,
      Value<String?>? localPath,
      Value<DateTime>? createdAt}) {
    return SongsCompanion(
      id: id ?? this.id,
      bvid: bvid ?? this.bvid,
      cid: cid ?? this.cid,
      originTitle: originTitle ?? this.originTitle,
      originArtist: originArtist ?? this.originArtist,
      customTitle: customTitle ?? this.customTitle,
      customArtist: customArtist ?? this.customArtist,
      coverUrl: coverUrl ?? this.coverUrl,
      duration: duration ?? this.duration,
      audioQuality: audioQuality ?? this.audioQuality,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bvid.present) {
      map['bvid'] = Variable<String>(bvid.value);
    }
    if (cid.present) {
      map['cid'] = Variable<int>(cid.value);
    }
    if (originTitle.present) {
      map['origin_title'] = Variable<String>(originTitle.value);
    }
    if (originArtist.present) {
      map['origin_artist'] = Variable<String>(originArtist.value);
    }
    if (customTitle.present) {
      map['custom_title'] = Variable<String>(customTitle.value);
    }
    if (customArtist.present) {
      map['custom_artist'] = Variable<String>(customArtist.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (audioQuality.present) {
      map['audio_quality'] = Variable<int>(audioQuality.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('originTitle: $originTitle, ')
          ..write('originArtist: $originArtist, ')
          ..write('customTitle: $customTitle, ')
          ..write('customArtist: $customArtist, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('duration: $duration, ')
          ..write('audioQuality: $audioQuality, ')
          ..write('localPath: $localPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, Playlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _coverUrlMeta =
      const VerificationMeta('coverUrl');
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
      'cover_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, coverUrl, sortOrder, isFavorite, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(Insertable<Playlist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_url')) {
      context.handle(_coverUrlMeta,
          coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Playlist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      coverUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_url']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class Playlist extends DataClass implements Insertable<Playlist> {
  /// Auto-incrementing primary key.
  final int id;

  /// Playlist display name.
  final String name;

  /// Optional cover image URL (first song cover or user-set).
  final String? coverUrl;

  /// Sort order for playlist list display.
  final int sortOrder;

  /// Whether this is the system "My Favorites" playlist.
  /// Only one playlist can have this set to true.
  final bool isFavorite;

  /// Timestamp when the playlist was created.
  final DateTime createdAt;
  const Playlist(
      {required this.id,
      required this.name,
      this.coverUrl,
      required this.sortOrder,
      required this.isFavorite,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      sortOrder: Value(sortOrder),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory Playlist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Playlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Playlist copyWith(
          {int? id,
          String? name,
          Value<String?> coverUrl = const Value.absent(),
          int? sortOrder,
          bool? isFavorite,
          DateTime? createdAt}) =>
      Playlist(
        id: id ?? this.id,
        name: name ?? this.name,
        coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
        sortOrder: sortOrder ?? this.sortOrder,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt ?? this.createdAt,
      );
  Playlist copyWithCompanion(PlaylistsCompanion data) {
    return Playlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Playlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, coverUrl, sortOrder, isFavorite, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Playlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.coverUrl == this.coverUrl &&
          other.sortOrder == this.sortOrder &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class PlaylistsCompanion extends UpdateCompanion<Playlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> coverUrl;
  final Value<int> sortOrder;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.coverUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Playlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? coverUrl,
    Expression<int>? sortOrder,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlaylistsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? coverUrl,
      Value<int>? sortOrder,
      Value<bool>? isFavorite,
      Value<DateTime>? createdAt}) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlaylistSongsTable extends PlaylistSongs
    with TableInfo<$PlaylistSongsTable, PlaylistSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta =
      const VerificationMeta('playlistId');
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
      'playlist_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES playlists (id)'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [playlistId, songId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlist_songs';
  @override
  VerificationContext validateIntegrity(Insertable<PlaylistSong> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
          _playlistIdMeta,
          playlistId.isAcceptableOrUnknown(
              data['playlist_id']!, _playlistIdMeta));
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, songId};
  @override
  PlaylistSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistSong(
      playlistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}playlist_id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $PlaylistSongsTable createAlias(String alias) {
    return $PlaylistSongsTable(attachedDatabase, alias);
  }
}

class PlaylistSong extends DataClass implements Insertable<PlaylistSong> {
  /// Foreign key referencing [Playlists.id].
  final int playlistId;

  /// Foreign key referencing [Songs.id].
  final int songId;

  /// Sort order within the playlist.
  final int sortOrder;
  const PlaylistSong(
      {required this.playlistId,
      required this.songId,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<int>(playlistId);
    map['song_id'] = Variable<int>(songId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PlaylistSongsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistSongsCompanion(
      playlistId: Value(playlistId),
      songId: Value(songId),
      sortOrder: Value(sortOrder),
    );
  }

  factory PlaylistSong.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistSong(
      playlistId: serializer.fromJson<int>(json['playlistId']),
      songId: serializer.fromJson<int>(json['songId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<int>(playlistId),
      'songId': serializer.toJson<int>(songId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PlaylistSong copyWith({int? playlistId, int? songId, int? sortOrder}) =>
      PlaylistSong(
        playlistId: playlistId ?? this.playlistId,
        songId: songId ?? this.songId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  PlaylistSong copyWithCompanion(PlaylistSongsCompanion data) {
    return PlaylistSong(
      playlistId:
          data.playlistId.present ? data.playlistId.value : this.playlistId,
      songId: data.songId.present ? data.songId.value : this.songId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistSong(')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(playlistId, songId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistSong &&
          other.playlistId == this.playlistId &&
          other.songId == this.songId &&
          other.sortOrder == this.sortOrder);
}

class PlaylistSongsCompanion extends UpdateCompanion<PlaylistSong> {
  final Value<int> playlistId;
  final Value<int> songId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const PlaylistSongsCompanion({
    this.playlistId = const Value.absent(),
    this.songId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistSongsCompanion.insert({
    required int playlistId,
    required int songId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : playlistId = Value(playlistId),
        songId = Value(songId);
  static Insertable<PlaylistSong> custom({
    Expression<int>? playlistId,
    Expression<int>? songId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (songId != null) 'song_id': songId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistSongsCompanion copyWith(
      {Value<int>? playlistId,
      Value<int>? songId,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return PlaylistSongsCompanion(
      playlistId: playlistId ?? this.playlistId,
      songId: songId ?? this.songId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistSongsCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('songId: $songId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadTasksTable extends DownloadTasks
    with TableInfo<$DownloadTasksTable, DownloadTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
      'song_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES songs (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _qualityMeta =
      const VerificationMeta('quality');
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
      'quality', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, songId, status, progress, filePath, quality, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<DownloadTask> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    }
    if (data.containsKey('quality')) {
      context.handle(_qualityMeta,
          quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadTask(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}song_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path']),
      quality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quality'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DownloadTasksTable createAlias(String alias) {
    return $DownloadTasksTable(attachedDatabase, alias);
  }
}

class DownloadTask extends DataClass implements Insertable<DownloadTask> {
  /// Auto-incrementing primary key.
  final int id;

  /// Foreign key referencing [Songs.id].
  final int songId;

  /// Download status: 0=pending, 1=downloading, 2=completed, 3=failed.
  final int status;

  /// Download progress (0.0 - 1.0), stored as integer percentage (0-100).
  final int progress;

  /// Target local file path.
  final String? filePath;

  /// Audio quality identifier used for this download (e.g. 30280).
  final int quality;

  /// Timestamp when the download task was created.
  final DateTime createdAt;
  const DownloadTask(
      {required this.id,
      required this.songId,
      required this.status,
      required this.progress,
      this.filePath,
      required this.quality,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['song_id'] = Variable<int>(songId);
    map['status'] = Variable<int>(status);
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['quality'] = Variable<int>(quality);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DownloadTasksCompanion toCompanion(bool nullToAbsent) {
    return DownloadTasksCompanion(
      id: Value(id),
      songId: Value(songId),
      status: Value(status),
      progress: Value(progress),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      quality: Value(quality),
      createdAt: Value(createdAt),
    );
  }

  factory DownloadTask.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadTask(
      id: serializer.fromJson<int>(json['id']),
      songId: serializer.fromJson<int>(json['songId']),
      status: serializer.fromJson<int>(json['status']),
      progress: serializer.fromJson<int>(json['progress']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      quality: serializer.fromJson<int>(json['quality']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'songId': serializer.toJson<int>(songId),
      'status': serializer.toJson<int>(status),
      'progress': serializer.toJson<int>(progress),
      'filePath': serializer.toJson<String?>(filePath),
      'quality': serializer.toJson<int>(quality),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DownloadTask copyWith(
          {int? id,
          int? songId,
          int? status,
          int? progress,
          Value<String?> filePath = const Value.absent(),
          int? quality,
          DateTime? createdAt}) =>
      DownloadTask(
        id: id ?? this.id,
        songId: songId ?? this.songId,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        filePath: filePath.present ? filePath.value : this.filePath,
        quality: quality ?? this.quality,
        createdAt: createdAt ?? this.createdAt,
      );
  DownloadTask copyWithCompanion(DownloadTasksCompanion data) {
    return DownloadTask(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      quality: data.quality.present ? data.quality.value : this.quality,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTask(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('filePath: $filePath, ')
          ..write('quality: $quality, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, songId, status, progress, filePath, quality, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadTask &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.filePath == this.filePath &&
          other.quality == this.quality &&
          other.createdAt == this.createdAt);
}

class DownloadTasksCompanion extends UpdateCompanion<DownloadTask> {
  final Value<int> id;
  final Value<int> songId;
  final Value<int> status;
  final Value<int> progress;
  final Value<String?> filePath;
  final Value<int> quality;
  final Value<DateTime> createdAt;
  const DownloadTasksCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.filePath = const Value.absent(),
    this.quality = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DownloadTasksCompanion.insert({
    this.id = const Value.absent(),
    required int songId,
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.filePath = const Value.absent(),
    this.quality = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : songId = Value(songId);
  static Insertable<DownloadTask> custom({
    Expression<int>? id,
    Expression<int>? songId,
    Expression<int>? status,
    Expression<int>? progress,
    Expression<String>? filePath,
    Expression<int>? quality,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (filePath != null) 'file_path': filePath,
      if (quality != null) 'quality': quality,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DownloadTasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? songId,
      Value<int>? status,
      Value<int>? progress,
      Value<String?>? filePath,
      Value<int>? quality,
      Value<DateTime>? createdAt}) {
    return DownloadTasksCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      quality: quality ?? this.quality,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadTasksCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('filePath: $filePath, ')
          ..write('quality: $quality, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSessionsTable extends UserSessions
    with TableInfo<$UserSessionsTable, UserSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sessdataMeta =
      const VerificationMeta('sessdata');
  @override
  late final GeneratedColumn<String> sessdata = GeneratedColumn<String>(
      'sessdata', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _biliJctMeta =
      const VerificationMeta('biliJct');
  @override
  late final GeneratedColumn<String> biliJct = GeneratedColumn<String>(
      'bili_jct', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dedeUserIdMeta =
      const VerificationMeta('dedeUserId');
  @override
  late final GeneratedColumn<String> dedeUserId = GeneratedColumn<String>(
      'dede_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiresMeta =
      const VerificationMeta('expires');
  @override
  late final GeneratedColumn<DateTime> expires = GeneratedColumn<DateTime>(
      'expires', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sessdata, biliJct, dedeUserId, expires, avatarUrl, nickname];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<UserSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sessdata')) {
      context.handle(_sessdataMeta,
          sessdata.isAcceptableOrUnknown(data['sessdata']!, _sessdataMeta));
    } else if (isInserting) {
      context.missing(_sessdataMeta);
    }
    if (data.containsKey('bili_jct')) {
      context.handle(_biliJctMeta,
          biliJct.isAcceptableOrUnknown(data['bili_jct']!, _biliJctMeta));
    } else if (isInserting) {
      context.missing(_biliJctMeta);
    }
    if (data.containsKey('dede_user_id')) {
      context.handle(
          _dedeUserIdMeta,
          dedeUserId.isAcceptableOrUnknown(
              data['dede_user_id']!, _dedeUserIdMeta));
    } else if (isInserting) {
      context.missing(_dedeUserIdMeta);
    }
    if (data.containsKey('expires')) {
      context.handle(_expiresMeta,
          expires.isAcceptableOrUnknown(data['expires']!, _expiresMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sessdata: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sessdata'])!,
      biliJct: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bili_jct'])!,
      dedeUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dede_user_id'])!,
      expires: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname']),
    );
  }

  @override
  $UserSessionsTable createAlias(String alias) {
    return $UserSessionsTable(attachedDatabase, alias);
  }
}

class UserSession extends DataClass implements Insertable<UserSession> {
  /// Auto-incrementing primary key.
  final int id;

  /// Bilibili SESSDATA cookie value.
  final String sessdata;

  /// Bilibili bili_jct (CSRF token) cookie value.
  final String biliJct;

  /// Bilibili DedeUserID.
  final String dedeUserId;

  /// Session expiration timestamp.
  final DateTime? expires;

  /// User avatar URL.
  final String? avatarUrl;

  /// User display name / nickname.
  final String? nickname;
  const UserSession(
      {required this.id,
      required this.sessdata,
      required this.biliJct,
      required this.dedeUserId,
      this.expires,
      this.avatarUrl,
      this.nickname});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sessdata'] = Variable<String>(sessdata);
    map['bili_jct'] = Variable<String>(biliJct);
    map['dede_user_id'] = Variable<String>(dedeUserId);
    if (!nullToAbsent || expires != null) {
      map['expires'] = Variable<DateTime>(expires);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    return map;
  }

  UserSessionsCompanion toCompanion(bool nullToAbsent) {
    return UserSessionsCompanion(
      id: Value(id),
      sessdata: Value(sessdata),
      biliJct: Value(biliJct),
      dedeUserId: Value(dedeUserId),
      expires: expires == null && nullToAbsent
          ? const Value.absent()
          : Value(expires),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
    );
  }

  factory UserSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSession(
      id: serializer.fromJson<int>(json['id']),
      sessdata: serializer.fromJson<String>(json['sessdata']),
      biliJct: serializer.fromJson<String>(json['biliJct']),
      dedeUserId: serializer.fromJson<String>(json['dedeUserId']),
      expires: serializer.fromJson<DateTime?>(json['expires']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      nickname: serializer.fromJson<String?>(json['nickname']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessdata': serializer.toJson<String>(sessdata),
      'biliJct': serializer.toJson<String>(biliJct),
      'dedeUserId': serializer.toJson<String>(dedeUserId),
      'expires': serializer.toJson<DateTime?>(expires),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'nickname': serializer.toJson<String?>(nickname),
    };
  }

  UserSession copyWith(
          {int? id,
          String? sessdata,
          String? biliJct,
          String? dedeUserId,
          Value<DateTime?> expires = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          Value<String?> nickname = const Value.absent()}) =>
      UserSession(
        id: id ?? this.id,
        sessdata: sessdata ?? this.sessdata,
        biliJct: biliJct ?? this.biliJct,
        dedeUserId: dedeUserId ?? this.dedeUserId,
        expires: expires.present ? expires.value : this.expires,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        nickname: nickname.present ? nickname.value : this.nickname,
      );
  UserSession copyWithCompanion(UserSessionsCompanion data) {
    return UserSession(
      id: data.id.present ? data.id.value : this.id,
      sessdata: data.sessdata.present ? data.sessdata.value : this.sessdata,
      biliJct: data.biliJct.present ? data.biliJct.value : this.biliJct,
      dedeUserId:
          data.dedeUserId.present ? data.dedeUserId.value : this.dedeUserId,
      expires: data.expires.present ? data.expires.value : this.expires,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSession(')
          ..write('id: $id, ')
          ..write('sessdata: $sessdata, ')
          ..write('biliJct: $biliJct, ')
          ..write('dedeUserId: $dedeUserId, ')
          ..write('expires: $expires, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('nickname: $nickname')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sessdata, biliJct, dedeUserId, expires, avatarUrl, nickname);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSession &&
          other.id == this.id &&
          other.sessdata == this.sessdata &&
          other.biliJct == this.biliJct &&
          other.dedeUserId == this.dedeUserId &&
          other.expires == this.expires &&
          other.avatarUrl == this.avatarUrl &&
          other.nickname == this.nickname);
}

class UserSessionsCompanion extends UpdateCompanion<UserSession> {
  final Value<int> id;
  final Value<String> sessdata;
  final Value<String> biliJct;
  final Value<String> dedeUserId;
  final Value<DateTime?> expires;
  final Value<String?> avatarUrl;
  final Value<String?> nickname;
  const UserSessionsCompanion({
    this.id = const Value.absent(),
    this.sessdata = const Value.absent(),
    this.biliJct = const Value.absent(),
    this.dedeUserId = const Value.absent(),
    this.expires = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.nickname = const Value.absent(),
  });
  UserSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String sessdata,
    required String biliJct,
    required String dedeUserId,
    this.expires = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.nickname = const Value.absent(),
  })  : sessdata = Value(sessdata),
        biliJct = Value(biliJct),
        dedeUserId = Value(dedeUserId);
  static Insertable<UserSession> custom({
    Expression<int>? id,
    Expression<String>? sessdata,
    Expression<String>? biliJct,
    Expression<String>? dedeUserId,
    Expression<DateTime>? expires,
    Expression<String>? avatarUrl,
    Expression<String>? nickname,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessdata != null) 'sessdata': sessdata,
      if (biliJct != null) 'bili_jct': biliJct,
      if (dedeUserId != null) 'dede_user_id': dedeUserId,
      if (expires != null) 'expires': expires,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (nickname != null) 'nickname': nickname,
    });
  }

  UserSessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? sessdata,
      Value<String>? biliJct,
      Value<String>? dedeUserId,
      Value<DateTime?>? expires,
      Value<String?>? avatarUrl,
      Value<String?>? nickname}) {
    return UserSessionsCompanion(
      id: id ?? this.id,
      sessdata: sessdata ?? this.sessdata,
      biliJct: biliJct ?? this.biliJct,
      dedeUserId: dedeUserId ?? this.dedeUserId,
      expires: expires ?? this.expires,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      nickname: nickname ?? this.nickname,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessdata.present) {
      map['sessdata'] = Variable<String>(sessdata.value);
    }
    if (biliJct.present) {
      map['bili_jct'] = Variable<String>(biliJct.value);
    }
    if (dedeUserId.present) {
      map['dede_user_id'] = Variable<String>(dedeUserId.value);
    }
    if (expires.present) {
      map['expires'] = Variable<DateTime>(expires.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSessionsCompanion(')
          ..write('id: $id, ')
          ..write('sessdata: $sessdata, ')
          ..write('biliJct: $biliJct, ')
          ..write('dedeUserId: $dedeUserId, ')
          ..write('expires: $expires, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('nickname: $nickname')
          ..write(')'))
        .toString();
  }
}

class $SubtitlesTable extends Subtitles
    with TableInfo<$SubtitlesTable, Subtitle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtitlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bvidMeta = const VerificationMeta('bvid');
  @override
  late final GeneratedColumn<String> bvid = GeneratedColumn<String>(
      'bvid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<int> cid = GeneratedColumn<int>(
      'cid', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _subtitleJsonMeta =
      const VerificationMeta('subtitleJson');
  @override
  late final GeneratedColumn<String> subtitleJson = GeneratedColumn<String>(
      'subtitle_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceTypeMeta =
      const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
      'source_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ai'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bvid, cid, subtitleJson, sourceType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtitles';
  @override
  VerificationContext validateIntegrity(Insertable<Subtitle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bvid')) {
      context.handle(
          _bvidMeta, bvid.isAcceptableOrUnknown(data['bvid']!, _bvidMeta));
    } else if (isInserting) {
      context.missing(_bvidMeta);
    }
    if (data.containsKey('cid')) {
      context.handle(
          _cidMeta, cid.isAcceptableOrUnknown(data['cid']!, _cidMeta));
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (data.containsKey('subtitle_json')) {
      context.handle(
          _subtitleJsonMeta,
          subtitleJson.isAcceptableOrUnknown(
              data['subtitle_json']!, _subtitleJsonMeta));
    } else if (isInserting) {
      context.missing(_subtitleJsonMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
          _sourceTypeMeta,
          sourceType.isAcceptableOrUnknown(
              data['source_type']!, _sourceTypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {bvid, cid},
      ];
  @override
  Subtitle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subtitle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bvid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bvid'])!,
      cid: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cid'])!,
      subtitleJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtitle_json'])!,
      sourceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SubtitlesTable createAlias(String alias) {
    return $SubtitlesTable(attachedDatabase, alias);
  }
}

class Subtitle extends DataClass implements Insertable<Subtitle> {
  /// Auto-incrementing primary key.
  final int id;

  /// Bilibili BV number.
  final String bvid;

  /// Bilibili CID (page identifier).
  final int cid;

  /// Serialized subtitle data (JSON string of [SubtitleData]).
  final String subtitleJson;

  /// Source type: 'ai' or 'cc'.
  final String sourceType;

  /// Creation timestamp (Unix milliseconds).
  final int createdAt;
  const Subtitle(
      {required this.id,
      required this.bvid,
      required this.cid,
      required this.subtitleJson,
      required this.sourceType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bvid'] = Variable<String>(bvid);
    map['cid'] = Variable<int>(cid);
    map['subtitle_json'] = Variable<String>(subtitleJson);
    map['source_type'] = Variable<String>(sourceType);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SubtitlesCompanion toCompanion(bool nullToAbsent) {
    return SubtitlesCompanion(
      id: Value(id),
      bvid: Value(bvid),
      cid: Value(cid),
      subtitleJson: Value(subtitleJson),
      sourceType: Value(sourceType),
      createdAt: Value(createdAt),
    );
  }

  factory Subtitle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subtitle(
      id: serializer.fromJson<int>(json['id']),
      bvid: serializer.fromJson<String>(json['bvid']),
      cid: serializer.fromJson<int>(json['cid']),
      subtitleJson: serializer.fromJson<String>(json['subtitleJson']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bvid': serializer.toJson<String>(bvid),
      'cid': serializer.toJson<int>(cid),
      'subtitleJson': serializer.toJson<String>(subtitleJson),
      'sourceType': serializer.toJson<String>(sourceType),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Subtitle copyWith(
          {int? id,
          String? bvid,
          int? cid,
          String? subtitleJson,
          String? sourceType,
          int? createdAt}) =>
      Subtitle(
        id: id ?? this.id,
        bvid: bvid ?? this.bvid,
        cid: cid ?? this.cid,
        subtitleJson: subtitleJson ?? this.subtitleJson,
        sourceType: sourceType ?? this.sourceType,
        createdAt: createdAt ?? this.createdAt,
      );
  Subtitle copyWithCompanion(SubtitlesCompanion data) {
    return Subtitle(
      id: data.id.present ? data.id.value : this.id,
      bvid: data.bvid.present ? data.bvid.value : this.bvid,
      cid: data.cid.present ? data.cid.value : this.cid,
      subtitleJson: data.subtitleJson.present
          ? data.subtitleJson.value
          : this.subtitleJson,
      sourceType:
          data.sourceType.present ? data.sourceType.value : this.sourceType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subtitle(')
          ..write('id: $id, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('subtitleJson: $subtitleJson, ')
          ..write('sourceType: $sourceType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bvid, cid, subtitleJson, sourceType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subtitle &&
          other.id == this.id &&
          other.bvid == this.bvid &&
          other.cid == this.cid &&
          other.subtitleJson == this.subtitleJson &&
          other.sourceType == this.sourceType &&
          other.createdAt == this.createdAt);
}

class SubtitlesCompanion extends UpdateCompanion<Subtitle> {
  final Value<int> id;
  final Value<String> bvid;
  final Value<int> cid;
  final Value<String> subtitleJson;
  final Value<String> sourceType;
  final Value<int> createdAt;
  const SubtitlesCompanion({
    this.id = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.subtitleJson = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SubtitlesCompanion.insert({
    this.id = const Value.absent(),
    required String bvid,
    required int cid,
    required String subtitleJson,
    this.sourceType = const Value.absent(),
    required int createdAt,
  })  : bvid = Value(bvid),
        cid = Value(cid),
        subtitleJson = Value(subtitleJson),
        createdAt = Value(createdAt);
  static Insertable<Subtitle> custom({
    Expression<int>? id,
    Expression<String>? bvid,
    Expression<int>? cid,
    Expression<String>? subtitleJson,
    Expression<String>? sourceType,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bvid != null) 'bvid': bvid,
      if (cid != null) 'cid': cid,
      if (subtitleJson != null) 'subtitle_json': subtitleJson,
      if (sourceType != null) 'source_type': sourceType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SubtitlesCompanion copyWith(
      {Value<int>? id,
      Value<String>? bvid,
      Value<int>? cid,
      Value<String>? subtitleJson,
      Value<String>? sourceType,
      Value<int>? createdAt}) {
    return SubtitlesCompanion(
      id: id ?? this.id,
      bvid: bvid ?? this.bvid,
      cid: cid ?? this.cid,
      subtitleJson: subtitleJson ?? this.subtitleJson,
      sourceType: sourceType ?? this.sourceType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bvid.present) {
      map['bvid'] = Variable<String>(bvid.value);
    }
    if (cid.present) {
      map['cid'] = Variable<int>(cid.value);
    }
    if (subtitleJson.present) {
      map['subtitle_json'] = Variable<String>(subtitleJson.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtitlesCompanion(')
          ..write('id: $id, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('subtitleJson: $subtitleJson, ')
          ..write('sourceType: $sourceType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $PlaylistSongsTable playlistSongs = $PlaylistSongsTable(this);
  late final $DownloadTasksTable downloadTasks = $DownloadTasksTable(this);
  late final $UserSessionsTable userSessions = $UserSessionsTable(this);
  late final $SubtitlesTable subtitles = $SubtitlesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [songs, playlists, playlistSongs, downloadTasks, userSessions, subtitles];
}

typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  required String bvid,
  required int cid,
  required String originTitle,
  required String originArtist,
  Value<String?> customTitle,
  Value<String?> customArtist,
  Value<String?> coverUrl,
  Value<int> duration,
  Value<int> audioQuality,
  Value<String?> localPath,
  Value<DateTime> createdAt,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  Value<String> bvid,
  Value<int> cid,
  Value<String> originTitle,
  Value<String> originArtist,
  Value<String?> customTitle,
  Value<String?> customArtist,
  Value<String?> coverUrl,
  Value<int> duration,
  Value<int> audioQuality,
  Value<String?> localPath,
  Value<DateTime> createdAt,
});

final class $$SongsTableReferences
    extends BaseReferences<_$AppDatabase, $SongsTable, Song> {
  $$SongsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistSongsTable, List<PlaylistSong>>
      _playlistSongsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playlistSongs,
              aliasName:
                  $_aliasNameGenerator(db.songs.id, db.playlistSongs.songId));

  $$PlaylistSongsTableProcessedTableManager get playlistSongsRefs {
    final manager = $$PlaylistSongsTableTableManager($_db, $_db.playlistSongs)
        .filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistSongsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$DownloadTasksTable, List<DownloadTask>>
      _downloadTasksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.downloadTasks,
              aliasName:
                  $_aliasNameGenerator(db.songs.id, db.downloadTasks.songId));

  $$DownloadTasksTableProcessedTableManager get downloadTasksRefs {
    final manager = $$DownloadTasksTableTableManager($_db, $_db.downloadTasks)
        .filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_downloadTasksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originTitle => $composableBuilder(
      column: $table.originTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originArtist => $composableBuilder(
      column: $table.originArtist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customArtist => $composableBuilder(
      column: $table.customArtist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get audioQuality => $composableBuilder(
      column: $table.audioQuality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> playlistSongsRefs(
      Expression<bool> Function($$PlaylistSongsTableFilterComposer f) f) {
    final $$PlaylistSongsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistSongs,
        getReferencedColumn: (t) => t.songId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistSongsTableFilterComposer(
              $db: $db,
              $table: $db.playlistSongs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> downloadTasksRefs(
      Expression<bool> Function($$DownloadTasksTableFilterComposer f) f) {
    final $$DownloadTasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.downloadTasks,
        getReferencedColumn: (t) => t.songId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadTasksTableFilterComposer(
              $db: $db,
              $table: $db.downloadTasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originTitle => $composableBuilder(
      column: $table.originTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originArtist => $composableBuilder(
      column: $table.originArtist,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customArtist => $composableBuilder(
      column: $table.customArtist,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get audioQuality => $composableBuilder(
      column: $table.audioQuality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bvid =>
      $composableBuilder(column: $table.bvid, builder: (column) => column);

  GeneratedColumn<int> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumn<String> get originTitle => $composableBuilder(
      column: $table.originTitle, builder: (column) => column);

  GeneratedColumn<String> get originArtist => $composableBuilder(
      column: $table.originArtist, builder: (column) => column);

  GeneratedColumn<String> get customTitle => $composableBuilder(
      column: $table.customTitle, builder: (column) => column);

  GeneratedColumn<String> get customArtist => $composableBuilder(
      column: $table.customArtist, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get audioQuality => $composableBuilder(
      column: $table.audioQuality, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playlistSongsRefs<T extends Object>(
      Expression<T> Function($$PlaylistSongsTableAnnotationComposer a) f) {
    final $$PlaylistSongsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistSongs,
        getReferencedColumn: (t) => t.songId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistSongsTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistSongs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> downloadTasksRefs<T extends Object>(
      Expression<T> Function($$DownloadTasksTableAnnotationComposer a) f) {
    final $$DownloadTasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.downloadTasks,
        getReferencedColumn: (t) => t.songId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DownloadTasksTableAnnotationComposer(
              $db: $db,
              $table: $db.downloadTasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, $$SongsTableReferences),
    Song,
    PrefetchHooks Function({bool playlistSongsRefs, bool downloadTasksRefs})> {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bvid = const Value.absent(),
            Value<int> cid = const Value.absent(),
            Value<String> originTitle = const Value.absent(),
            Value<String> originArtist = const Value.absent(),
            Value<String?> customTitle = const Value.absent(),
            Value<String?> customArtist = const Value.absent(),
            Value<String?> coverUrl = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<int> audioQuality = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            bvid: bvid,
            cid: cid,
            originTitle: originTitle,
            originArtist: originArtist,
            customTitle: customTitle,
            customArtist: customArtist,
            coverUrl: coverUrl,
            duration: duration,
            audioQuality: audioQuality,
            localPath: localPath,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bvid,
            required int cid,
            required String originTitle,
            required String originArtist,
            Value<String?> customTitle = const Value.absent(),
            Value<String?> customArtist = const Value.absent(),
            Value<String?> coverUrl = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<int> audioQuality = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SongsCompanion.insert(
            id: id,
            bvid: bvid,
            cid: cid,
            originTitle: originTitle,
            originArtist: originArtist,
            customTitle: customTitle,
            customArtist: customArtist,
            coverUrl: coverUrl,
            duration: duration,
            audioQuality: audioQuality,
            localPath: localPath,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SongsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {playlistSongsRefs = false, downloadTasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistSongsRefs) db.playlistSongs,
                if (downloadTasksRefs) db.downloadTasks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistSongsRefs)
                    await $_getPrefetchedData<Song, $SongsTable, PlaylistSong>(
                        currentTable: table,
                        referencedTable:
                            $$SongsTableReferences._playlistSongsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SongsTableReferences(db, table, p0)
                                .playlistSongsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.songId == item.id),
                        typedResults: items),
                  if (downloadTasksRefs)
                    await $_getPrefetchedData<Song, $SongsTable, DownloadTask>(
                        currentTable: table,
                        referencedTable:
                            $$SongsTableReferences._downloadTasksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SongsTableReferences(db, table, p0)
                                .downloadTasksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.songId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, $$SongsTableReferences),
    Song,
    PrefetchHooks Function({bool playlistSongsRefs, bool downloadTasksRefs})>;
typedef $$PlaylistsTableCreateCompanionBuilder = PlaylistsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> coverUrl,
  Value<int> sortOrder,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
});
typedef $$PlaylistsTableUpdateCompanionBuilder = PlaylistsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> coverUrl,
  Value<int> sortOrder,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
});

final class $$PlaylistsTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist> {
  $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlaylistSongsTable, List<PlaylistSong>>
      _playlistSongsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.playlistSongs,
              aliasName: $_aliasNameGenerator(
                  db.playlists.id, db.playlistSongs.playlistId));

  $$PlaylistSongsTableProcessedTableManager get playlistSongsRefs {
    final manager = $$PlaylistSongsTableTableManager($_db, $_db.playlistSongs)
        .filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playlistSongsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> playlistSongsRefs(
      Expression<bool> Function($$PlaylistSongsTableFilterComposer f) f) {
    final $$PlaylistSongsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistSongs,
        getReferencedColumn: (t) => t.playlistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistSongsTableFilterComposer(
              $db: $db,
              $table: $db.playlistSongs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverUrl => $composableBuilder(
      column: $table.coverUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playlistSongsRefs<T extends Object>(
      Expression<T> Function($$PlaylistSongsTableAnnotationComposer a) f) {
    final $$PlaylistSongsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.playlistSongs,
        getReferencedColumn: (t) => t.playlistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistSongsTableAnnotationComposer(
              $db: $db,
              $table: $db.playlistSongs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlaylistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistsTable,
    Playlist,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (Playlist, $$PlaylistsTableReferences),
    Playlist,
    PrefetchHooks Function({bool playlistSongsRefs})> {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> coverUrl = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PlaylistsCompanion(
            id: id,
            name: name,
            coverUrl: coverUrl,
            sortOrder: sortOrder,
            isFavorite: isFavorite,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> coverUrl = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PlaylistsCompanion.insert(
            id: id,
            name: name,
            coverUrl: coverUrl,
            sortOrder: sortOrder,
            isFavorite: isFavorite,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaylistsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistSongsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (playlistSongsRefs) db.playlistSongs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playlistSongsRefs)
                    await $_getPrefetchedData<Playlist, $PlaylistsTable,
                            PlaylistSong>(
                        currentTable: table,
                        referencedTable: $$PlaylistsTableReferences
                            ._playlistSongsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlaylistsTableReferences(db, table, p0)
                                .playlistSongsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.playlistId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlaylistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistsTable,
    Playlist,
    $$PlaylistsTableFilterComposer,
    $$PlaylistsTableOrderingComposer,
    $$PlaylistsTableAnnotationComposer,
    $$PlaylistsTableCreateCompanionBuilder,
    $$PlaylistsTableUpdateCompanionBuilder,
    (Playlist, $$PlaylistsTableReferences),
    Playlist,
    PrefetchHooks Function({bool playlistSongsRefs})>;
typedef $$PlaylistSongsTableCreateCompanionBuilder = PlaylistSongsCompanion
    Function({
  required int playlistId,
  required int songId,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$PlaylistSongsTableUpdateCompanionBuilder = PlaylistSongsCompanion
    Function({
  Value<int> playlistId,
  Value<int> songId,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$PlaylistSongsTableReferences
    extends BaseReferences<_$AppDatabase, $PlaylistSongsTable, PlaylistSong> {
  $$PlaylistSongsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PlaylistsTable _playlistIdTable(_$AppDatabase db) =>
      db.playlists.createAlias(
          $_aliasNameGenerator(db.playlistSongs.playlistId, db.playlists.id));

  $$PlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$PlaylistsTableTableManager($_db, $_db.playlists)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs
      .createAlias($_aliasNameGenerator(db.playlistSongs.songId, db.songs.id));

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager($_db, $_db.songs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlaylistSongsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistSongsTable> {
  $$PlaylistSongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  $$PlaylistsTableFilterComposer get playlistId {
    final $$PlaylistsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistsTableFilterComposer(
              $db: $db,
              $table: $db.playlists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.songId,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableFilterComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistSongsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistSongsTable> {
  $$PlaylistSongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  $$PlaylistsTableOrderingComposer get playlistId {
    final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistsTableOrderingComposer(
              $db: $db,
              $table: $db.playlists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.songId,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableOrderingComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistSongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistSongsTable> {
  $$PlaylistSongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$PlaylistsTableAnnotationComposer get playlistId {
    final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.playlistId,
        referencedTable: $db.playlists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlaylistsTableAnnotationComposer(
              $db: $db,
              $table: $db.playlists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.songId,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableAnnotationComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlaylistSongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlaylistSongsTable,
    PlaylistSong,
    $$PlaylistSongsTableFilterComposer,
    $$PlaylistSongsTableOrderingComposer,
    $$PlaylistSongsTableAnnotationComposer,
    $$PlaylistSongsTableCreateCompanionBuilder,
    $$PlaylistSongsTableUpdateCompanionBuilder,
    (PlaylistSong, $$PlaylistSongsTableReferences),
    PlaylistSong,
    PrefetchHooks Function({bool playlistId, bool songId})> {
  $$PlaylistSongsTableTableManager(_$AppDatabase db, $PlaylistSongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistSongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistSongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistSongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> playlistId = const Value.absent(),
            Value<int> songId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistSongsCompanion(
            playlistId: playlistId,
            songId: songId,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int playlistId,
            required int songId,
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlaylistSongsCompanion.insert(
            playlistId: playlistId,
            songId: songId,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlaylistSongsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({playlistId = false, songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (playlistId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.playlistId,
                    referencedTable:
                        $$PlaylistSongsTableReferences._playlistIdTable(db),
                    referencedColumn:
                        $$PlaylistSongsTableReferences._playlistIdTable(db).id,
                  ) as T;
                }
                if (songId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.songId,
                    referencedTable:
                        $$PlaylistSongsTableReferences._songIdTable(db),
                    referencedColumn:
                        $$PlaylistSongsTableReferences._songIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlaylistSongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlaylistSongsTable,
    PlaylistSong,
    $$PlaylistSongsTableFilterComposer,
    $$PlaylistSongsTableOrderingComposer,
    $$PlaylistSongsTableAnnotationComposer,
    $$PlaylistSongsTableCreateCompanionBuilder,
    $$PlaylistSongsTableUpdateCompanionBuilder,
    (PlaylistSong, $$PlaylistSongsTableReferences),
    PlaylistSong,
    PrefetchHooks Function({bool playlistId, bool songId})>;
typedef $$DownloadTasksTableCreateCompanionBuilder = DownloadTasksCompanion
    Function({
  Value<int> id,
  required int songId,
  Value<int> status,
  Value<int> progress,
  Value<String?> filePath,
  Value<int> quality,
  Value<DateTime> createdAt,
});
typedef $$DownloadTasksTableUpdateCompanionBuilder = DownloadTasksCompanion
    Function({
  Value<int> id,
  Value<int> songId,
  Value<int> status,
  Value<int> progress,
  Value<String?> filePath,
  Value<int> quality,
  Value<DateTime> createdAt,
});

final class $$DownloadTasksTableReferences
    extends BaseReferences<_$AppDatabase, $DownloadTasksTable, DownloadTask> {
  $$DownloadTasksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs
      .createAlias($_aliasNameGenerator(db.downloadTasks.songId, db.songs.id));

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager($_db, $_db.songs)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DownloadTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quality => $composableBuilder(
      column: $table.quality, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.songId,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableFilterComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DownloadTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quality => $composableBuilder(
      column: $table.quality, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.songId,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableOrderingComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DownloadTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadTasksTable> {
  $$DownloadTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.songId,
        referencedTable: $db.songs,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SongsTableAnnotationComposer(
              $db: $db,
              $table: $db.songs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DownloadTasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadTasksTable,
    DownloadTask,
    $$DownloadTasksTableFilterComposer,
    $$DownloadTasksTableOrderingComposer,
    $$DownloadTasksTableAnnotationComposer,
    $$DownloadTasksTableCreateCompanionBuilder,
    $$DownloadTasksTableUpdateCompanionBuilder,
    (DownloadTask, $$DownloadTasksTableReferences),
    DownloadTask,
    PrefetchHooks Function({bool songId})> {
  $$DownloadTasksTableTableManager(_$AppDatabase db, $DownloadTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> songId = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<int> quality = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DownloadTasksCompanion(
            id: id,
            songId: songId,
            status: status,
            progress: progress,
            filePath: filePath,
            quality: quality,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int songId,
            Value<int> status = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<String?> filePath = const Value.absent(),
            Value<int> quality = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DownloadTasksCompanion.insert(
            id: id,
            songId: songId,
            status: status,
            progress: progress,
            filePath: filePath,
            quality: quality,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DownloadTasksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (songId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.songId,
                    referencedTable:
                        $$DownloadTasksTableReferences._songIdTable(db),
                    referencedColumn:
                        $$DownloadTasksTableReferences._songIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DownloadTasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadTasksTable,
    DownloadTask,
    $$DownloadTasksTableFilterComposer,
    $$DownloadTasksTableOrderingComposer,
    $$DownloadTasksTableAnnotationComposer,
    $$DownloadTasksTableCreateCompanionBuilder,
    $$DownloadTasksTableUpdateCompanionBuilder,
    (DownloadTask, $$DownloadTasksTableReferences),
    DownloadTask,
    PrefetchHooks Function({bool songId})>;
typedef $$UserSessionsTableCreateCompanionBuilder = UserSessionsCompanion
    Function({
  Value<int> id,
  required String sessdata,
  required String biliJct,
  required String dedeUserId,
  Value<DateTime?> expires,
  Value<String?> avatarUrl,
  Value<String?> nickname,
});
typedef $$UserSessionsTableUpdateCompanionBuilder = UserSessionsCompanion
    Function({
  Value<int> id,
  Value<String> sessdata,
  Value<String> biliJct,
  Value<String> dedeUserId,
  Value<DateTime?> expires,
  Value<String?> avatarUrl,
  Value<String?> nickname,
});

class $$UserSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSessionsTable> {
  $$UserSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessdata => $composableBuilder(
      column: $table.sessdata, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get biliJct => $composableBuilder(
      column: $table.biliJct, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dedeUserId => $composableBuilder(
      column: $table.dedeUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expires => $composableBuilder(
      column: $table.expires, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));
}

class $$UserSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSessionsTable> {
  $$UserSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessdata => $composableBuilder(
      column: $table.sessdata, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get biliJct => $composableBuilder(
      column: $table.biliJct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dedeUserId => $composableBuilder(
      column: $table.dedeUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expires => $composableBuilder(
      column: $table.expires, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));
}

class $$UserSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSessionsTable> {
  $$UserSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessdata =>
      $composableBuilder(column: $table.sessdata, builder: (column) => column);

  GeneratedColumn<String> get biliJct =>
      $composableBuilder(column: $table.biliJct, builder: (column) => column);

  GeneratedColumn<String> get dedeUserId => $composableBuilder(
      column: $table.dedeUserId, builder: (column) => column);

  GeneratedColumn<DateTime> get expires =>
      $composableBuilder(column: $table.expires, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);
}

class $$UserSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSessionsTable,
    UserSession,
    $$UserSessionsTableFilterComposer,
    $$UserSessionsTableOrderingComposer,
    $$UserSessionsTableAnnotationComposer,
    $$UserSessionsTableCreateCompanionBuilder,
    $$UserSessionsTableUpdateCompanionBuilder,
    (
      UserSession,
      BaseReferences<_$AppDatabase, $UserSessionsTable, UserSession>
    ),
    UserSession,
    PrefetchHooks Function()> {
  $$UserSessionsTableTableManager(_$AppDatabase db, $UserSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sessdata = const Value.absent(),
            Value<String> biliJct = const Value.absent(),
            Value<String> dedeUserId = const Value.absent(),
            Value<DateTime?> expires = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> nickname = const Value.absent(),
          }) =>
              UserSessionsCompanion(
            id: id,
            sessdata: sessdata,
            biliJct: biliJct,
            dedeUserId: dedeUserId,
            expires: expires,
            avatarUrl: avatarUrl,
            nickname: nickname,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sessdata,
            required String biliJct,
            required String dedeUserId,
            Value<DateTime?> expires = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String?> nickname = const Value.absent(),
          }) =>
              UserSessionsCompanion.insert(
            id: id,
            sessdata: sessdata,
            biliJct: biliJct,
            dedeUserId: dedeUserId,
            expires: expires,
            avatarUrl: avatarUrl,
            nickname: nickname,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSessionsTable,
    UserSession,
    $$UserSessionsTableFilterComposer,
    $$UserSessionsTableOrderingComposer,
    $$UserSessionsTableAnnotationComposer,
    $$UserSessionsTableCreateCompanionBuilder,
    $$UserSessionsTableUpdateCompanionBuilder,
    (
      UserSession,
      BaseReferences<_$AppDatabase, $UserSessionsTable, UserSession>
    ),
    UserSession,
    PrefetchHooks Function()>;
typedef $$SubtitlesTableCreateCompanionBuilder = SubtitlesCompanion Function({
  Value<int> id,
  required String bvid,
  required int cid,
  required String subtitleJson,
  Value<String> sourceType,
  required int createdAt,
});
typedef $$SubtitlesTableUpdateCompanionBuilder = SubtitlesCompanion Function({
  Value<int> id,
  Value<String> bvid,
  Value<int> cid,
  Value<String> subtitleJson,
  Value<String> sourceType,
  Value<int> createdAt,
});

class $$SubtitlesTableFilterComposer
    extends Composer<_$AppDatabase, $SubtitlesTable> {
  $$SubtitlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subtitleJson => $composableBuilder(
      column: $table.subtitleJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SubtitlesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtitlesTable> {
  $$SubtitlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subtitleJson => $composableBuilder(
      column: $table.subtitleJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SubtitlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtitlesTable> {
  $$SubtitlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bvid =>
      $composableBuilder(column: $table.bvid, builder: (column) => column);

  GeneratedColumn<int> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumn<String> get subtitleJson => $composableBuilder(
      column: $table.subtitleJson, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
      column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SubtitlesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubtitlesTable,
    Subtitle,
    $$SubtitlesTableFilterComposer,
    $$SubtitlesTableOrderingComposer,
    $$SubtitlesTableAnnotationComposer,
    $$SubtitlesTableCreateCompanionBuilder,
    $$SubtitlesTableUpdateCompanionBuilder,
    (Subtitle, BaseReferences<_$AppDatabase, $SubtitlesTable, Subtitle>),
    Subtitle,
    PrefetchHooks Function()> {
  $$SubtitlesTableTableManager(_$AppDatabase db, $SubtitlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtitlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtitlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtitlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bvid = const Value.absent(),
            Value<int> cid = const Value.absent(),
            Value<String> subtitleJson = const Value.absent(),
            Value<String> sourceType = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              SubtitlesCompanion(
            id: id,
            bvid: bvid,
            cid: cid,
            subtitleJson: subtitleJson,
            sourceType: sourceType,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bvid,
            required int cid,
            required String subtitleJson,
            Value<String> sourceType = const Value.absent(),
            required int createdAt,
          }) =>
              SubtitlesCompanion.insert(
            id: id,
            bvid: bvid,
            cid: cid,
            subtitleJson: subtitleJson,
            sourceType: sourceType,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubtitlesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubtitlesTable,
    Subtitle,
    $$SubtitlesTableFilterComposer,
    $$SubtitlesTableOrderingComposer,
    $$SubtitlesTableAnnotationComposer,
    $$SubtitlesTableCreateCompanionBuilder,
    $$SubtitlesTableUpdateCompanionBuilder,
    (Subtitle, BaseReferences<_$AppDatabase, $SubtitlesTable, Subtitle>),
    Subtitle,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$PlaylistSongsTableTableManager get playlistSongs =>
      $$PlaylistSongsTableTableManager(_db, _db.playlistSongs);
  $$DownloadTasksTableTableManager get downloadTasks =>
      $$DownloadTasksTableTableManager(_db, _db.downloadTasks);
  $$UserSessionsTableTableManager get userSessions =>
      $$UserSessionsTableTableManager(_db, _db.userSessions);
  $$SubtitlesTableTableManager get subtitles =>
      $$SubtitlesTableTableManager(_db, _db.subtitles);
}
