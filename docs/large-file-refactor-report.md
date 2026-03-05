# 大文件拆分重构报告

> 生成日期：2026-03-05
> 筛选标准：`lib/` 下非生成文件（排除 `.g.dart` / `.freezed.dart` / `generated/`），行数 > 400

## 概览

| # | 文件 | 行数 | 主要职责 |
|---|---|---:|---|
| 1 | `lib/features/playlist/presentation/playlist_detail_screen.dart` | 902 | 歌单详情页（列表 + 批量操作 + 单曲菜单 + 下载） |
| 2 | `lib/features/search_and_parse/presentation/search_screen.dart` | 871 | 搜索/解析页（搜索 + 分页 + 视频详情 + 下载） |
| 3 | `lib/features/player/presentation/full_player_screen.dart` | 801 | 全屏播放器（横竖屏双布局 + 评论 + 进度条 + 控制按钮） |
| 4 | `lib/features/playlist/presentation/widgets/bili_fav_import_dialog.dart` | 642 | B 站收藏夹导入向导（6 阶段状态机 + 对应 UI） |
| 5 | `lib/features/player/application/player_notifier.dart` | 618 | 播放器状态管理（播放控制 + 队列 + 持久化 + 媒体会话） |
| 6 | `lib/features/settings/presentation/settings_screen.dart` | 556 | 设置页（外观 / 语言 / 播放 / 账户 / 数据 / 关于） |
| 7 | `lib/features/download/data/download_repository_impl.dart` | 463 | 下载仓库实现（下载引擎 + 断点续传 + 响应式流） |

---

## 逐文件分析与拆分建议

### 1. playlist_detail_screen.dart (902 行)

**现状**：单个 StatefulWidget 承担了歌单详情展示、批量选择编辑、单曲右键菜单、下载音质选择、播放触发等全部职责。末尾还内嵌了 `_PlaylistPickerDialog`（与 search_screen 重复）。

**拆分方案**：

| 提取目标 | 来源 | 目标路径 |
|---|---|---|
| `PlaylistPickerDialog` | `_PlaylistPickerDialog` (~90 行) | `lib/shared/widgets/playlist_picker_dialog.dart` |
| `SongContextMenu` | `_showSongMenu()` (~100 行) | `lib/shared/widgets/song_context_menu.dart` |
| `BatchActionBar` | `_buildBatchActionBar()` + 选中状态管理 (~120 行) | `widgets/batch_action_bar.dart` 或 mixin |
| `DownloadQualityDialog` | `_showQualityDialog()` + `_downloadAllUncached()` (~140 行) | `widgets/download_quality_dialog.dart` |

**预期效果**：主文件 ≈ 450 行，提取 4 个可复用组件。

---

### 2. search_screen.dart (871 行)

**现状**：搜索输入 + 结果列表 + 分页 + 视频详情卡片 + 播放/下载操作全部堆在一个 Widget 中。分页组件代码 ~170 行，视频详情 ~180 行。末尾 `_PlaylistPickerDialog` 与 playlist_detail_screen 完全重复。

**拆分方案**：

| 提取目标 | 来源 | 目标路径 |
|---|---|---|
| `PaginationBar` | `_buildPaginationBar` 及 5 个辅助方法 (~170 行) | `widgets/pagination_bar.dart` |
| `VideoDetailCard` | `_buildVideoDetail` + `_buildPageSelection` (~180 行) | `widgets/video_detail_card.dart` |
| `PlaylistPickerDialog` | 与文件 1 共享 | `lib/shared/widgets/playlist_picker_dialog.dart` |

**预期效果**：主文件 ≈ 430 行 → 进一步通过提取播放/下载辅助方法可降至 350 行。

---

### 3. full_player_screen.dart (801 行)

**现状**：竖屏 `build()` 方法 320 行，横屏 `_buildWideLayout()` 306 行。**大量代码重复**——进度条（SliderTheme + Slider + 时间标签）、控制按钮行（模式/上一首/播放暂停/下一首/音量）在两个布局中几乎逐行复制。

**拆分方案**：

| 提取目标 | 消除重复 | 目标路径 |
|---|---|---|
| `PlayerSeekBar` | 进度条 + 时间标签 (~60 行 × 2) | `widgets/player_seek_bar.dart` |
| `PlayerControls` | 播放模式 + 切歌 + 播放暂停 (~50 行 × 2) | `widgets/player_controls.dart` |
| `PlayerAppBar` | 收藏 + 队列 + 返回按钮 (~50 行 × 2) | `widgets/player_app_bar.dart` |
| `CoverImage` | `_buildBackgroundCover` + `_buildMainCover` (~40 行) | `widgets/cover_image.dart` |
| `VolumeSheet` | `_showVolumeSheet` (~30 行) | `widgets/volume_sheet.dart` |

**预期效果**：主文件 ≈ 200 行（仅编排横竖屏布局骨架），提取 5 个通用子组件。

---

### 4. bili_fav_import_dialog.dart (642 行)

**现状**：通过 `_Phase` 枚举管理 6 个阶段的 UI，每个阶段的 `_build*()` 方法 + 业务逻辑都在单文件。

**拆分方案**：

| 提取目标 | 来源 | 目标路径 |
|---|---|---|
| `BiliFavFolderListView` | `_buildFolderList` (~60 行) | `widgets/bili_fav_folder_list.dart` |
| `BiliFavPreviewView` | `_buildPreview` (~90 行) | `widgets/bili_fav_preview.dart` |
| `BiliFavProgressView` | `_buildImporting` + `_buildCompleted` (~60 行) | `widgets/bili_fav_progress.dart` |
| `BiliFavErrorView` | `_buildError` + `_buildErrorContent` (~50 行) | `widgets/bili_fav_error.dart` |

**预期效果**：主文件保留 ~380 行（骨架 + Phase 路由 + 业务方法），4 个纯展示子组件。

---

### 5. player_notifier.dart (618 行)

**现状**：播放控制、队列管理、状态持久化、媒体会话更新全部混在一个 Notifier 中。`resume()` / `next()` / `previous()` 中流 URL 解析逻辑重复 4 处。

**拆分方案**：

| 提取目标 | 来源 | 目标路径 |
|---|---|---|
| 消除内部重复 | 4 处 "检查 localPath → 解析 stream" | 提取为 `_ensurePlayable(AudioTrack)` 方法 |
| `PlayerStatePersistence` | `_persistState` + `_restoreState` (~80 行) | `player_state_persistence.dart` 或 mixin |
| `PlayerQueueManager` | `addToQueue` / `removeFromQueue` / `reorderQueue` / `_getNextIndex` (~70 行) | `player_queue_manager.dart` |
| `PlayerMediaSession` | `_updateMediaSession` + handler 接线 (~50 行) | `player_media_session.dart` 或 mixin |

**预期效果**：主 Notifier ≈ 380 行，职责聚焦于播放控制。

---

### 6. settings_screen.dart (556 行)

**现状**：`build()` 方法用 `ListView` 顺序排列 6 个设置类别，所有 UI 和逻辑写在同一个 Widget。

**拆分方案**：

| 提取目标 | 来源 | 目标路径 |
|---|---|---|
| `AppearanceSection` | 主题 + 配色 (~50 行) | `widgets/appearance_section.dart` |
| `PlaybackSection` | 音质选择 (~35 行) | `widgets/playback_section.dart` |
| `AccountSection` | 登录/登出 (~60 行) | `widgets/account_section.dart` |
| `DataManagementSection` | 备份导入导出 (~90 行) | `widgets/data_management_section.dart` |
| `AboutSection` | 版本/更新/关注 (~80 行) | `widgets/about_section.dart` |
| `CachePathTile` | 已是独立 Widget (~130 行) | `widgets/cache_path_tile.dart` |
| `pickDirectory()` | 顶层函数 (~20 行) | `lib/core/utils/directory_picker.dart` |

**预期效果**：主文件 ≈ 100 行（仅组装各 Section），7 个独立模块。

---

### 7. download_repository_impl.dart (463 行)

**现状**：下载指标计算、HTTP 下载引擎、数据库操作、响应式流查询全部在一个实现类中。核心 `_downloadFile()` 方法 155 行。

**拆分方案**：

| 提取目标 | 来源 | 目标路径 |
|---|---|---|
| `DownloadMetrics` | `_DownloadMetrics` 类 (~25 行) | `download_metrics.dart` |
| `DownloadEngine` | `_downloadFile` + Range/流处理 (~155 行) | `download_engine.dart` |
| 响应式流方法 | `watchTask` / `watchAllTasks` / `_getAllTasksWithFileSize` (~50 行) | 考虑保留或提取到 DAO |

**预期效果**：主文件 ≈ 270 行，下载引擎独立且可测试。

---

## 跨文件重复代码

| 重复代码 | 涉及文件 | 建议 |
|---|---|---|
| `_PlaylistPickerDialog` | `playlist_detail_screen.dart` · `search_screen.dart` | → `lib/shared/widgets/playlist_picker_dialog.dart` |
| 下载音质选择流程 | `playlist_detail_screen.dart` · `search_screen.dart` | → 共享 utility 或 mixin |
| 进度条 + 控制按钮 | `full_player_screen.dart` 内横竖屏 | → Widget 提取消除重复 |
| 流 URL 解析逻辑 | `player_notifier.dart` 内 4 处 | → `_ensurePlayable()` 方法 |

---

## 优先级建议

| 优先级 | 文件 | 理由 |
|---|---|---|
| P0 | `full_player_screen.dart` | 横竖屏代码重复最严重，维护风险最高 |
| P0 | `playlist_detail_screen.dart` + `search_screen.dart` | 存在跨文件重复组件，阻塞后续开发 |
| P1 | `player_notifier.dart` | 内部逻辑重复 + 职责混杂，影响稳定性 |
| P1 | `settings_screen.dart` | 拆分简单，收益明确 |
| P2 | `bili_fav_import_dialog.dart` | 可独立迭代，优先级稍低 |
| P2 | `download_repository_impl.dart` | 核心稳定运行中，拆分收益适中 |
