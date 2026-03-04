# 歌单分享与数据同步 — 功能规划

## 概述

本文档规划 BuSic 的 **歌单分享** 和 **数据同步** 两大功能，各自支持 **离线模式** 和 **在线模式**。

| 功能 | 离线模式 | 在线模式 |
|------|---------|---------|
| **歌单分享** | 导出歌单 JSON → 复制到剪贴板 / 从剪贴板粘贴导入 | 上传歌单 JSON 到服务器 → 生成分享链接 → 接收方通过链接下载导入 |
| **数据同步** | 导出/导入完整数据库备份文件（JSON） | 预留接口，后续对接云存储服务 |

---

## 一、歌单分享

### 1.1 分享数据格式

歌单分享的核心原则：**最小化体积，让剪贴板分享可用**。

歌曲的 `bvid + cid` 已是全局唯一标识，`originTitle`、`originArtist`、`coverUrl`、`duration` 等元数据可在导入时通过 B 站 API 重新拉取，无需随分享数据传输。仅当用户修改过自定义标题/作者时才携带，且使用 `@JsonKey` 缩短 JSON 键名进一步压缩体积。

**体积对比**：

| 方案 | 单曲 JSON | 100 首 Base64 |
|------|----------|--------------|
| 全字段（8 字段/曲） | ~250 字节 | ~33 KB |
| **精简（2 必填 + 2 可选/曲）** | **~50 字节** | **~7 KB** |

```dart
/// 歌单分享数据包（精简版，优化剪贴板体积）
@freezed
class SharedPlaylist with _$SharedPlaylist {
  const factory SharedPlaylist({
    /// 格式版本号，用于向前兼容
    @JsonKey(name: 'v') @Default(1) int version,

    /// 歌单名称
    @JsonKey(name: 'n') required String name,

    /// 歌曲列表
    @JsonKey(name: 's') required List<SharedSong> songs,
  }) = _SharedPlaylist;

  factory SharedPlaylist.fromJson(Map<String, dynamic> json) =>
      _$SharedPlaylistFromJson(json);
}

/// 分享歌曲（仅含重建所需的最小字段）
///
/// 导入时根据 bvid+cid 调用 B 站 API 拉取元数据（标题/作者/封面/时长）。
/// 仅当用户修改过自定义标题/作者时才携带 ct/ca 字段。
@freezed
class SharedSong with _$SharedSong {
  const factory SharedSong({
    /// Bilibili BV 号（全局唯一标识之一）
    @JsonKey(name: 'b') required String bvid,

    /// Bilibili CID（全局唯一标识之二）
    @JsonKey(name: 'c') required int cid,

    /// 用户自定义标题（仅在用户修改过时包含，否则省略）
    @JsonKey(name: 'ct', includeIfNull: false) String? customTitle,

    /// 用户自定义作者（仅在用户修改过时包含，否则省略）
    @JsonKey(name: 'ca', includeIfNull: false) String? customArtist,
  }) = _SharedSong;

  factory SharedSong.fromJson(Map<String, dynamic> json) =>
      _$SharedSongFromJson(json);
}
```

**示例输出**（3 首歌曲，无自定义标题）：
```json
{"v":1,"n":"我的歌单","s":[{"b":"BV1xx411c7mD","c":12345},{"b":"BV1yy411c8nE","c":67890},{"b":"BV1zz411c9oF","c":11111}]}
```
Base64 后约 ~140 字节，完全适合剪贴板传递。

**设计要点**：
- `bvid + cid` 是歌曲全局唯一标识，导入时通过 `upsertSong()` 去重
- **元数据不随分享传输**：导入时通过 B 站 `/x/web-interface/view` API 批量拉取
- `@JsonKey(includeIfNull: false)`：`customTitle`/`customArtist` 为 null 时不序列化，节省空间
- JSON 键名缩短（`v`/`n`/`s`/`b`/`c`/`ct`/`ca`），显著减小体积
- `version` 字段预留格式迁移能力
- 歌曲排序由数组顺序隐含，无需 `sortOrder` 字段

### 1.2 离线分享（剪贴板）

#### 导出流程

```
用户在歌单详情页点击「分享」
  → 弹出分享方式选择（离线/在线）
  → 选择「复制到剪贴板」
  → Repository 读取歌单 + 歌曲数据
  → 转换为 SharedPlaylist → 序列化为 JSON 字符串
  → 以 Base64 编码（减少剪贴板传输问题），添加固定前缀标识 `busic://playlist/`
  → 复制到系统剪贴板
  → 提示「已复制到剪贴板」
```

**导出编码格式**：
```
busic://playlist/<base64-encoded-json>
```

使用 `busic://playlist/` 前缀使得用户可以一眼看出这是 BuSic 分享数据，也方便导入时校验。

#### 导入流程

```
用户在歌单列表页点击「导入」
  → 弹出导入方式选择（从剪贴板 / 从链接 / 从文件）
  → 选择「从剪贴板粘贴」
  → 读取剪贴板内容
  → 校验 `busic://playlist/` 前缀
  → Base64 解码 → JSON 反序列化为 SharedPlaylist
  → 版本兼容性检查
  → 显示预览（歌单名、歌曲数量；此时仅显示 bvid 列表）
  → 用户确认导入（可修改歌单名避免重名）
  → 创建新歌单
  → 对每首歌执行：
    ├── 本地 Songs 表中已有 (bvid+cid) → 直接复用，跳过 API
    └── 本地不存在 → 调用 B 站 API 拉取元数据 → upsertSong
  → 批量关联到歌单
  → 刷新歌单列表
  → 显示导入结果（成功 N 首，跳过 M 首，失败 K 首）
```

**元数据拉取策略**：
- 导入时需联网通过 `/x/web-interface/view?bvid=xxx` 获取标题/作者/封面/时长
- 如果本地 Songs 表已有该 `bvid+cid`，直接复用本地记录，**不重复请求**
- 批量导入时并发控制（最多 3 个并发），避免触发 B 站频率限制
- 单首拉取失败时不阻塞整体导入，记录告警，后续用户可手动重试

#### 错误处理

| 场景 | 处理方式 |
|------|---------|
| 剪贴板为空 | 提示「剪贴板中没有内容」 |
| 前缀不匹配 | 提示「剪贴板内容不是 BuSic 歌单数据」 |
| Base64 解码失败 | 提示「数据格式错误，无法解析」 |
| JSON 反序列化失败 | 提示「歌单数据损坏或版本不兼容」 |
| 版本号过高 | 提示「请升级 BuSic 后再导入」 |
| 歌曲列表为空 | 提示「歌单中没有歌曲」 |

### 1.3 在线分享（上传/链接）

#### 服务端方案

**推荐使用轻量级免费服务**（无需自建服务器）：

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| **jsonbin.io / JSONBin** | 免费 API，直接存 JSON，支持读取 | 有速率限制，依赖第三方 | ⭐⭐⭐ |
| **GitHub Gist** | 免费、稳定、无需额外服务 | 需要 GitHub Token | ⭐⭐ |
| **Pastebin 类服务** | 简单易用 | 数据格式不友好 | ⭐ |
| **自建后端** | 完全可控 | 需运维成本 | 后续考虑 |
| **Firebase/Supabase** | 成熟 BaaS，实时同步能力强 | 配置复杂，可能需翻墙 | 后续考虑 |

**短期推荐**：使用 jsonbin.io 或类似的免费 JSON 存储 API，零运维成本。

#### 上传流程

```
用户选择「在线分享」
  → 序列化 SharedPlaylist → JSON
  → 通过 Dio 上传到 JSON 存储服务
  → 获取返回的资源 ID
  → 生成分享链接：busic://share/<resource-id>
  → 显示链接 + 复制按钮 + 二维码（可选）
```

#### 下载导入流程

```
用户输入分享链接 / 从剪贴板粘贴链接
  → 解析 resource-id
  → 通过 Dio 下载 JSON 数据
  → 反序列化为 SharedPlaylist
  → 显示预览 → 确认导入
  → 创建歌单 + 批量导入歌曲
```

#### 在线分享 Repository 接口

```dart
/// 在线分享服务接口（可替换后端实现）
abstract class ShareRemoteRepository {
  /// 上传歌单数据，返回资源 ID
  Future<String> uploadPlaylist(SharedPlaylist playlist);

  /// 根据资源 ID 下载歌单数据
  Future<SharedPlaylist> downloadPlaylist(String resourceId);

  /// 删除已分享的歌单（可选）
  Future<void> deleteSharedPlaylist(String resourceId);
}
```

---

## 二、数据同步

### 2.1 同步数据格式

定义 **完整备份数据结构**，涵盖所有用户数据（不含登录凭据）：

```dart
/// 完整数据备份包
@freezed
class AppBackup with _$AppBackup {
  const factory AppBackup({
    /// 备份格式版本
    @Default(1) int version,

    /// App 版本号
    required String appVersion,

    /// 备份创建时间
    required DateTime createdAt,

    /// 所有歌单
    required List<BackupPlaylist> playlists,

    /// 所有歌曲（去重，全量）
    required List<SharedSong> songs,

    /// 歌单-歌曲关联关系
    required List<BackupPlaylistSong> playlistSongs,

    /// 用户偏好设置
    BackupPreferences? preferences,
  }) = _AppBackup;

  factory AppBackup.fromJson(Map<String, dynamic> json) =>
      _$AppBackupFromJson(json);
}

/// 备份用歌单数据
@freezed
class BackupPlaylist with _$BackupPlaylist {
  const factory BackupPlaylist({
    /// 原始 ID（用于关联关系映射）
    required int originalId,
    required String name,
    String? coverUrl,
    required int sortOrder,
    required DateTime createdAt,
  }) = _BackupPlaylist;

  factory BackupPlaylist.fromJson(Map<String, dynamic> json) =>
      _$BackupPlaylistFromJson(json);
}

/// 备份用歌单歌曲关联
@freezed
class BackupPlaylistSong with _$BackupPlaylistSong {
  const factory BackupPlaylistSong({
    /// 原始歌单 ID
    required int playlistId,

    /// 歌曲的 bvid（用于跨设备映射）
    required String bvid,

    /// 歌曲的 cid
    required int cid,

    /// 排序
    required int sortOrder,
  }) = _BackupPlaylistSong;

  factory BackupPlaylistSong.fromJson(Map<String, dynamic> json) =>
      _$BackupPlaylistSongFromJson(json);
}

/// 备份用用户偏好
@freezed
class BackupPreferences with _$BackupPreferences {
  const factory BackupPreferences({
    String? themeMode,
    String? locale,
    int? preferredQuality,
    String? cachePath,
  }) = _BackupPreferences;

  factory BackupPreferences.fromJson(Map<String, dynamic> json) =>
      _$BackupPreferencesFromJson(json);
}
```

**设计要点**：
- 歌单-歌曲关联使用 `bvid + cid`（而非本地 `id`），保证跨设备可映射
- 不包含 `UserSessions`（安全考虑，不导出登录凭据）
- 不包含 `DownloadTasks`（下载状态无需同步）
- 不包含 `localPath`（本地缓存路径跨设备无意义）

### 2.2 离线同步（文件导入/导出）

#### 导出流程

```
用户在「设置」页面点击「导出数据」
  → 读取所有歌单、歌曲、关联关系、用户设置
  → 组装 AppBackup 对象 → 序列化为 JSON
  → 弹出文件保存对话框（使用 file_picker）
  → 写入 .busic.json 文件
  → 提示「导出成功」
```

**文件命名规则**：`busic_backup_20240101_120000.json`

#### 导入流程

```
用户在「设置」页面点击「导入数据」
  → 弹出文件选择对话框（筛选 .json）
  → 读取文件内容 → JSON 反序列化为 AppBackup
  → 版本兼容性检查
  → 显示备份概览（歌单数、歌曲数、备份时间）
  → 用户选择导入策略：
    ├── 「合并」：保留现有数据，仅添加新内容（默认推荐）
    └── 「覆盖」：清空现有数据后导入（需二次确认）
  → 执行导入
  → 刷新所有数据
```

#### 合并策略详细逻辑

```
1. 歌曲合并
   ├── 按 bvid + cid 匹配
   ├── 已存在 → 跳过（保留本地版本，含 localPath 等）
   └── 不存在 → 插入新记录

2. 歌单合并
   ├── 按名称匹配
   ├── 同名歌单已存在 → 合并歌曲（去重）
   └── 不存在 → 创建新歌单

3. 关联关系
   └── 根据新的 ID 映射重建 playlistSong 关联

4. 用户偏好
   └── 保留本地设置（不覆盖）
```

#### 覆盖策略

```
1. 清空 PlaylistSongs 表
2. 清空 Playlists 表
3. 保留 Songs 表（避免丢失本地缓存）
4. 按备份数据重建歌单和关联关系
5. 新增不存在的歌曲记录
```

### 2.3 在线同步（预留接口）

在线同步暂不实现具体逻辑，仅定义接口以便后续对接：

```dart
/// 在线数据同步服务接口
///
/// 后续可对接 Firebase / Supabase / 自建服务
abstract class SyncRemoteRepository {
  /// 上传完整备份到云端
  Future<void> uploadBackup(AppBackup backup);

  /// 从云端下载最新备份
  Future<AppBackup?> downloadLatestBackup();

  /// 获取云端备份的元信息（不下载完整数据）
  Future<SyncMetadata?> getRemoteSyncMetadata();

  /// 增量同步：仅上传变更
  Future<void> pushChanges(List<SyncChange> changes);

  /// 增量同步：拉取远程变更
  Future<List<SyncChange>> pullChanges(DateTime since);
}

/// 同步元信息
@freezed
class SyncMetadata with _$SyncMetadata {
  const factory SyncMetadata({
    required DateTime lastSyncAt,
    required int playlistCount,
    required int songCount,
    required String deviceName,
  }) = _SyncMetadata;

  factory SyncMetadata.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataFromJson(json);
}
```

---

## 三、Feature 架构设计

### 3.1 新增模块结构

按项目 Feature-first 架构，新增 `share` 模块（分享 + 同步归为一个 feature）：

```
lib/features/share/
├── domain/
│   └── models/
│       ├── shared_playlist.dart        # SharedPlaylist + SharedSong（Freezed）
│       └── app_backup.dart             # AppBackup + BackupPlaylist + ... （Freezed）
├── data/
│   ├── share_repository.dart           # 分享 Repository 接口
│   ├── share_repository_impl.dart      # 具体实现（剪贴板、文件、编解码）
│   ├── share_remote_repository.dart    # 在线分享接口
│   ├── share_remote_repository_impl.dart  # 在线分享实现（jsonbin.io 等）
│   ├── sync_repository.dart            # 离线同步 Repository 接口
│   ├── sync_repository_impl.dart       # 离线同步实现（文件导入/导出）
│   └── sync_remote_repository.dart     # 在线同步接口（仅定义，暂不实现）
├── application/
│   ├── share_notifier.dart             # 分享业务逻辑 Notifier
│   └── sync_notifier.dart              # 同步业务逻辑 Notifier
└── presentation/
    ├── widgets/
    │   ├── share_dialog.dart           # 分享方式选择弹窗
    │   ├── import_preview_dialog.dart  # 导入预览确认弹窗
    │   ├── backup_overview_dialog.dart # 备份概览弹窗
    │   └── import_strategy_dialog.dart # 导入策略选择弹窗
    └── (无独立 Screen，功能通过弹窗集成到歌单列表/设置页面)
```

### 3.2 Repository 接口设计

#### ShareRepository（离线分享核心）

```dart
abstract class ShareRepository {
  /// 将歌单导出为分享格式（精简，仅含 bvid+cid+自定义字段）
  Future<SharedPlaylist> exportPlaylist(int playlistId);

  /// 将 SharedPlaylist 编码为剪贴板字符串（busic://playlist/<base64>）
  String encodeForClipboard(SharedPlaylist playlist);

  /// 从剪贴板字符串解码 SharedPlaylist
  SharedPlaylist decodeFromClipboard(String data);

  /// 导入歌单：创建歌单 + 逐首拉取元数据（本地已有则复用）+ 关联
  ///
  /// [onProgress] 回调报告导入进度（已处理数 / 总数）
  Future<ShareImportResult> importPlaylist(
    SharedPlaylist playlist, {
    String? overrideName,
    void Function(int current, int total)? onProgress,
  });
}

/// 分享导入结果
@freezed
class ShareImportResult with _$ShareImportResult {
  const factory ShareImportResult({
    /// 新建歌单 ID
    required int playlistId,
    /// 成功导入的歌曲数
    required int imported,
    /// 本地已存在的歌曲数（直接复用）
    required int reused,
    /// 拉取元数据失败的歌曲数
    required int failed,
    /// 失败的 bvid 列表（供用户排查）
    @Default([]) List<String> failedBvids,
  }) = _ShareImportResult;
}
```

#### SyncRepository（离线同步核心）

```dart
abstract class SyncRepository {
  /// 导出完整数据备份
  Future<AppBackup> exportFullBackup();

  /// 导入数据备份（合并模式）
  Future<ImportResult> importBackupMerge(AppBackup backup);

  /// 导入数据备份（覆盖模式）
  Future<ImportResult> importBackupOverwrite(AppBackup backup);
}

/// 导入结果统计
@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    required int playlistsCreated,
    required int playlistsMerged,
    required int songsCreated,
    required int songsSkipped,
    required int errors,
    @Default([]) List<String> warnings,
  }) = _ImportResult;
}
```

### 3.3 Notifier 设计

#### ShareNotifier

```dart
@riverpod
class ShareNotifier extends _$ShareNotifier {
  late final ShareRepository _shareRepo;

  @override
  ShareState build() {
    final db = ref.read(databaseProvider);
    _shareRepo = ShareRepositoryImpl(db: db);
    return const ShareState.idle();
  }

  /// 离线分享：导出歌单到剪贴板
  Future<void> exportToClipboard(int playlistId) async { ... }

  /// 离线分享：从剪贴板导入歌单
  Future<SharedPlaylist> parseFromClipboard() async { ... }

  /// 确认导入歌单
  Future<void> confirmImport(SharedPlaylist playlist, {String? name}) async { ... }

  /// 在线分享：上传歌单
  Future<String> uploadPlaylist(int playlistId) async { ... }

  /// 在线分享：从链接下载歌单
  Future<SharedPlaylist> downloadFromLink(String link) async { ... }
}
```

#### SyncNotifier

```dart
@riverpod
class SyncNotifier extends _$SyncNotifier {
  late final SyncRepository _syncRepo;

  @override
  SyncState build() {
    final db = ref.read(databaseProvider);
    _syncRepo = SyncRepositoryImpl(db: db);
    return const SyncState.idle();
  }

  /// 导出数据到文件
  Future<void> exportToFile() async { ... }

  /// 从文件导入数据
  Future<AppBackup> parseFromFile(String filePath) async { ... }

  /// 执行合并导入
  Future<void> importMerge(AppBackup backup) async { ... }

  /// 执行覆盖导入
  Future<void> importOverwrite(AppBackup backup) async { ... }
}
```

### 3.4 状态定义

```dart
/// 分享功能状态
@freezed
class ShareState with _$ShareState {
  const factory ShareState.idle() = _ShareIdle;
  const factory ShareState.exporting() = _ShareExporting;
  const factory ShareState.exported(String data) = _ShareExported;
  const factory ShareState.importing() = _ShareImporting;
  const factory ShareState.preview(SharedPlaylist playlist) = _SharePreview;
  const factory ShareState.importSuccess(int playlistId) = _ShareImportSuccess;
  const factory ShareState.error(String message) = _ShareError;
}

/// 同步功能状态
@freezed
class SyncState with _$SyncState {
  const factory SyncState.idle() = _SyncIdle;
  const factory SyncState.exporting() = _SyncExporting;
  const factory SyncState.exportSuccess(String filePath) = _SyncExportSuccess;
  const factory SyncState.importing() = _SyncImporting;
  const factory SyncState.preview(AppBackup backup) = _SyncPreview;
  const factory SyncState.importSuccess(ImportResult result) = _SyncImportSuccess;
  const factory SyncState.error(String message) = _SyncError;
}
```

---

## 四、UI 交互设计

### 4.1 入口位置

| 功能 | 入口位置 | 触发方式 |
|------|---------|---------|
| 歌单分享（导出） | 歌单详情页 AppBar | 分享按钮 / 长按歌单弹出菜单 |
| 歌单导入 | 歌单列表页 AppBar | 导入按钮（与新建歌单并列） |
| 数据备份导出 | 设置页面 | 「数据管理」分区下的「导出备份」 |
| 数据备份导入 | 设置页面 | 「数据管理」分区下的「导入备份」 |

### 4.2 弹窗流程

#### 分享弹窗（ShareDialog）

```
┌─────────────────────────────────┐
│         分享歌单                 │
│                                 │
│  📋  复制到剪贴板（离线分享）     │
│  🔗  生成分享链接（在线分享）     │
│                                 │
│              [取消]              │
└─────────────────────────────────┘
```

#### 导入预览弹窗（ImportPreviewDialog）

```
┌─────────────────────────────────┐
│         导入歌单预览             │
│                                 │
│  歌单名称：[可编辑文本框]        │
│  歌曲数量：12 首                 │
│  导出时间：2024-01-01 12:00      │
│                                 │
│  ┌─ 歌曲列表 ─────────────────┐ │
│  │ 1. 歌曲A - UP主1           │ │
│  │ 2. 歌曲B - UP主2           │ │
│  │ ... (可滚动)               │ │
│  └────────────────────────────┘ │
│                                 │
│        [取消]  [确认导入]        │
└─────────────────────────────────┘
```

#### 备份概览弹窗（BackupOverviewDialog）

```
┌─────────────────────────────────┐
│         导入数据备份             │
│                                 │
│  备份时间：2024-01-01 12:00      │
│  App 版本：0.1.0                 │
│  歌单数量：5 个                  │
│  歌曲数量：48 首                 │
│                                 │
│  导入策略：                      │
│  ○ 合并（推荐）- 保留现有数据    │
│  ○ 覆盖 - 清空后导入            │
│                                 │
│        [取消]  [确认导入]        │
└─────────────────────────────────┘
```

---

## 五、依赖与技术选型

### 5.1 新增依赖

```yaml
# 无需新增依赖，项目已有：
# - dart:convert（JSON 编解码 / Base64）
# - flutter/services.dart（Clipboard）
# - file_picker（文件选择/保存）
# - dio（HTTP 请求，用于在线分享）
# - freezed_annotation + json_annotation（模型定义）
```

不需要引入额外第三方包，利用现有依赖即可完成全部功能。

### 5.2 剪贴板操作

```dart
import 'package:flutter/services.dart';

// 写入剪贴板
await Clipboard.setData(ClipboardData(text: encodedData));

// 读取剪贴板
final data = await Clipboard.getData(Clipboard.kTextPlain);
```

### 5.3 文件操作

```dart
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// 选择保存路径（桌面端）
final path = await FilePicker.platform.saveFile(
  dialogTitle: '导出备份',
  fileName: 'busic_backup_${timestamp}.json',
  type: FileType.custom,
  allowedExtensions: ['json'],
);

// 选择导入文件
final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['json'],
);
```

---

## 六、实施计划

### Phase 1：核心模型与离线分享（优先实现）

1. **创建 `share` feature 目录结构**
2. **定义 Freezed 模型**：`SharedPlaylist`、`SharedSong`、`ShareState`
3. **实现 `ShareRepository`**：歌单导出/编码/解码/导入
4. **实现 `ShareNotifier`**：剪贴板导出/导入业务逻辑
5. **UI 集成**：歌单详情页添加分享按钮 + 歌单列表页添加导入按钮
6. **创建弹窗组件**：`ShareDialog`、`ImportPreviewDialog`
7. **运行代码生成** + 测试

### Phase 2：离线数据同步

1. **定义 Freezed 模型**：`AppBackup`、`BackupPlaylist`、`BackupPlaylistSong`、`BackupPreferences`、`ImportResult`、`SyncState`
2. **实现 `SyncRepository`**：全量导出/合并导入/覆盖导入
3. **实现 `SyncNotifier`**：文件导出/导入流程
4. **UI 集成**：设置页面添加「数据管理」分区
5. **创建弹窗组件**：`BackupOverviewDialog`、`ImportStrategyDialog`

### Phase 3：在线分享

1. **实现 `ShareRemoteRepository`**：对接 JSON 存储服务
2. **扩展 `ShareNotifier`**：上传/下载逻辑
3. **UI 更新**：分享弹窗添加在线选项、链接展示

### Phase 4：在线同步（后续）

1. **选定云服务方案**
2. **实现 `SyncRemoteRepository`**
3. **增量同步逻辑**
4. **冲突解决策略**

---

## 七、注意事项

### 安全性

- **不导出登录凭据**（`UserSessions` 表数据不包含在备份中）
- 在线分享的 JSON 不包含任何用户敏感信息
- 在线分享链接建议设有效期（如 7 天自动过期）

### 兼容性

- `version` 字段确保格式升级时的向前兼容
- 低版本 App 遇到高版本数据时明确提示升级
- 反序列化时使用 `try-catch`，优雅处理格式不匹配

### 性能

- 大歌单（数百首歌曲）导出时在后台执行，展示加载状态
- 导入时使用 `batch` 操作批量写入数据库
- Base64 编码后的字符串可能较大，剪贴板分享适用于中小型歌单（<200 首）

### 国际化

- 所有 UI 文案需通过 ARB 文件国际化
- 错误提示文案使用 `AppLocalizations`
