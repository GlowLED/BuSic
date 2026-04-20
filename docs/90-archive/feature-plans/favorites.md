# "我喜欢" 收藏功能 — 功能规划

> 对应 Issue: [#4 — 增加 "我喜欢" 功能](https://github.com/GlowLED/BuSic/issues/4)

## 概述

为 BuSic 增加**快速收藏**功能：用户在搜索结果、歌单详情等任意歌曲出现的位置，均可**一键点击爱心图标**即可将歌曲收藏/取消收藏到系统内置的「我喜欢」歌单。爱心按钮始终可见，不折叠在菜单中。

---

## 一、现状分析

### 1.1 现有数据模型

| 表 | 关键字段 | 备注 |
|----|----------|------|
| `Playlists` | `id`, `name`, `coverUrl`, `sortOrder`, `createdAt` | 普通用户歌单，无系统标记字段 |
| `PlaylistSongs` | `playlistId`, `songId`, `sortOrder` | 多对多关联 |
| `Songs` | `id`, `bvid`, `cid`, `originTitle`, … | 歌曲实体 |

**问题**：没有「收藏」概念，没有区分普通歌单与系统歌单的机制。

### 1.2 现有 UI

| 位置 | 现有 trailing 布局 | 有无收藏入口 |
|------|---------------------|-------------|
| `SongTile`（共享组件） | `[时长] [播放/暂停] [更多]` | ❌ 无 |
| 搜索结果列表 `ListTile` | `chevron_right` | ❌ 无 |
| 歌单详情 `SongTile` | 同共享组件 | ❌ 无 |

---

## 二、方案设计

### 2.1 核心方案：系统歌单 + `isFavorite` 标记

在 `Playlists` 表增加 `isFavorite` 布尔字段，标记唯一的系统收藏歌单。

**优点**：
- 复用已有歌单基础设施（CRUD、展示、分享、导入导出）
- 无需新建表，最小化改动
- 收藏歌单在歌单列表中自然展示，用户也可进入管理

**设计要点**：
- 整个 App 生命周期中有且仅有一个 `isFavorite = true` 的歌单
- 该歌单不可删除、不可重命名（名称由 l10n 提供）
- 首次触发收藏操作时自动创建，也可在 App 初始化时预创建

### 2.2 数据库变更

#### Playlists 表新增字段

```dart
// tables/playlists.dart
class Playlists extends Table {
  // ... existing fields ...

  /// Whether this is the system "My Favorites" playlist.
  /// Only one playlist can have this set to true.
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}
```

#### Schema 升级（v2 → v3）

```dart
// app_database.dart
@override
int get schemaVersion => 3;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(downloadTasks, downloadTasks.quality);
      }
      if (from < 3) {
        await m.addColumn(playlists, playlists.isFavorite);
      }
    },
  );
}
```

---

## 三、具体实现分层

### 3.1 数据层（Data）

#### PlaylistRepository 新增接口

```dart
// playlist_repository.dart 新增方法
abstract class PlaylistRepository {
  // ... existing ...

  /// 获取或创建收藏歌单，保证全局唯一
  Future<Playlist> getOrCreateFavorites();

  /// 切换歌曲的收藏状态（加入/移出收藏歌单）
  Future<bool> toggleFavorite(int songId);

  /// 检查歌曲是否已收藏
  Future<bool> isFavorited(int songId);

  /// 批量检查歌曲是否已收藏（返回已收藏的 songId 集合）
  Future<Set<int>> getFavoritedSongIds(List<int> songIds);
}
```

#### PlaylistRepositoryImpl 实现

```dart
@override
Future<Playlist> getOrCreateFavorites() async {
  // 查找 isFavorite = true 的歌单
  final row = await (_db.select(_db.playlists)
    ..where((t) => t.isFavorite.equals(true)))
    .getSingleOrNull();

  if (row != null) {
    return _mapPlaylist(row, ...);
  }

  // 首次创建，名称使用固定标识（UI 层通过 l10n 显示）
  final id = await _db.into(_db.playlists).insert(
    PlaylistsCompanion.insert(
      name: '@@favorites@@', // 内部标识，UI 层用 l10n 覆盖显示
      isFavorite: const Value(true),
      sortOrder: const Value(-1), // 置顶
    ),
  );
  return Playlist(
    id: id,
    name: '@@favorites@@',
    songCount: 0,
    createdAt: DateTime.now(),
    isFavorite: true,
  );
}

@override
Future<bool> toggleFavorite(int songId) async {
  final favPlaylist = await getOrCreateFavorites();
  final exists = await isFavorited(songId);
  if (exists) {
    await removeSongFromPlaylist(favPlaylist.id, songId);
    return false; // 已取消收藏
  } else {
    await addSongToPlaylist(favPlaylist.id, songId);
    return true; // 已收藏
  }
}

@override
Future<bool> isFavorited(int songId) async {
  final favPlaylist = await getOrCreateFavorites();
  final row = await (_db.select(_db.playlistSongs)
    ..where((t) =>
      t.playlistId.equals(favPlaylist.id) &
      t.songId.equals(songId)))
    .getSingleOrNull();
  return row != null;
}

@override
Future<Set<int>> getFavoritedSongIds(List<int> songIds) async {
  final favPlaylist = await getOrCreateFavorites();
  final rows = await (_db.select(_db.playlistSongs)
    ..where((t) =>
      t.playlistId.equals(favPlaylist.id) &
      t.songId.isIn(songIds)))
    .get();
  return rows.map((r) => r.songId).toSet();
}
```

### 3.2 领域层（Domain）

#### Playlist 模型新增字段

```dart
// domain/models/playlist.dart
@freezed
class Playlist with _$Playlist {
  const factory Playlist({
    required int id,
    required String name,
    String? coverUrl,
    @Default(0) int songCount,
    required DateTime createdAt,
    @Default(false) bool isFavorite,  // 新增
  }) = _Playlist;
}
```

### 3.3 状态管理层（Application）

#### 新增 FavoriteNotifier

```dart
// features/playlist/application/favorite_notifier.dart
@riverpod
class FavoriteNotifier extends _$FavoriteNotifier {
  late PlaylistRepository _repository;

  @override
  Future<Set<int>> build() async {
    _repository = PlaylistRepositoryImpl(db: ref.read(databaseProvider));
    // 初始化时不加载所有收藏，返回空集
    // 具体页面按需调用 loadFavoriteStatus
    return {};
  }

  /// 加载一批歌曲的收藏状态
  Future<void> loadFavoriteStatus(List<int> songIds) async {
    final favIds = await _repository.getFavoritedSongIds(songIds);
    state = AsyncData(favIds);
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(int songId) async {
    ref.keepAlive(); // 防止 AutoDispose 中途回收
    final isFav = await _repository.toggleFavorite(songId);
    final current = state.value ?? {};
    if (isFav) {
      state = AsyncData({...current, songId});
    } else {
      state = AsyncData({...current}..remove(songId));
    }
    // 刷新歌单列表（数量变化）
    ref.invalidate(playlistListNotifierProvider);
  }

  /// 检查单首歌是否已收藏
  bool isFavorited(int songId) {
    return state.value?.contains(songId) ?? false;
  }
}
```

### 3.4 UI 层（Presentation）

#### 3.4.1 SongTile 组件改造

在 `SongTile` 的 trailing 区域增加**始终可见的爱心按钮**，位于播放按钮左侧：

```dart
// shared/widgets/song_tile.dart — 新增参数
class SongTile extends StatelessWidget {
  // ... existing ...

  /// 是否已收藏（null 表示不显示爱心按钮）
  final bool? isFavorited;

  /// 收藏按钮点击回调
  final VoidCallback? onFavoritePressed;

  // trailing 布局改为：
  // [时长] [❤️收藏] [▶️播放] [⋮更多]
}
```

**爱心按钮样式**：
- 未收藏：`Icons.favorite_border`，颜色 `onSurfaceVariant`
- 已收藏：`Icons.favorite`，颜色 `Colors.red` / `colorScheme.error`
- 点击时有短暂缩放动画反馈

#### 3.4.2 搜索结果列表

搜索结果中的歌曲尚未入库（无 songId），因此搜索结果列表项**暂不显示爱心按钮**。

爱心收藏仅出现在**已解析的视频详情**区域的分 P 列表中（此时可以先 upsert 入库再收藏），以及添加到歌单后的歌单详情里。

> **替代方案**：若希望在搜索结果中也显示，需先静默 upsert 歌曲到 Songs 表获取 songId，再关联到收藏歌单。这会增加复杂度，建议 v1 暂不实现，后续迭代。

#### 3.4.3 歌单详情页

在 `PlaylistDetailScreen` 的 SongTile 使用处传入收藏状态：

```dart
SongTile(
  // ... existing props ...
  isFavorited: ref.watch(favoriteNotifierProvider).value?.contains(song.id) ?? false,
  onFavoritePressed: () {
    ref.read(favoriteNotifierProvider.notifier).toggleFavorite(song.id);
  },
)
```

页面 `build` 时需在歌曲数据加载后调用 `loadFavoriteStatus`：

```dart
// 在 songs 加载完成后
ref.listen(playlistDetailNotifierProvider(playlistId), (_, next) {
  next.whenData((songs) {
    ref.read(favoriteNotifierProvider.notifier)
      .loadFavoriteStatus(songs.map((s) => s.id).toList());
  });
});
```

#### 3.4.4 歌单列表页

「我喜欢」歌单在歌单列表中特殊展示：
- 置顶显示（`sortOrder = -1`）
- 名称从 l10n 读取（`l10n.myFavorites`），不使用数据库中的内部标识
- 图标使用 `Icons.favorite` 替代默认的 `Icons.library_music`
- 不可删除、不可重命名（右键/长按菜单隐藏这些选项）

#### 3.4.5 播放器底栏（PlayerBar）— 自适应双行布局

当前 `PlayerBar` 固定高度 72px，所有控件挤在一行。新增爱心按钮后移动端会更拥挤。

**改为自适应布局**：使用 `LayoutBuilder` 判断可用宽度，窄屏（`< 480px`）时自动切换为两行布局。

**一行布局**（宽屏 / 桌面端）：
```
进度条
[封面] [标题/作者] [音质] [时间] [❤️] [模式] [音量] [上一首] [播放/暂停] [下一首]
```

**两行布局**（窄屏 / 移动端）：
```
进度条
[封面] [标题/作者]  [❤️] [上一首] [播放/暂停] [下一首]
```

窄屏时将 `[音质] [时间] [模式] [音量]` 隐藏（这些信息在全屏播放页可见），只保留核心操作按钮。

**实现方式**：

```dart
// player_bar.dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // ...
  return LayoutBuilder(
    builder: (context, constraints) {
      // 窄屏阈值：宽度不足以容纳所有按钮
      final isCompact = constraints.maxWidth < 480;
      final barHeight = 72.0; // 保持单行高度

      return Container(
        height: barHeight,
        // ...
        child: Stack(
          children: [
            // 进度条
            // ...
            // 内容区
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // 封面（点击进全屏）
                    // 标题/作者（Expanded）
                    // — 宽屏独有 —
                    if (!isCompact) ...[
                      // 音质标签
                      // 时间显示（桌面端）
                    ],
                    // ❤️ 收藏（songId > 0 时）
                    if (track.songId > 0)
                      _buildFavoriteButton(context, ref, track),
                    // — 宽屏独有 —
                    if (!isCompact) ...[
                      // 播放模式
                      // 音量（桌面端）
                    ],
                    // 上一首 / 播放暂停 / 下一首（始终显示）
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
```

**收藏按钮样式**：
- 未收藏：`Icons.favorite_border`，颜色 `onSurfaceVariant`
- 已收藏：`Icons.favorite`，颜色 `Colors.redAccent`
- `visualDensity: VisualDensity.compact`

#### 3.4.6 全屏播放页（FullPlayerScreen）— 收藏 + 自适应控制行

**顶部 AppBar**

在队列按钮左侧增加爱心按钮：

```
[返回] [spacer] [❤️收藏] [队列]
```

**底部控制区 — 自适应布局**

当前所有控制按钮在一行 `Row(spaceEvenly)`，新增收藏后共 6 个按钮。横屏或宽设备一行显示，窄屏或竖屏自动分成两行。

**一行布局**（宽屏 `>= 400px`）：
```
[❤️] [模式] [上一首] [播放/暂停] [下一首] [音量]
```

**两行布局**（窄屏 `< 400px`）：
```
行1: [上一首] [播放/暂停] [下一首]
行2: [❤️] [模式] [音量]
```

**实现方式**：

```dart
// full_player_screen.dart — Controls 区域
LayoutBuilder(
  builder: (context, constraints) {
    final isCompact = constraints.maxWidth < 400;

    if (isCompact) {
      return Column(
        children: [
          // 主控制行：上一首 / 播放暂停 / 下一首
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [previousBtn, playPauseBtn, nextBtn],
          ),
          const SizedBox(height: 8),
          // 辅助行：收藏 / 模式 / 音量
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [favoriteBtn, modeBtn, volumeBtn],
          ),
        ],
      );
    }

    // 宽屏一行
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [favoriteBtn, modeBtn, previousBtn, playPauseBtn, nextBtn, volumeBtn],
    );
  },
),
```

**收藏逻辑统一封装**：

```dart
Future<void> _toggleFavorite(WidgetRef ref, AudioTrack track) async {
  if (track.songId <= 0) return; // 未入库的曲目无法收藏
  await ref.read(favoriteNotifierProvider.notifier).toggleFavorite(track.songId);
}
```

---

## 四、国际化（l10n）

### 新增 key

| Key | 中文 (`app_zh.arb`) | 英文 (`app_en.arb`) |
|-----|---------------------|---------------------|
| `myFavorites` | `我喜欢` | `My Favorites` |
| `addToFavorites` | `收藏` | `Add to Favorites` |
| `removeFromFavorites` | `取消收藏` | `Remove from Favorites` |
| `addedToFavorites` | `已添加到「我喜欢」` | `Added to My Favorites` |
| `removedFromFavorites` | `已从「我喜欢」移除` | `Removed from My Favorites` |
| `favoritesCannotDelete` | `「我喜欢」歌单不可删除` | `My Favorites playlist cannot be deleted` |
| `favoritesCannotRename` | `「我喜欢」歌单不可重命名` | `My Favorites playlist cannot be renamed` |

---

## 五、实现步骤（Task Checklist）

### Phase 1：数据层

- [ ] 1.1 `Playlists` 表添加 `isFavorite` 布尔列
- [ ] 1.2 `Playlist` 领域模型增加 `isFavorite` 字段 + 重新生成 Freezed 代码
- [ ] 1.3 `AppDatabase.schemaVersion` 升至 3，编写迁移逻辑
- [ ] 1.4 `PlaylistRepository` 接口新增 `getOrCreateFavorites` / `toggleFavorite` / `isFavorited` / `getFavoritedSongIds`
- [ ] 1.5 `PlaylistRepositoryImpl` 实现上述接口
- [ ] 1.6 `_mapPlaylist` 映射新增 `isFavorite` 字段

### Phase 2：状态管理层

- [ ] 2.1 新建 `favorite_notifier.dart`（含 `FavoriteNotifier`）
- [ ] 2.2 运行 `build_runner build` 生成代码

### Phase 3：UI 层

- [ ] 3.1 `SongTile` 新增 `isFavorited` / `onFavoritePressed` 参数，trailing 区域增加爱心按钮
- [ ] 3.2 `PlaylistDetailScreen` 接入收藏状态和切换逻辑
- [ ] 3.3 歌单列表页处理「我喜欢」歌单的特殊展示（置顶、图标、不可删除/重命名）
- [ ] 3.4 歌曲右键菜单 / BottomSheet 菜单增加「收藏/取消收藏」选项
- [ ] 3.5 `PlayerBar` 底部播放栏：新增爱心按钮 + `LayoutBuilder` 自适应布局（窄屏隐藏音质/时间/模式/音量，保留核心操作）
- [ ] 3.6 `FullPlayerScreen` 全屏播放页：顶部新增爱心按钮 + 底部控制区 `LayoutBuilder` 自适应（窄屏分两行）

### Phase 4：国际化与完善

- [ ] 4.1 `app_en.arb` + `app_zh.arb` 添加新增 key
- [ ] 4.2 重新生成 l10n 代码
- [ ] 4.3 导入导出/分享功能：`isFavorite` 不导出、不分享（纯本地状态）；备份导出时在 `BackupPlaylist` 中增加 `isFavorite` 字段以便恢复，导入时若本地已有收藏歌单则合并歌曲而不覆盖

### Phase 5：测试

- [ ] 5.1 数据库迁移测试（v2 → v3）
- [ ] 5.2 收藏/取消收藏功能测试
- [ ] 5.3 歌单列表特殊展示测试
- [ ] 5.4 真机调试验证

---

## 六、涉及文件清单

| 文件路径 | 改动类型 |
|----------|----------|
| `lib/core/database/tables/playlists.dart` | 修改 — 新增 `isFavorite` 列 |
| `lib/core/database/app_database.dart` | 修改 — schema v3 + 迁移 |
| `lib/features/playlist/domain/models/playlist.dart` | 修改 — 新增 `isFavorite` 字段 |
| `lib/features/playlist/data/playlist_repository.dart` | 修改 — 新增接口方法 |
| `lib/features/playlist/data/playlist_repository_impl.dart` | 修改 — 实现新接口 |
| `lib/features/playlist/application/playlist_notifier.dart` | 修改 — 删除歌单时检查 `isFavorite` |
| `lib/features/playlist/application/favorite_notifier.dart` | **新增** — 收藏状态管理 |
| `lib/shared/widgets/song_tile.dart` | 修改 — 新增爱心按钮 |
| `lib/features/playlist/presentation/playlist_detail_screen.dart` | 修改 — 接入收藏 |
| `lib/features/playlist/presentation/playlist_list_screen.dart` | 修改 — 特殊处理收藏歌单 |
| `lib/features/playlist/presentation/widgets/playlist_tile.dart` | 修改 — 收藏歌单特殊图标 |
| `lib/features/player/presentation/player_bar.dart` | 修改 — 新增爱心收藏按钮 |
| `lib/features/player/presentation/full_player_screen.dart` | 修改 — 新增爱心收藏按钮 |
| `lib/features/share/domain/models/app_backup.dart` | 修改 — `BackupPlaylist` 增加 `isFavorite` |
| `lib/l10n/app_en.arb` | 修改 — 新增 key |
| `lib/l10n/app_zh.arb` | 修改 — 新增 key |

---

## 七、注意事项

1. **AutoDispose 防回收**：`FavoriteNotifier.toggleFavorite` 内含异步操作修改 `state`，必须 `ref.keepAlive()`。
2. **不可破坏旧数据**：`isFavorite` 列有 `withDefault(false)`，迁移仅 `addColumn`，不影响已有数据。
3. **唯一性约束**：代码层面保证只有一个 `isFavorite = true` 的歌单，不在数据库层加 unique 约束（SQLite 不支持对布尔值的部分唯一索引）。
4. **分享不含收藏标记**：`SharedPlaylist`（剪贴板分享）不序列化 `isFavorite`，收藏状态为纯本地概念。`AppBackup`（全量备份/恢复）中的 `BackupPlaylist` 需增加 `isFavorite` 字段以便跨设备恢复，导入时若本地已有收藏歌单则仅合并歌曲，不重复创建。
5. **性能**：`getFavoritedSongIds` 使用 `isIn` 批量查询，避免逐个查询。歌单详情页加载后一次性获取该页所有歌曲的收藏状态。
6. **单引号**：项目强制 `prefer_single_quotes`。
7. **日志**：使用 `AppLogger`，禁止 `print`。
