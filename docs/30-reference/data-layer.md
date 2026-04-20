# 数据层 (Drift / Freezed / API)

## Drift 数据库

### 数据库配置

数据库定义在 `lib/core/database/app_database.dart`，使用 `@DriftDatabase` 注解注册所有表：

```dart
@DriftDatabase(tables: [Songs, Playlists, PlaylistSongs, DownloadTasks, UserSessions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
```

- 数据库文件位于 `documents/busic/busic.db`
- 使用 `LazyDatabase` + `NativeDatabase.createInBackground` 异步初始化
- `schemaVersion` 起始为 1，新增迁移时递增

### 现有表结构

| 表 | 文件 | 关键设计 |
|---|---|---|
| `Songs` | `tables/songs.dart` | **元数据覆盖模式**：`originTitle/Artist` 存原始值，`customTitle/Artist` 可覆盖 |
| `Playlists` | `tables/playlists.dart` | 歌单基本信息，含 `sortOrder` 排序 |
| `PlaylistSongs` | `tables/playlist_songs.dart` | 多对多联结表，`(playlistId, songId)` 复合主键 |
| `DownloadTasks` | `tables/download_tasks.dart` | 下载状态：0=pending / 1=downloading / 2=completed / 3=failed |
| `UserSessions` | `tables/user_sessions.dart` | B站登录凭据（sessdata, biliJct, dedeUserId 等） |

### 新增表规范

```dart
// lib/core/database/tables/new_table.dart
import 'package:drift/drift.dart';

class NewItems extends Table {
  // 自增主键
  IntColumn get id => integer().autoIncrement()();

  // 必填文本
  TextColumn get name => text()();

  // 可空字段
  TextColumn get description => text().nullable()();

  // 外键引用
  IntColumn get playlistId => integer().references(Playlists, #id)();

  // 带默认值
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // 整数枚举
  IntColumn get status => integer().withDefault(const Constant(0))();
}
```

新增表后需要：
1. 在 `AppDatabase` 的 `@DriftDatabase(tables: [...])` 中注册
2. 递增 `schemaVersion` 并编写迁移代码
3. 运行 `dart run build_runner build --delete-conflicting-outputs`

## Freezed 模型

### 数据类 + JSON 序列化（主要模式）

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

@freezed
class AudioTrack with _$AudioTrack {
  const factory AudioTrack({
    required int songId,
    required String bvid,
    required int cid,
    required String title,
    required String artist,
    String? coverUrl,
    int? duration,
    String? streamUrl,
    String? localPath,
    @Default(0) int quality,
  }) = _AudioTrack;

  factory AudioTrack.fromJson(Map<String, dynamic> json) =>
      _$AudioTrackFromJson(json);
}
```

### 联合类型（状态枚举）

```dart
@freezed
class ParseState with _$ParseState {
  const factory ParseState.idle() = _Idle;
  const factory ParseState.parsing() = _Parsing;
  const factory ParseState.success(BvidInfo info) = _Success;
  const factory ParseState.selectingPages(BvidInfo info, List<bool> selected) = _SelectingPages;
  const factory ParseState.error(String message) = _Error;
}
```

UI 中使用 `when()` / `maybeWhen()` 进行模式匹配：

```dart
state.when(
  idle: () => const Text('等待输入'),
  parsing: () => const CircularProgressIndicator(),
  success: (info) => InfoCard(info),
  selectingPages: (info, selected) => PageSelector(info, selected),
  error: (msg) => Text(msg),
);
```

### 带计算属性的模型

```dart
@freezed
class SongItem with _$SongItem {
  // 需要 const 私有构造函数才能添加自定义 getter
  const SongItem._();

  const factory SongItem({ ... }) = _SongItem;

  // 计算属性
  String get displayTitle => customTitle ?? originTitle;
  String get displayArtist => customArtist ?? originArtist;
  bool get isCached => localPath != null;
}
```

### 仅 Freezed 无 JSON（运行时状态）

```dart
@freezed
class PlayerState with _$PlayerState {
  const factory PlayerState({
    AudioTrack? currentTrack,
    @Default([]) List<AudioTrack> queue,
    @Default(Duration.zero) Duration position,
    // ... 不生成 fromJson/toJson
  }) = _PlayerState;
}
```

## Repository 模式

### 接口定义

```dart
// lib/features/xxx/data/xxx_repository.dart
abstract class XxxRepository {
  Future<List<Item>> getAll();
  Future<Item?> getById(int id);
  Future<void> create(Item item);
  Future<void> update(Item item);
  Future<void> delete(int id);
}
```

### 实现类

```dart
// lib/features/xxx/data/xxx_repository_impl.dart
class XxxRepositoryImpl implements XxxRepository {
  final AppDatabase _db;

  XxxRepositoryImpl(this._db);

  @override
  Future<List<Item>> getAll() async {
    final rows = await _db.select(_db.items).get();
    return rows.map(_mapToModel).toList();
  }

  // 私有映射方法：DB Row → Domain Model
  Item _mapToModel(ItemRow row) {
    return Item(
      id: row.id,
      name: row.name,
    );
  }
}
```

### 关键设计原则

1. **Repository 接口**定义在 `data/` 目录（非 `domain/`），与实现类在同一层
2. **Domain 模型**和 **DB 表**是分离的，Repository 负责二者之间的映射转换
3. Repository **不是 Riverpod Provider**，由 Notifier 在 `build()` 中手动创建实例
4. 需要 keep-alive 的 Repository（如 `DownloadRepository`）用手动 `Provider` 管理

## API 层

### BiliDio（HTTP 客户端）

`BiliDio` 是单例模式，全局共享一个 Dio 实例：

```dart
final response = await BiliDio.instance.get(
  'https://api.bilibili.com/x/web-interface/view',
  queryParameters: {'bvid': bvid},
);
```

关键拦截器：

| 拦截器 | 功能 |
|---|---|
| `_RawCookieInterceptor` | 注入登录 Cookie（手动拼接，绕过 Dart Cookie 解析限制） |
| `_BiliRefererInterceptor` | 自动添加 `Referer: https://www.bilibili.com` |

### WBI 签名

需要 WBI 签名的 API 调用（如 `playurl`、`search`），使用 `WbiSign` 工具类：

```dart
// 1. 获取 WBI 密钥（从 nav API 响应中提取，缓存 30 分钟）
final keys = WbiSign.extractKeys(imgUrl, subUrl);

// 2. 对请求参数签名
final signedParams = WbiSign.encodeWbi(params, keys.imgKey, keys.subKey);
```

### Cookie 管理

- Cookie 存储在 JSON 文件（`documents/busic/cookies.json`）
- 登录成功后通过 `BiliDio.setSessionCookies()` 设置
- 退出登录通过 `BiliDio.clearCookies()` 清除
- **注意**：B站 SESSDATA 包含逗号，不使用 `dart:io` 的 `Cookie` 类解析

### 音频流获取

音频流通过 `/x/player/wbi/playurl` 接口获取，使用 `fnval=4048` 请求 DASH 格式：

| 音质 ID | 描述 | 需登录 |
|---|---|---|
| 30216 | 64kbps | 否 |
| 30232 | 132kbps | 否 |
| 30280 | 192kbps | 是 |
| 30250 | Dolby Atmos | 是（大会员） |
| 30251 | Hi-Res FLAC | 是（大会员） |
