# 导入 B 站收藏夹 — 功能规划

> 对应 Issue: [#7 — 一键导入 B 站收藏夹](https://github.com/GlowLED/BuSic/issues/7)

## 概述

允许已登录用户**一键拉取自己的 B 站收藏夹列表**，选择一个或多个收藏夹后，将其中的视频批量导入为 BuSic 本地歌单。入口放置在**创建歌单对话框**中，与现有的「手动创建」并列，让用户在新建歌单时可一步选择从 B 站收藏夹导入。

---

## 一、现状分析

### 1.1 现有创建歌单入口

| 位置 | 当前行为 |
|------|---------|
| `PlaylistListScreen` FAB「+」按钮 | 弹出 `CommonDialogs.showInputDialog`，输入歌单名后创建空歌单 |
| `PlaylistListScreen` FAB「粘贴」按钮 | 从剪贴板解析 `busic://playlist/` 格式数据导入歌单 |
| `PlaylistDetailScreen._createAndSelect()` | 歌单内"添加到歌单"时也可新建 |

### 1.2 可复用的基础设施

| 组件 | 复用点 |
|------|--------|
| `BiliDio` | 已封装 Cookie 注入 + Referer，可直接调用 B 站收藏夹 API |
| `AuthNotifier` / `authNotifierProvider` | 已管理登录态，可检查是否已登录 |
| `ParseRepository.getVideoInfo(bvid)` | 按 bvid 拉取视频元数据（标题、作者、封面、分P列表） |
| `PlaylistRepository.upsertSong()` | 按 `bvid+cid` 去重插入歌曲 |
| `PlaylistRepository.createPlaylist()` / `addSongsToPlaylist()` | 创建歌单 + 批量关联 |
| `ShareRepositoryImpl._processSong()` | 并发拉取元数据 + 信号量控制模式可直接参考 |
| `ImportPreviewDialog` | 导入前预览 UI 模式可参考 |

### 1.3 需要新增的部分

- **B 站收藏夹 API 调用**（2 个新端点）
- **收藏夹选择 UI**（收藏夹列表对话框）
- **导入进度 UI**（批量导入进度指示）
- **创建歌单对话框改造**（从简单输入框升级为支持多种创建方式的对话框）

---

## 二、B 站收藏夹 API

### 2.1 获取用户收藏夹列表

**端点**：`GET /x/v3/fav/folder/created/list-all`

**需要登录**：✅（Cookie 中需包含 SESSDATA）

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `up_mid` | int | ✅ | 用户 UID（从 `User.userId` 获取） |

**响应示例**：

```json
{
  "code": 0,
  "data": {
    "count": 3,
    "list": [
      {
        "id": 123456,
        "fid": 1234,
        "mid": 10086,
        "title": "我的音乐收藏",
        "media_count": 42,
        "attr": 0
      },
      {
        "id": 789012,
        "fid": 7890,
        "mid": 10086,
        "title": "ACG 音乐",
        "media_count": 128,
        "attr": 0
      }
    ]
  }
}
```

**关键字段**：

| 字段 | 说明 |
|------|------|
| `id` | 收藏夹 media_id（用于查询内容） |
| `title` | 收藏夹名称 |
| `media_count` | 收藏夹内视频数量 |
| `attr` | 属性标记（0=公开，22 位为 1 时=私密） |

### 2.2 获取收藏夹内容

**端点**：`GET /x/v3/fav/resource/list`

**需要登录**：✅

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `media_id` | int | ✅ | 收藏夹 ID（来自 2.1 的 `id` 字段） |
| `pn` | int | ❌ | 页码，默认 1 |
| `ps` | int | ❌ | 每页数量，默认 20，最大 40（**实际B站限制，建议用20**） |
| `keyword` | string | ❌ | 搜索关键词（可选） |
| `order` | string | ❌ | 排序：`mtime`（收藏时间）/ `view`（播放量）/ `pubtime`（投稿时间） |

**响应示例**：

```json
{
  "code": 0,
  "data": {
    "info": {
      "id": 123456,
      "title": "我的音乐收藏",
      "media_count": 42
    },
    "medias": [
      {
        "id": 170001,
        "type": 2,
        "title": "【洛天依】某某某",
        "cover": "https://i0.hdslb.com/bfs/archive/xxx.jpg",
        "upper": {
          "mid": 456,
          "name": "某UP主"
        },
        "cnt_info": {
          "play": 100000
        },
        "duration": 285,
        "ugc": {
          "first_cid": 12345
        },
        "bvid": "BV1xx411c7mD",
        "attr": 0
      }
    ],
    "has_more": true
  }
}
```

**关键字段**：

| 字段 | 说明 |
|------|------|
| `medias[].bvid` | BV 号 |
| `medias[].title` | 视频标题 |
| `medias[].upper.name` | UP 主名称 |
| `medias[].cover` | 封面 URL |
| `medias[].duration` | 时长（秒） |
| `medias[].ugc.first_cid` | 首P 的 CID |
| `medias[].attr` | 9 位为 1 时表示已失效 |
| `data.has_more` | 是否有下一页 |

**注意**：
- `medias[].attr` 的第 9 位（`(attr >> 9) & 1`）为 1 时，视频已失效（被删除/不可用），应跳过
- 多 P 视频仅返回 `first_cid`，如需导入全部分 P，需额外调用 `getVideoInfo(bvid)` 获取完整 pages 列表
- 分页需循环拉取直到 `has_more = false`

---

## 三、数据模型设计

### 3.1 新增 Domain 模型

在 `search_and_parse` feature 下新增收藏夹相关模型（因为收藏夹数据来自 B 站 API，属于解析/搜索范畴）：

```dart
// lib/features/search_and_parse/domain/models/bili_fav_folder.dart

/// B 站收藏夹信息
@freezed
class BiliFavFolder with _$BiliFavFolder {
  const factory BiliFavFolder({
    /// 收藏夹 media_id
    required int id,

    /// 收藏夹标题
    required String title,

    /// 收藏夹内视频数量
    required int mediaCount,
  }) = _BiliFavFolder;
}
```

```dart
// lib/features/search_and_parse/domain/models/bili_fav_item.dart

/// B 站收藏夹中的单个视频条目
@freezed
class BiliFavItem with _$BiliFavItem {
  const factory BiliFavItem({
    /// BV 号
    required String bvid,

    /// 视频标题
    required String title,

    /// UP 主名称
    required String upper,

    /// 封面 URL
    String? cover,

    /// 时长（秒）
    required int duration,

    /// 首 P 的 CID
    required int firstCid,

    /// 是否已失效
    @Default(false) bool isInvalid,
  }) = _BiliFavItem;
}
```

### 3.2 数据库变更

**无需变更**。现有的 `Songs`、`Playlists`、`PlaylistSongs` 表完全适用。`upsertSong()` 已支持 `bvid+cid` 去重。

---

## 四、分层实现方案

### 4.1 数据层（Data）

#### ParseRepository 新增接口

```dart
// lib/features/search_and_parse/data/parse_repository.dart 新增

/// 获取用户的所有收藏夹列表（需要登录）
///
/// [mid] 为用户 UID，从已登录的 User 对象获取。
Future<List<BiliFavFolder>> getFavoriteFolders(int mid);

/// 获取收藏夹中的所有视频（自动分页拉取全量）
///
/// [mediaId] 为收藏夹 ID（BiliFavFolder.id）。
/// 自动过滤已失效视频。
/// [onProgress] 回调 (已拉取数, 总数) 用于进度提示。
Future<List<BiliFavItem>> getFavoriteFolderItems(
  int mediaId, {
  void Function(int fetched, int total)? onProgress,
});
```

#### ParseRepositoryImpl 新增实现

```dart
@override
Future<List<BiliFavFolder>> getFavoriteFolders(int mid) async {
  final response = await _biliDio.get(
    '/x/v3/fav/folder/created/list-all',
    queryParameters: {'up_mid': mid},
  );
  final data = response.data['data'];
  final list = data['list'] as List<dynamic>? ?? [];
  return list.map((item) => BiliFavFolder(
    id: item['id'] as int,
    title: item['title'] as String,
    mediaCount: item['media_count'] as int,
  )).toList();
}

@override
Future<List<BiliFavItem>> getFavoriteFolderItems(
  int mediaId, {
  void Function(int fetched, int total)? onProgress,
}) async {
  final items = <BiliFavItem>[];
  int page = 1;
  bool hasMore = true;

  while (hasMore) {
    final response = await _biliDio.get(
      '/x/v3/fav/resource/list',
      queryParameters: {
        'media_id': mediaId,
        'pn': page,
        'ps': 20,
      },
    );
    final data = response.data['data'];
    final medias = data['medias'] as List<dynamic>? ?? [];
    final totalCount = data['info']['media_count'] as int;

    for (final media in medias) {
      // 跳过已失效视频
      final attr = media['attr'] as int? ?? 0;
      if ((attr >> 9) & 1 == 1) continue;

      items.add(BiliFavItem(
        bvid: media['bvid'] as String,
        title: media['title'] as String,
        upper: media['upper']['name'] as String,
        cover: media['cover'] as String?,
        duration: media['duration'] as int? ?? 0,
        firstCid: media['ugc']?['first_cid'] as int? ?? 0,
      ));
    }

    hasMore = data['has_more'] as bool? ?? false;
    onProgress?.call(items.length, totalCount);
    page++;
  }

  return items;
}
```

### 4.2 应用层（Application）

新增 `BiliFavImportNotifier` 管理导入流程状态：

```dart
// lib/features/playlist/application/bili_fav_import_notifier.dart

@freezed
class BiliFavImportState with _$BiliFavImportState {
  /// 初始/空闲状态
  const factory BiliFavImportState.idle() = _Idle;

  /// 正在加载收藏夹列表
  const factory BiliFavImportState.loadingFolders() = _LoadingFolders;

  /// 已加载收藏夹列表，等待用户选择
  const factory BiliFavImportState.foldersLoaded(
    List<BiliFavFolder> folders,
  ) = _FoldersLoaded;

  /// 正在拉取收藏夹内容
  const factory BiliFavImportState.loadingItems({
    required String folderName,
    required int fetched,
    required int total,
  }) = _LoadingItems;

  /// 已加载收藏夹内容，等待用户确认导入
  const factory BiliFavImportState.itemsLoaded({
    required String folderName,
    required List<BiliFavItem> items,
  }) = _ItemsLoaded;

  /// 正在导入歌曲到本地歌单
  const factory BiliFavImportState.importing({
    required int current,
    required int total,
  }) = _Importing;

  /// 导入完成
  const factory BiliFavImportState.completed({
    required int playlistId,
    required int imported,
    required int reused,
    required int failed,
    required List<String> failedBvids,
  }) = _Completed;

  /// 出错
  const factory BiliFavImportState.error(String message) = _Error;
}

@riverpod
class BiliFavImportNotifier extends _$BiliFavImportNotifier {
  @override
  BiliFavImportState build() => const BiliFavImportState.idle();

  /// 加载用户的 B 站收藏夹列表
  Future<void> loadFolders() async {
    final keepAlive = ref.keepAlive();
    state = const BiliFavImportState.loadingFolders();
    try {
      final user = await ref.read(authNotifierProvider.future);
      if (user == null) {
        state = const BiliFavImportState.error('请先登录 B 站账号');
        return;
      }
      final folders = await ref
          .read(parseRepositoryProvider)
          .getFavoriteFolders(int.parse(user.userId));
      state = BiliFavImportState.foldersLoaded(folders);
    } catch (e) {
      state = BiliFavImportState.error('加载收藏夹失败: $e');
    }
  }

  /// 加载指定收藏夹的内容
  Future<void> loadFolderItems(BiliFavFolder folder) async {
    state = BiliFavImportState.loadingItems(
      folderName: folder.title,
      fetched: 0,
      total: folder.mediaCount,
    );
    try {
      final items = await ref
          .read(parseRepositoryProvider)
          .getFavoriteFolderItems(
            folder.id,
            onProgress: (fetched, total) {
              state = BiliFavImportState.loadingItems(
                folderName: folder.title,
                fetched: fetched,
                total: total,
              );
            },
          );
      state = BiliFavImportState.itemsLoaded(
        folderName: folder.title,
        items: items,
      );
    } catch (e) {
      state = BiliFavImportState.error('加载收藏夹内容失败: $e');
    }
  }

  /// 执行导入：创建歌单并逐首处理
  Future<void> importToPlaylist({
    required String playlistName,
    required List<BiliFavItem> items,
  }) async {
    // 与 ShareRepositoryImpl.importPlaylist() 类似的模式
    // 1. 创建歌单
    // 2. 并发（信号量控制 3 路）处理每首歌
    //    - 本地已有 (bvid+firstCid) → 复用
    //    - 本地不存在 → getVideoInfo(bvid) 拉取元数据 → upsertSong
    // 3. 批量关联到歌单
    // 4. 刷新歌单列表
  }
}
```

### 4.3 UI 层（Presentation）

#### 4.3.1 创建歌单对话框改造

将 `_createPlaylist()` 中的 `CommonDialogs.showInputDialog` 替换为新的 **创建歌单对话框**，提供两种创建方式：

```
┌─────────────────────────────────┐
│       创建歌单                    │
│                                 │
│  ┌─────────────────────────┐    │
│  │ 📝 手动创建              │    │
│  │   输入歌单名称即可创建    │    │
│  └─────────────────────────┘    │
│                                 │
│  ┌─────────────────────────┐    │
│  │ ⭐ 从 B 站收藏夹导入     │    │
│  │   登录后选择收藏夹导入    │    │
│  └─────────────────────────┘    │
│                                 │
│              [取消]              │
└─────────────────────────────────┘
```

**设计决策**：

- 用户点击「手动创建」→ 弹出原有的歌单名输入对话框（保持原行为）
- 用户点击「从 B 站收藏夹导入」→ 检查登录状态 → 进入收藏夹选择流程

#### 4.3.2 收藏夹选择流程

```
点击「从 B 站收藏夹导入」
  │
  ├─ 未登录 → 提示「请先在设置中登录 B 站账号」→ 可选跳转登录页
  │
  └─ 已登录 → 加载收藏夹列表 → 显示选择对话框：
     │
     │  ┌────────────────────────────┐
     │  │  选择收藏夹                  │
     │  │                            │
     │  │  ⭐ 默认收藏夹    (42首)    │
     │  │  🎵 ACG 音乐     (128首)   │
     │  │  🎹 古典音乐      (56首)   │
     │  │                            │
     │  │       [取消]               │
     │  └────────────────────────────┘
     │
     └─ 用户选择某个收藏夹
        │
        └─ 分页拉取收藏夹内容（显示进度）
           │
           └─ 显示导入预览（可勾选/取消勾选歌曲，可修改歌单名）
              │
              │  ┌────────────────────────────┐
              │  │  导入预览 — ACG 音乐         │
              │  │                             │
              │  │  歌单名称：[ACG 音乐    ]    │
              │  │                             │
              │  │  ☑ 某某某 - UP主A  3:45     │
              │  │  ☑ 另一首 - UP主B  4:12     │
              │  │  ☐ (已失效)                 │
              │  │  ☑ 第三首 - UP主C  5:00     │
              │  │  ...                        │
              │  │                             │
              │  │  已选 126/128 首             │
              │  │                             │
              │  │  [取消]  [确认导入]          │
              │  └────────────────────────────┘
              │
              └─ 用户确认 → 执行导入（显示进度条）
                 │
                 └─ 完成 → 显示结果（导入 N 首，复用 M 首，失败 K 首）
                    → 自动跳转到新歌单详情页
```

#### 4.3.3 新增 Widget 文件

```
lib/features/playlist/presentation/widgets/
├── create_playlist_dialog.dart        # 新增：创建歌单方式选择对话框
├── bili_fav_folder_dialog.dart        # 新增：收藏夹列表选择对话框
├── bili_fav_import_preview_dialog.dart # 新增：导入预览对话框（参考 ImportPreviewDialog）
```

### 4.4 多 P 视频处理策略

B 站收藏夹 API 每个视频只返回 `first_cid`。对于多 P 视频，需要决定导入策略：

| **导入全部 P** | 对每个 bvid 调用 `getVideoInfo()` 拉取 pages 列表，全部导入 | 后续迭代 |

---

## 五、完整数据流

```
[UI] 点击 FAB「+」
  │
  ├─ 弹出 CreatePlaylistDialog
  │   ├─ 选择「手动创建」 → showInputDialog → createPlaylist(name)
  │   └─ 选择「从 B 站收藏夹导入」
  │       │
  │       ├─ [Notifier] biliFavImportNotifier.loadFolders()
  │       │   └─ [Repository] parseRepository.getFavoriteFolders(mid)
  │       │       └─ [API] GET /x/v3/fav/folder/created/list-all?up_mid=xxx
  │       │
  │       ├─ [UI] 弹出 BiliFavFolderDialog（展示收藏夹列表）
  │       │   └─ 用户选择某个收藏夹
  │       │
  │       ├─ [Notifier] biliFavImportNotifier.loadFolderItems(folder)
  │       │   └─ [Repository] parseRepository.getFavoriteFolderItems(mediaId)
  │       │       └─ [API] GET /x/v3/fav/resource/list?media_id=xxx（自动分页）
  │       │
  │       ├─ [UI] 弹出 BiliFavImportPreviewDialog（展示歌曲列表 + 勾选）
  │       │   └─ 用户确认导入
  │       │
  │       └─ [Notifier] biliFavImportNotifier.importToPlaylist(name, items)
  │           ├─ [Repository] playlistRepository.createPlaylist(name)
  │           ├─ 并发处理每首歌曲（信号量 3 路）：
  │           │   ├─ 检查本地 Songs 表是否已有 bvid+cid
  │           │   │   ├─ 已有 → 复用（reused++）
  │           │   │   └─ 不存在 → parseRepository.getVideoInfo(bvid)
  │           │   │       └─ playlistRepository.upsertSong(...)（imported++）
  │           │   └─ 失败 → 记录 failedBvids（failed++）
  │           ├─ [Repository] playlistRepository.addSongsToPlaylist(id, songIds)
  │           └─ ref.invalidateSelf() 刷新歌单列表
  │
  └─ 导入完成 → 显示结果 SnackBar → 导航到新歌单详情页
```

---

## 六、错误处理

| 场景 | 处理方式 |
|------|---------|
| 未登录 | 提示「请先登录 B 站账号」，提供跳转到设置/登录页的快捷入口 |
| Cookie 过期 | API 返回 `-101`（未登录），提示「登录已过期，请重新登录」 |
| 收藏夹为空 | 提示「该收藏夹暂无内容」 |
| 网络错误 | 提示「网络连接失败，请检查网络后重试」 |
| 单首歌曲拉取失败 | 不阻塞整体导入，记录失败 bvid，最终汇总报告 |
| 全部歌曲拉取失败 | 提示「所有歌曲导入失败，请检查网络连接」 |
| 收藏夹内容全部失效 | 过滤后列表为空，提示「收藏夹中的视频均已失效」 |

---

## 七、国际化

需要新增的 l10n 键：

```json
// app_zh.arb
"createPlaylistManual": "手动创建",
"createPlaylistManualDesc": "输入歌单名称创建空歌单",
"importFromBiliFav": "从 B 站收藏夹导入",
"importFromBiliFavDesc": "登录后选择收藏夹一键导入",
"selectFavFolder": "选择收藏夹",
"loadingFavFolders": "正在加载收藏夹...",
"loadingFavItems": "正在拉取收藏夹内容 ({fetched}/{total})",
"favFolderEmpty": "该收藏夹暂无内容",
"favItemsAllInvalid": "收藏夹中的视频均已失效",
"importPreviewTitle": "导入预览",
"importPreviewSelected": "已选 {selected}/{total} 首",
"confirmImport": "确认导入",
"importingProgress": "正在导入 ({current}/{total})",
"importComplete": "导入完成：{imported} 首新增，{reused} 首已有，{failed} 首失败",
"pleaseLoginFirst": "请先登录 B 站账号",
"loginExpired": "登录已过期，请重新登录",
"songCount": "{count} 首"
```

```json
// app_en.arb
"createPlaylistManual": "Create Manually",
"createPlaylistManualDesc": "Enter a name to create an empty playlist",
"importFromBiliFav": "Import from Bilibili Favorites",
"importFromBiliFavDesc": "Sign in to import from your favorite folders",
"selectFavFolder": "Select Favorite Folder",
"loadingFavFolders": "Loading favorites...",
"loadingFavItems": "Fetching favorites ({fetched}/{total})",
"favFolderEmpty": "This favorite folder is empty",
"favItemsAllInvalid": "All videos in this folder are unavailable",
"importPreviewTitle": "Import Preview",
"importPreviewSelected": "{selected}/{total} selected",
"confirmImport": "Confirm Import",
"importingProgress": "Importing ({current}/{total})",
"importComplete": "Done: {imported} new, {reused} existing, {failed} failed",
"pleaseLoginFirst": "Please sign in to Bilibili first",
"loginExpired": "Session expired, please sign in again",
"songCount": "{count} songs"
```

---

## 八、实现步骤（推荐顺序）

### Phase 1：数据层（预计 1-2h）

1. 新增 `BiliFavFolder`、`BiliFavItem` freezed 模型
2. `ParseRepository` 新增 `getFavoriteFolders()` 和 `getFavoriteFolderItems()` 接口
3. `ParseRepositoryImpl` 实现两个新 API 调用
4. 运行 `build_runner`

### Phase 2：应用层（预计 1h）

5. 新增 `BiliFavImportNotifier` + `BiliFavImportState`
6. 实现 `loadFolders()`、`loadFolderItems()`、`importToPlaylist()`
7. 运行 `build_runner`

### Phase 3：UI 层（预计 2-3h）

8. 新增 `CreatePlaylistDialog`（方式选择）
9. 新增 `BiliFavFolderDialog`（收藏夹列表选择）
10. 新增 `BiliFavImportPreviewDialog`（歌曲预览 + 勾选）
11. 改造 `PlaylistListScreen._createPlaylist()` 使用新对话框
12. 添加全部 l10n 键

### Phase 4：测试与优化

13. 在模拟器上完整测试登录 → 选择收藏夹 → 导入流程
14. 测试边界情况（未登录、空收藏夹、全部失效、大量歌曲分页）
15. 性能优化（大收藏夹 500+ 首时的导入速度和内存占用）

---

## 九、注意事项

1. **登录态检查**：调用收藏夹 API 前必须确认用户已登录，`BiliDio` 会自动注入 Cookie
2. **频率限制**：B 站对 API 有频率限制，导入歌曲元数据时使用信号量控制并发数（建议 3 路）
3. **失效视频**：通过 `attr` 字段的第 9 位判断，在 UI 中显示为灰色/不可选
4. **AutoDispose 陷阱**：`BiliFavImportNotifier` 的异步方法必须使用 `ref.keepAlive()` 防止操作中途被回收
5. **WBI 签名**：收藏夹 API 目前不需要 WBI 签名，但如果后续 B 站变更，可能需要适配
6. **收藏夹隐私**：`attr` 字段可判断收藏夹是否私密（第 22 位），但因为是用户自己的收藏夹所以都可见
7. **入口位置**：创建歌单对话框中也可以考虑在 `PlaylistListScreen` 的 FAB 区域增加第三个按钮，但会导致 FAB 区过于拥挤，所以选择放在创建歌单对话框内部
