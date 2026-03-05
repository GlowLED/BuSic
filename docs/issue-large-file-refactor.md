<!-- 
  GitHub Issue 草稿
  仓库：GlowLED/BuSic
  标签建议：refactor, tech-debt
  里程碑：可选绑定到下一个 minor 版本
-->

# 拆分重构：7 个超大源文件（>400 LOC）

## 背景

项目中有 7 个非生成源文件超过 400 行，部分文件存在跨文件重复代码、单 Widget 职责过重、横竖屏逻辑逐行复制等问题，增加了维护成本和 bug 风险。

详细分析报告见 [`docs/large-file-refactor-report.md`](https://github.com/GlowLED/BuSic/blob/main/docs/large-file-refactor-report.md)。

## 涉及文件

| 文件 | 行数 | 核心问题 |
|---|---:|---|
| `playlist_detail_screen.dart` | 902 | 单曲菜单、批量操作、下载选择等全部内联；`_PlaylistPickerDialog` 与 search_screen 重复 |
| `search_screen.dart` | 871 | 分页组件 170 行、视频详情 180 行未提取；`_PlaylistPickerDialog` 重复 |
| `full_player_screen.dart` | 801 | 横竖屏布局代码**逐行重复**（进度条、控制按钮各复制一份） |
| `bili_fav_import_dialog.dart` | 642 | 6 阶段 UI 全部内嵌在单个 StatefulWidget |
| `player_notifier.dart` | 618 | 播放控制 + 队列管理 + 持久化 + 媒体会话混合；流 URL 解析逻辑重复 4 处 |
| `settings_screen.dart` | 556 | 6 个无关设置类别写在同一个 build() |
| `download_repository_impl.dart` | 463 | 下载引擎 155 行、指标计算、响应式流、DB 操作混合 |

## 任务清单

### P0 — 高优先级

- [ ] **`full_player_screen.dart`**：提取 `PlayerSeekBar`、`PlayerControls`、`PlayerAppBar`、`CoverImage`、`VolumeSheet`，消除横竖屏代码重复，主文件目标 ≤ 200 行
- [ ] **`playlist_detail_screen.dart` + `search_screen.dart`**：
  - 将重复的 `_PlaylistPickerDialog` 合并至 `lib/shared/widgets/playlist_picker_dialog.dart`
  - 提取 `SongContextMenu`（单曲右键菜单）
  - 提取 `PaginationBar`（分页组件）
  - 提取 `VideoDetailCard`（视频详情卡片）
  - 提取 `DownloadQualityDialog`（下载音质选择）

### P1 — 中优先级

- [ ] **`player_notifier.dart`**：
  - 消除 4 处重复的流 URL 解析 → `_ensurePlayable()` 方法
  - 提取 `PlayerStatePersistence`（持久化 mixin）
  - 提取 `PlayerQueueManager`（队列管理）
  - 提取 `PlayerMediaSession`（媒体会话）
- [ ] **`settings_screen.dart`**：按设置类别拆分为 `AppearanceSection`、`PlaybackSection`、`AccountSection`、`DataManagementSection`、`AboutSection`、`CachePathTile`

### P2 — 低优先级

- [ ] **`bili_fav_import_dialog.dart`**：按 Phase 拆分 UI 为 `BiliFavFolderListView`、`BiliFavPreviewView`、`BiliFavProgressView`、`BiliFavErrorView`
- [ ] **`download_repository_impl.dart`**：提取 `DownloadMetrics`、`DownloadEngine`

## 跨文件重复代码（同步处理）

- [ ] `_PlaylistPickerDialog` 重复（playlist_detail_screen ↔ search_screen）
- [ ] 下载音质选择流程重复（playlist_detail_screen ↔ search_screen）
- [ ] 流 URL 解析逻辑重复（player_notifier 内 4 处）
- [ ] 横竖屏进度条 + 控制按钮重复（full_player_screen 内）

## 约束

- 每次 PR 只处理一个文件的拆分，便于 review
- 拆分后必须通过 `flutter analyze` 零 issue
- 不改变现有功能行为，纯结构重构
