# Agent Quickstart

这份文档给**清空上下文的 agent**用，目标是在最短时间内恢复对 BuSic 的有效认知。

## 30 秒项目画像

- 仓库：Bilibili 音乐播放器，重点能力是播放、歌单、下载、分享/备份、字幕歌词、评论、应用更新。
- 当前版本：`pubspec.yaml` 中 `version: 0.3.8+14`
- 更新系统真源：`versions-manifest.json`
- 架构：`core / features / shared / l10n`
- 路由：`StatefulShellRoute.indexedStack`
- 数据库：Drift SQLite，`schemaVersion = 4`
- 后台播放：`media_kit + audio_service`

## 先看哪几个文件

1. `lib/main.dart`
2. `lib/app.dart`
3. `lib/core/router/app_router.dart`
4. `lib/core/database/app_database.dart`
5. `lib/core/api/bili_dio.dart`
6. `lib/shared/widgets/responsive_scaffold.dart`
7. `versions-manifest.json`
8. `.github/workflows/ci.yml`
9. `.github/workflows/release.yml`

## 当前 feature 地图

- `player`：播放队列、恢复、媒体会话、离线优先播放
- `playlist`：歌单 CRUD、本地元数据、自定义封面、“我喜欢”、收藏夹导入
- `search_and_parse`：搜索、BV 解析、音频流 URL
- `download`：下载任务、缓存联动、音质替换 / 去重
- `auth`：扫码登录、Cookie 登录、会话持久化
- `share`：剪贴板分享、完整备份导入导出
- `subtitle`：歌词 / 字幕获取、缓存、显示
- `comment`：评论列表、楼中楼、回复、点赞
- `app_update`：更新检查、下载、校验、安装
- `minimal`：极简模式页面和专用播放行为

## BuSic 特有规则

- **不要假设 Cookie 可交给 Dart 的 `Cookie` 类解析。**
  `SESSDATA` 含逗号，当前实现用 raw header 注入。

- **不要把 `pubspec.yaml` 当成更新系统唯一真源。**
  当前主真源是 `versions-manifest.json`，`x_update` 只是 fallback。

- **不要把歌词获取当作稳定 REST 流程。**
  `/x/player/v2` 返回的 AI 字幕 URL 可能错配，当前实现依赖 aid+cid 前缀验证和重试。

- **不要假设下载状态只在 `download_tasks` 表。**
  下载成功后还会回写 `songs.localPath` 和 `songs.audioQuality`，播放器依赖这两个字段离线优先播放。

- **不要把本地路径带入分享 / 备份。**
  分享与备份故意只保留可跨设备重建的数据，避免导入无效路径。

- **不要忽略桌面端关闭行为。**
  自定义标题栏的关闭按钮和窗口关闭事件默认是“隐藏到托盘”，不是退出。

- **不要在极简模式里随意改生命周期逻辑。**
  它刻意不在 `paused/resumed` 干预播放，只在 `detached` 彻底停止。

## 改某类问题时先读哪里

- B站 API / 登录 / Cookie / WBI / 评论 / 收藏夹：
  [../10-project/bilibili-integration.md](../10-project/bilibili-integration.md)

- 下载 / 本地缓存 / 离线优先：
  [../10-project/project-specific-rules.md](../10-project/project-specific-rules.md)

- 歌词 / 字幕：
  [../10-project/subtitle-and-lyrics.md](../10-project/subtitle-and-lyrics.md)

- 更新系统 / Release / 蓝奏云：
  [../10-project/update-system.md](../10-project/update-system.md)

- 桌面 / 托盘 / 极简模式 / 壳层导航：
  [../10-project/ui-and-platform-quirks.md](../10-project/ui-and-platform-quirks.md)

## 最常用验证命令

```bash
flutter analyze --no-fatal-infos
flutter test
flutter run -d windows
flutter devices
```

如果改了 `@riverpod`、`@freezed`、Drift 或 ARB：

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Agent 沙箱与提权

2026-04-21 在当前 Windows PowerShell agent 环境的实测结论：

- 可先在沙箱内尝试：`git status`、`git log`、`git diff`
- 通常需要提权到沙箱外：所有 `flutter ...` 命令，包括 `flutter pub get`、`flutter analyze --no-fatal-infos`、`flutter test`、`flutter run -d windows`、`flutter devices`、`flutter gen-l10n`
- 通常需要提权到沙箱外：文档里常见的 `dart ...` 包装入口，尤其 `dart run build_runner build --delete-conflicting-outputs`
- 预期需要提权：远程 Git 和写入型 Git，例如 `git ls-remote`、`git fetch`、`git pull`、`git push`、`git add`、`git commit`、切分支、改 tag、改 ref
- 不要把这条规则写成跨平台绝对结论；这里只描述当前仓库在当前 agent 环境里的经验值

原因只记关键事实：

- `flutter` / `dart` 包装入口在沙箱内会超时或卡在工具引导阶段；绕过包装层直跑 Flutter tool 时，沙箱内复现过 `CreateFile failed 5` 和 `where aapt` 访问失败
- 同一批命令提权后可正常执行：`git ls-remote origin HEAD` 成功，`flutter analyze --no-fatal-infos` 于 2026-04-21 复测约 26.2s 通过，`flutter test` 同日复测通过
- 如果只是想确认 Dart VM 是否可用，直连 `D:\flutter\bin\cache\dart-sdk\bin\dart.exe` 的只读帮助/版本命令在沙箱内可运行；但主线文档默认仍使用 `dart ...`，因此对 agent 的默认建议仍是先预期提权

完整的测试目录、维护规则和当前覆盖现状见：

- [../20-workflows/testing-guide.md](../20-workflows/testing-guide.md)

## 哪些旧文档不要直接当真

- `90-archive/historical-design/design.md`
- `90-archive/historical-design/pro-struc.md`
- `90-archive/feature-plans/*.md`

它们只保留设计背景和历史方案，**不能直接当作当前实现真源**。

## 下一步

如果你要继续深入：

1. [../10-project/project-overview.md](../10-project/project-overview.md)
2. [../10-project/project-specific-rules.md](../10-project/project-specific-rules.md)
3. [../30-reference/source-of-truth.md](../30-reference/source-of-truth.md)
4. [../20-workflows/testing-guide.md](../20-workflows/testing-guide.md)
