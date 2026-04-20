# BuSic — 字幕歌词系统实施计划

> 对应 Issue: [#15 - [Feat] 实现基于字幕自动抓取、AI 字幕有关的歌词系统](https://github.com/GlowLED/BuSic/issues/15)  
> 前置研究: [`lyrics-research.md`](lyrics-research.md)  
> 日期: 2026-03  
> 状态: 实施计划

---

## 1. 功能概述

为 BuSic 全屏播放页面引入歌词/字幕显示系统，类似 QQ 音乐的歌词展示体验。

### 1.1 核心体验

- **全屏播放页 (FullPlayerScreen)** 竖屏模式下：
  - **第一页（默认）**：封面 + 歌曲信息（当前已有）
  - **下滑/第二页**：歌词字幕展示（新增）→ 上滑回到封面
  - **左滑**：评论系统（当前已有）
- 歌词**精确到行**（非逐字），当前播放行高亮 + 自动滚动
- 首次播放时后台获取歌词，获取后缓存到数据库
- 最多重试 **10 次**，重试耗尽后显示"暂无歌词"

### 1.2 交互模型

```
┌─────────────────────────────────────────────────┐
│           FullPlayerScreen (Portrait)            │
│                                                  │
│  ┌──────────── 竖向 PageView (新增) ──────────┐  │
│  │                                             │  │
│  │  ┌─ Page 0 (上) ──────────────────────────┐ │  │
│  │  │                                        │ │  │
│  │  │  ┌─ 横向 PageView (已有) ─────────────┐│ │  │
│  │  │  │ Page 0: 封面 + 歌曲信息            ││ │  │
│  │  │  │ Page 1: 评论区 (左滑进入)          ││ │  │
│  │  │  └────────────────────────────────────┘│ │  │
│  │  │                                        │ │  │
│  │  └────────────────────────────────────────┘ │  │
│  │                                             │  │
│  │  ┌─ Page 1 (下) ──────────────────────────┐ │  │
│  │  │                                        │ │  │
│  │  │  歌词/字幕展示区                       │ │  │
│  │  │  · 当前行高亮 + 自动滚动               │ │  │
│  │  │  · 点击歌词跳转播放位置                │ │  │
│  │  │  · 无歌词时显示占位提示                │ │  │
│  │  │                                        │ │  │
│  │  └────────────────────────────────────────┘ │  │
│  │                                             │  │
│  └─────────────────────────────────────────────┘  │
│                                                  │
│  [·] [·] 页面指示器（2 竖向页 + 横向指示器）     │
│  ═══════════ 进度条 ═══════════                   │
│  ◁  ▷  ▶  ▷  ◁   控制栏                          │
│                                                  │
└─────────────────────────────────────────────────┘
```

### 1.3 歌词页面 UI 细节

```
┌─────────────────────────────────────────────────┐
│                                                  │
│           (前面的歌词行，半透明灰色)              │
│                                                  │
│   ♪ 小时候的自己许很多心愿 ♪                      │ ← 歌词行
│   ♪ 天意是那么圆 ♪                                │
│                                                  │
│   ♪ 在蝴蝶飞过的季节里 ♪       ← 当前行 (高亮白) │ ← 高亮 + 加粗
│                                                  │
│   ♪ 你也曾是风中的少年 ♪                          │
│   ♪ 追着光和影 ♪                                  │
│                                                  │
│           (后面的歌词行，半透明灰色)              │
│                                                  │
└─────────────────────────────────────────────────┘
```

- 当前播放行居中显示，白色加粗字体
- 非当前行为半透明灰色
- 行间距适当（`height: 2.0`）方便阅读和点击
- 点击任意歌词行跳转到该行起始时间
- 无歌词时居中显示"暂无歌词"占位

---

## 2. 架构设计

### 2.1 Feature 模块结构

遵循项目 Feature-first + Lite DDD 架构，新增 `subtitle` feature：

```
lib/features/subtitle/
├── application/
│   ├── subtitle_notifier.dart          # Riverpod Notifier（核心业务逻辑）
│   ├── subtitle_notifier.g.dart        # codegen
│   └── subtitle_notifier.freezed.dart  # codegen
├── data/
│   ├── subtitle_repository.dart        # 接口定义
│   └── subtitle_repository_impl.dart   # 实现（API 调用 + 前缀验证 + 重试）
├── domain/
│   └── models/
│       ├── subtitle_line.dart          # 字幕行数据模型
│       ├── subtitle_line.freezed.dart  # codegen
│       ├── subtitle_data.dart          # 整首歌的字幕数据
│       └── subtitle_data.freezed.dart  # codegen
└── presentation/
    └── widgets/
        └── lyrics_panel.dart           # 歌词展示 Widget
```

### 2.2 数据流

```
┌────────────┐    bvid+cid    ┌─────────────────┐
│ PlayerState │ ──────────────→│ SubtitleNotifier │
│ (position)  │               │                  │
└─────┬───────┘               │ 1. 查 DB 缓存    │
      │                      │ 2. 无缓存 → API  │
      │ position stream       │ 3. 前缀验证       │
      │                      │ 4. 重试 ≤10次    │
      ▼                      │ 5. 缓存到 DB     │
┌─────────────┐              └────────┬──────────┘
│ LyricsPanel │ ←───── subtitle ──────┘
│  (Widget)   │    lines + position
│             │    → 计算 currentLine
│             │    → 自动滚动 + 高亮
└─────────────┘
```

---

## 3. 数据模型

### 3.1 SubtitleLine（单行字幕）

```dart
@freezed
class SubtitleLine with _$SubtitleLine {
  const factory SubtitleLine({
    /// 开始时间（秒）
    required double startTime,
    /// 结束时间（秒）
    required double endTime,
    /// 字幕文本内容
    required String content,
    /// 音乐占比（0.0 = 纯语音, 1.0 = 纯音乐/歌词）
    @Default(0.0) double musicRatio,
  }) = _SubtitleLine;

  factory SubtitleLine.fromJson(Map<String, dynamic> json) =>
      _$SubtitleLineFromJson(json);
}
```

### 3.2 SubtitleData（整首歌的字幕）

```dart
@freezed
class SubtitleData with _$SubtitleData {
  const factory SubtitleData({
    /// 字幕行列表（按时间排序）
    required List<SubtitleLine> lines,
    /// 字幕来源类型：'ai' | 'cc'
    required String sourceType,
    /// 字幕语言代码（如 'ai-zh', 'zh-Hans'）
    @Default('') String language,
  }) = _SubtitleData;

  factory SubtitleData.fromJson(Map<String, dynamic> json) =>
      _$SubtitleDataFromJson(json);
}
```

### 3.3 SubtitleState（Notifier 内部状态）

```dart
@freezed
class SubtitleState with _$SubtitleState {
  const factory SubtitleState({
    /// 字幕数据（null = 正在加载或无字幕）
    SubtitleData? subtitleData,
    /// 当前高亮行索引
    @Default(-1) int currentLineIndex,
    /// 加载状态
    @Default(SubtitleLoadStatus.idle) SubtitleLoadStatus status,
    /// 错误消息
    String? errorMessage,
  }) = _SubtitleState;
}

enum SubtitleLoadStatus {
  idle,       // 空闲
  loading,    // 正在获取
  loaded,     // 已加载
  notFound,   // 无字幕（重试耗尽）
  error,      // 获取出错
}
```

---

## 4. 数据库变更

### 4.1 新增 `Subtitles` 表

```dart
/// 字幕缓存表 — 每个 (bvid, cid) 最多一条记录
class Subtitles extends Table {
  /// 自增主键
  IntColumn get id => integer().autoIncrement()();

  /// B站 BV 号
  TextColumn get bvid => text().withLength(min: 1, max: 20)();

  /// B站 CID
  IntColumn get cid => integer()();

  /// 字幕数据 JSON（SubtitleData 序列化）
  TextColumn get subtitleJson => text()();

  /// 字幕来源类型：'ai' / 'cc'
  TextColumn get sourceType => text().withDefault(const Constant('ai'))();

  /// 创建时间（Unix 毫秒）
  IntColumn get createdAt => integer()();

  /// 唯一约束：同一视频分P只存一份字幕
  @override
  List<Set<Column>> get uniqueKeys => [{bvid, cid}];
}
```

### 4.2 迁移策略

```dart
// app_database.dart
@override
int get schemaVersion => 4;  // 从 3 → 4

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
      if (from < 4) {
        await m.createTable(subtitles);  // 新增字幕表
      }
    },
  );
}
```

---

## 5. Repository 层

### 5.1 SubtitleRepository 接口

```dart
abstract class SubtitleRepository {
  /// 获取字幕数据（先查缓存，未命中则从 API 获取）。
  ///
  /// [bvid] BV号, [cid] 分P标识。
  /// 返回 SubtitleData 或 null（无字幕）。
  Future<SubtitleData?> getSubtitle({
    required String bvid,
    required int cid,
  });

  /// 从 DB 缓存获取字幕。
  Future<SubtitleData?> getCachedSubtitle({
    required String bvid,
    required int cid,
  });

  /// 保存字幕到 DB 缓存。
  Future<void> cacheSubtitle({
    required String bvid,
    required int cid,
    required SubtitleData data,
  });

  /// 从 B 站 API 获取字幕（含前缀验证 + 重试）。
  ///
  /// [maxRetries] 最大重试次数，默认 10。
  Future<SubtitleData?> fetchSubtitleFromApi({
    required String bvid,
    required int cid,
    int maxRetries = 10,
  });
}
```

### 5.2 SubtitleRepositoryImpl 核心逻辑

```dart
class SubtitleRepositoryImpl implements SubtitleRepository {
  final BiliDio _biliDio;
  final AppDatabase _db;

  SubtitleRepositoryImpl({
    required BiliDio biliDio,
    required AppDatabase db,
  }) : _biliDio = biliDio, _db = db;

  @override
  Future<SubtitleData?> getSubtitle({
    required String bvid,
    required int cid,
  }) async {
    // 1. 先尝试从 DB 缓存获取
    final cached = await getCachedSubtitle(bvid: bvid, cid: cid);
    if (cached != null) return cached;

    // 2. 缓存未命中，从 API 获取
    final data = await fetchSubtitleFromApi(bvid: bvid, cid: cid);
    if (data != null) {
      // 3. 缓存到 DB
      await cacheSubtitle(bvid: bvid, cid: cid, data: data);
    }
    return data;
  }

  @override
  Future<SubtitleData?> fetchSubtitleFromApi({
    required String bvid,
    required int cid,
    int maxRetries = 10,
  }) async {
    // Step 1: 获取 aid（用于前缀验证）
    final aid = await _getAid(bvid);

    // Step 2: 重试循环
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // 2a. 调用 /x/player/v2 获取字幕列表
        final subtitles = await _getSubtitleList(bvid, cid);
        if (subtitles.isEmpty) {
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        // 2b. 寻找 AI 或 CC 字幕
        final target = _findBestSubtitle(subtitles);
        if (target == null) {
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        final subtitleUrl = target['subtitle_url'] as String;
        final isAi = subtitleUrl.contains('/bfs/ai_subtitle/');
        final sourceType = isAi ? 'ai' : 'cc';

        // 2c. AI 字幕前缀验证
        if (isAi && !_validateAiSubtitleUrl(subtitleUrl, aid, cid)) {
          AppLogger.debug(
            'Subtitle attempt $attempt: wrong prefix, retrying...',
            tag: 'Subtitle',
          );
          await Future.delayed(const Duration(milliseconds: 400));
          continue;
        }

        // 2d. 下载字幕内容
        final content = await _fetchSubtitleContent(subtitleUrl);
        if (content == null) continue;

        // 2e. 解析为 SubtitleData
        return _parseSubtitleContent(content, sourceType);
      } catch (e) {
        AppLogger.warning(
          'Subtitle attempt $attempt failed: $e',
          tag: 'Subtitle',
        );
        await Future.delayed(const Duration(milliseconds: 400));
      }
    }
    return null; // 重试耗尽
  }

  /// 验证 AI 字幕 URL 的路径前缀是否匹配 {aid}{cid}。
  bool _validateAiSubtitleUrl(String url, int aid, int cid) {
    final parsed = Uri.parse(url.startsWith('//') ? 'https:$url' : url);
    final match = RegExp(r'/bfs/ai_subtitle/prod/(\d+)')
        .firstMatch(parsed.path);
    if (match == null) return false;
    final pathPrefix = match.group(1)!;
    final expected = '$aid$cid';
    return pathPrefix.startsWith(expected);
  }
}
```

关键设计决策：
- **重试间隔 400ms**：避免触发 B 站风控（QPS ≤ 2.5）
- **最大重试 10 次**：大约 4 秒内完成，不让用户等待过久
- **前缀验证**：仅对 AI 字幕执行，CC 字幕无错配问题
- **aid 获取**：复用 `/x/web-interface/view` API（与 `getAidByBvid` 相同）

---

## 6. Application 层 (SubtitleNotifier)

```dart
@riverpod
class SubtitleNotifier extends _$SubtitleNotifier {
  @override
  SubtitleState build(String bvid, int cid) {
    // 触发异步加载
    _loadSubtitle();
    return const SubtitleState(status: SubtitleLoadStatus.loading);
  }

  Future<void> _loadSubtitle() async {
    final link = ref.keepAlive(); // 防止 AutoDispose 回收
    try {
      final repo = SubtitleRepositoryImpl(
        biliDio: BiliDio(),
        db: ref.read(appDatabaseProvider),
      );

      final data = await repo.getSubtitle(bvid: bvid, cid: cid);
      if (data != null) {
        state = SubtitleState(
          subtitleData: data,
          status: SubtitleLoadStatus.loaded,
        );
      } else {
        state = const SubtitleState(status: SubtitleLoadStatus.notFound);
      }
    } catch (e) {
      state = SubtitleState(
        status: SubtitleLoadStatus.error,
        errorMessage: e.toString(),
      );
    } finally {
      link.close();
    }
  }

  /// 根据当前播放位置更新高亮行。
  void updatePosition(Duration position) {
    final data = state.subtitleData;
    if (data == null) return;

    final posSeconds = position.inMilliseconds / 1000.0;
    final lines = data.lines;

    // 二分查找当前行
    var index = -1;
    for (var i = 0; i < lines.length; i++) {
      if (posSeconds >= lines[i].startTime && posSeconds < lines[i].endTime) {
        index = i;
        break;
      }
    }

    if (index != state.currentLineIndex) {
      state = state.copyWith(currentLineIndex: index);
    }
  }
}
```

Notifier 关键点：
- **Family 参数**：`(bvid, cid)`，每首歌独立实例
- **AutoDispose + keepAlive**：异步加载期间防回收，加载完毕后释放
- **位置更新**：由 `LyricsPanel` 监听 `playerNotifierProvider.position` 并调用 `updatePosition()`

---

## 7. Presentation 层

### 7.1 FullPlayerScreen 改造

当前结构：
```dart
// 横向 PageView: [封面页, 评论页]
PageView(children: [_buildCoverPage(), _buildCommentPage()])
```

改造为嵌套 PageView：
```dart
// 竖向 PageView（新增外层）
PageView(
  scrollDirection: Axis.vertical,
  children: [
    // Page 0 (上): 原有内容
    PageView(  // 横向（已有）
      children: [_buildCoverPage(), _buildCommentPage()],
    ),
    // Page 1 (下): 歌词页面（新增）
    _buildLyricsPage(),
  ],
)
```

页面指示器扩展为支持两个维度（或简化为底部小点）。

### 7.2 LyricsPanel Widget

```dart
class LyricsPanel extends ConsumerStatefulWidget {
  final String bvid;
  final int cid;
  const LyricsPanel({required this.bvid, required this.cid, super.key});
}

class _LyricsPanelState extends ConsumerState<LyricsPanel> {
  final ScrollController _scrollController = ScrollController();
  bool _userScrolling = false;  // 用户手动滚动时暂停自动滚动

  @override
  Widget build(BuildContext context) {
    final subtitleState = ref.watch(
      subtitleNotifierProvider(widget.bvid, widget.cid),
    );
    final position = ref.watch(
      playerNotifierProvider.select((s) => s.position),
    );

    // 根据播放位置更新当前行
    ref.read(subtitleNotifierProvider(widget.bvid, widget.cid).notifier)
        .updatePosition(position);

    return switch (subtitleState.status) {
      SubtitleLoadStatus.loading => _buildLoading(),
      SubtitleLoadStatus.notFound => _buildNoLyrics(),
      SubtitleLoadStatus.error => _buildError(subtitleState.errorMessage),
      SubtitleLoadStatus.loaded => _buildLyrics(subtitleState),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLyrics(SubtitleState state) {
    final lines = state.subtitleData!.lines;
    final currentIndex = state.currentLineIndex;

    // 自动滚动到当前行
    if (!_userScrolling && currentIndex >= 0) {
      _scrollToIndex(currentIndex);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification) {
          _userScrolling = notification.direction != ScrollDirection.idle;
          // 用户松手 3 秒后恢复自动滚动
          if (!_userScrolling) {
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) setState(() => _userScrolling = false);
            });
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 120),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          final isCurrent = index == currentIndex;
          return GestureDetector(
            onTap: () => _seekToLine(line),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32, vertical: 12,
              ),
              child: Text(
                line.content,
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.white38,
                  fontSize: isCurrent ? 20 : 16,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  void _seekToLine(SubtitleLine line) {
    ref.read(playerNotifierProvider.notifier).seekTo(
      Duration(milliseconds: (line.startTime * 1000).round()),
    );
  }

  void _scrollToIndex(int index) {
    // 使用 animateTo 平滑滚动到目标位置
    // 估算每行高度约 54px（16px 字号 + 24px padding）
    final targetOffset = index * 54.0;
    final viewportHeight = _scrollController.position.viewportDimension;
    final centeredOffset = targetOffset - viewportHeight / 2 + 27;

    _scrollController.animateTo(
      centeredOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
```

---

## 8. 国际化 (L10n)

需要新增的字符串键：

| Key | 中文 | 英文 |
|-----|------|------|
| `lyricsTitle` | 歌词 | Lyrics |
| `noLyrics` | 暂无歌词 | No lyrics available |
| `lyricsLoading` | 歌词加载中... | Loading lyrics... |
| `lyricsError` | 歌词加载失败 | Failed to load lyrics |
| `lyricsRetrying` | 正在获取歌词 ({current}/{total}) | Fetching lyrics ({current}/{total}) |

---

## 9. 实施步骤

### Phase 1: 数据层基础（预计 1-2h）

| # | 任务 | 文件 | 要点 |
|---|------|------|------|
| 1.1 | 创建 `SubtitleLine` Freezed 模型 | `lib/features/subtitle/domain/models/subtitle_line.dart` | `startTime`, `endTime`, `content`, `musicRatio` |
| 1.2 | 创建 `SubtitleData` Freezed 模型 | `lib/features/subtitle/domain/models/subtitle_data.dart` | `lines`, `sourceType`, `language` |
| 1.3 | 新增 `Subtitles` Drift 表 | `lib/core/database/tables/subtitles.dart` | `bvid+cid` 唯一约束 |
| 1.4 | 注册表 + 迁移 | `lib/core/database/app_database.dart` | `schemaVersion: 4`，`from < 4 → createTable` |
| 1.5 | 运行 `build_runner` | 终端 | 生成 `.g.dart` 和 `.freezed.dart` |

### Phase 2: Repository 层（预计 1-2h）

| # | 任务 | 文件 | 要点 |
|---|------|------|------|
| 2.1 | 创建 `SubtitleRepository` 接口 | `lib/features/subtitle/data/subtitle_repository.dart` | 定义 `getSubtitle`、`fetchSubtitleFromApi`、缓存方法 |
| 2.2 | 实现 `SubtitleRepositoryImpl` | `lib/features/subtitle/data/subtitle_repository_impl.dart` | API 调用 + 前缀验证 + 重试逻辑 + DB 缓存 |

### Phase 3: Application 层（预计 30min）

| # | 任务 | 文件 | 要点 |
|---|------|------|------|
| 3.1 | 创建 `SubtitleNotifier` | `lib/features/subtitle/application/subtitle_notifier.dart` | `@riverpod` Family `(bvid, cid)`，异步加载 + 行高亮计算 |
| 3.2 | 运行 `build_runner` | 终端 | 生成 Riverpod codegen |

### Phase 4: Presentation 层（预计 2-3h）

| # | 任务 | 文件 | 要点 |
|---|------|------|------|
| 4.1 | 创建 `LyricsPanel` Widget | `lib/features/subtitle/presentation/widgets/lyrics_panel.dart` | 歌词列表 + 高亮 + 自动滚动 + 点击跳转 |
| 4.2 | 改造 `FullPlayerScreen` | `lib/features/player/presentation/full_player_screen.dart` | 嵌套竖向 PageView，封面/歌词上下切换 |
| 4.3 | 更新页面指示器 | 同上 | 支持竖向+横向双维度指示 |
| 4.4 | 添加 L10n 字符串 | `lib/l10n/app_zh.arb` + `app_en.arb` | 歌词相关文案 |

### Phase 5: 测试与优化（预计 1h）

| # | 任务 | 说明 |
|---|------|------|
| 5.1 | 真机测试 3 首歌曲 | BV1A14Se6EHy / BV1Fsb5zeEmq / BV1QG4y1D7QA |
| 5.2 | 测试无字幕场景 | 验证 notFound 状态显示 |
| 5.3 | 测试缓存命中 | 二次播放应立即加载 |
| 5.4 | 测试滑动手势 | 上下滑歌词 + 左右滑评论无冲突 |
| 5.5 | 性能优化 | 确保滚动流畅、无不必要的 rebuild |

---

## 10. 关键技术决策

### 10.1 aid 获取策略

当前项目中 `AudioTrack` 和 `Songs` 表均**不存储 `aid`**。字幕前缀验证需要 `aid`。

**方案**：在 `SubtitleRepositoryImpl` 中调用 `/x/web-interface/view?bvid={bvid}` 获取 `aid`（复用与 `CommentRepositoryImpl.getAidByBvid()` 相同的逻辑）。此调用仅在 API 获取字幕时需要，缓存命中时不触发。

> 未来优化：考虑在 `Songs` 表和 `AudioTrack` 模型中增加 `aid` 字段，避免重复请求。

### 10.2 字幕内容过滤

AI 字幕返回的 `body` 中，`music` 字段表示音乐占比：
- `music >= 0.5` 的行视为歌词行
- `music < 0.5` 的行为解说/对白

**策略**：默认展示所有行，但用 `musicRatio` 标注每行，UI 层可选择性过滤。如果歌词行占比过低（< 30%），视为"非音乐视频"，在 UI 上提示"该视频可能不是音乐视频"。

### 10.3 字幕文本清洗

AI 字幕文本可能带有 `♪` 符号：
- `♪ 歌词内容 ♪` → 保留，这是正常歌词格式
- 去除首尾空白
- 过滤空内容行

### 10.4 竖向 PageView 手势冲突处理

嵌套 PageView（外层 vertical + 内层 horizontal）可能引发手势冲突。

**方案**：
- 外层 `PageView` 设置 `physics: const ClampingScrollPhysics()`
- 内层 `PageView` 使用默认 `BouncingScrollPhysics`
- 歌词页的 `ListView` 需要消费纵向滑动手势——当用户在歌词页内上下滑动浏览歌词时，不应触发外层 PageView 切换
- 仅在歌词页顶部/底部边界时，才允许外层 PageView 接管

### 10.5 性能考量

- `position` 流更新频率约 10-15Hz → `updatePosition()` 需要轻量（仅比较+更新 index）
- `LyricsPanel` 使用 `select` 仅监听 `position` 而非整个 `PlayerState`
- 字幕 JSON 缓存到 DB 后用 `jsonDecode` 一次性反序列化，不做惰性加载
- 大多数歌曲字幕行数 < 200，内存开销可以忽略

---

## 11. 风险与缓解措施

| 风险 | 影响 | 缓解 |
|------|------|------|
| B 站 API `/x/player/v2` 返回错误字幕 URL | 需多次重试 | 前缀验证 + 最多 10 次重试 |
| SESSDATA 过期导致无法获取字幕 | 字幕列表返回空 | 检测并提示用户重新登录 |
| 嵌套 PageView 手势冲突 | 滑动体验差 | 合理配置 physics + 手势竞争 |
| 部分视频无 AI 字幕 | 用户看到空状态 | 友好的"暂无歌词"提示 |
| 字幕 URL auth_key 过期 | 下载失败 | 每次重试获取新 URL |
| 加载延迟（重试 10 次 ≈ 4-8s） | 用户等待 | 显示加载进度 + 后台预加载 |

---

## 12. 未来扩展

1. **预加载**：播放队列中的下一首歌提前获取字幕
2. **手动搜索歌词**：支持输入歌名从外部 API 搜索歌词
3. **歌词编辑**：允许用户手动修正 AI 识别错误
4. **横屏歌词**：Wide layout 下在右侧面板显示歌词
5. **歌词翻译**：同时显示多语言字幕（B 站有 `ai_type=1` 的翻译字幕）
6. **桌面端歌词窗口**：独立的歌词悬浮窗

---

*本计划基于 [`lyrics-research.md`](lyrics-research.md) 的研究结论和 2026-03 最新测试结果制定。*
