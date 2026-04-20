# BuSic 开发工作流

这份文档只描述 **BuSic 当前推荐的开发顺序**。它不是 Flutter 通用教程，而是帮助你在本项目里少走弯路。

## 1. 开始前先读什么

默认阅读顺序：

1. [../00-start-here/agent-quickstart.md](../00-start-here/agent-quickstart.md)
2. [../10-project/project-overview.md](../10-project/project-overview.md)
3. [../10-project/project-specific-rules.md](../10-project/project-specific-rules.md)
4. [../30-reference/source-of-truth.md](../30-reference/source-of-truth.md)

如果改的是特化系统，再补读对应专题：

- B 站接口、Cookie、WBI、评论、收藏夹： [../10-project/bilibili-integration.md](../10-project/bilibili-integration.md)
- 字幕、歌词、缓存、重试： [../10-project/subtitle-and-lyrics.md](../10-project/subtitle-and-lyrics.md)
- 分享、备份、跨设备导入： [../10-project/share-and-backup.md](../10-project/share-and-backup.md)
- 更新系统、Manifest、发布资产： [../10-project/update-system.md](../10-project/update-system.md)
- 桌面端、托盘、极简模式、壳层差异： [../10-project/ui-and-platform-quirks.md](../10-project/ui-and-platform-quirks.md)

## 2. 先确认改动属于哪一类

### 2.1 纯实现改动

满足以下条件时，通常不需要先写规划文档：

- 单个 feature 内的小改动
- 不涉及数据库迁移
- 不涉及多系统联动
- 不改变分享、更新、字幕、桌面生命周期等关键约束

### 2.2 需要先写规划文档

满足以下任一条件时，先在 [../40-feature-plans/](../40-feature-plans/) 新建规划文档：

- 涉及多个 feature 联动
- 涉及数据库结构、导入导出协议、更新协议
- 涉及播放器主链路
- 需要分阶段落地
- 当前知识还不能直接沉淀成稳定文档

规划文档模板见 [../40-feature-plans/TEMPLATE.md](../40-feature-plans/TEMPLATE.md)。

## 3. 先定位真源，再写代码

不要从旧文档倒推实现。先确认 source of truth：

- 启动与依赖注入：`lib/main.dart`
- App 壳层与更新检查：`lib/app.dart`
- 路由：`lib/core/router/app_router.dart`
- 数据库与迁移：`lib/core/database/app_database.dart`
- B 站 HTTP 行为：`lib/core/api/bili_dio.dart`
- 播放器行为：`lib/features/player/application/player_notifier.dart`
- 下载回写：`lib/features/download/data/download_repository_impl.dart`
- 分享 / 备份协议：`lib/features/share/data/share_repository_impl.dart`
- 完整备份导入：`lib/features/share/data/sync_repository_impl.dart`
- 字幕链路：`lib/features/subtitle/data/subtitle_repository_impl.dart`
- 桌面壳层：`lib/shared/widgets/responsive_scaffold.dart`

## 4. 推荐实现顺序

### 4.1 先改数据与协议

如果改动涉及数据结构、远端协议或缓存契约，先处理这些内容：

- Drift 表结构与迁移
- Repository 接口与实现
- JSON 模型 / Freezed 模型
- 分享或备份协议
- 更新 Manifest 或下载资产命名

常见约束：

- 歌曲唯一身份是 `bvid + cid`
- `Songs.id` 只是本地主键，不能拿来做跨设备标识
- 下载成功后必须回写 `songs.localPath` 和 `songs.audioQuality`
- 分享 / 备份故意不带本地文件路径
- `versions-manifest.json` 与应用内更新逻辑必须保持一致

### 4.2 再改业务编排

在 `application/` 层整理状态和联动：

- UI 只通过 Provider 访问业务层
- 业务编排放在 Notifier
- 后台持续行为优先用 `keepAlive`
- 跨 feature 联动优先用信号 Provider 或明确的依赖注入

### 4.3 最后改 UI 与路由

当数据和编排已经稳定，再处理：

- Screen / Widget
- `ResponsiveScaffold` 适配
- `app_router.dart` 路由接入
- 极简模式、桌面端标题栏、托盘行为

## 5. 特化系统的联动检查

### 5.1 改数据库

至少检查：

- `lib/core/database/tables/`
- `lib/core/database/app_database.dart`
- 对应 Repository 映射逻辑
- 是否需要更新文档中的 schema / 迁移说明

必做动作：

1. 更新 Table
2. 更新 `AppDatabase`
3. 递增 `schemaVersion`
4. 写 `onUpgrade`
5. 运行 `build_runner`

### 5.2 改 B 站接口

至少检查：

- `lib/core/api/bili_dio.dart`
- 对应 feature 的 repository
- 登录态、Cookie 注入、Referer / UA
- 是否影响评论、收藏夹、字幕、播放解析

不要假设标准 `CookieJar` 方案可替换当前实现。`SESSDATA` 含逗号是已知坑点。

### 5.3 改下载 / 播放联动

至少检查：

- `download_repository_impl.dart`
- `player_notifier.dart`
- `songs.localPath`
- `songs.audioQuality`

不要只改下载任务表而忘记 `songs` 表的反向回写。

### 5.4 改分享 / 备份

至少检查：

- `share_repository_impl.dart`
- `sync_repository_impl.dart`
- 歌曲去重逻辑是否仍以 `bvid + cid` 为准
- 是否误把本地路径、下载任务、设备相关状态带入导出数据

### 5.5 改字幕 / 歌词

至少检查：

- `subtitle_repository_impl.dart`
- DB 缓存表
- AI 字幕 URL 前缀校验
- 重试次数与失败回退
- 播放器时间轴同步

### 5.6 改更新系统

至少检查：

- `versions-manifest.json`
- `lib/features/app_update/data/update_repository_impl.dart`
- `.github/workflows/release.yml`
- [release-workflow.md](./release-workflow.md)

如果改了 Release 资产名但没同步应用内匹配逻辑，更新功能会直接坏。

### 5.7 改桌面端壳层 / 极简模式

至少检查：

- `responsive_scaffold.dart`
- `window_service.dart`
- `tray_service.dart`
- `minimal_screen.dart`

桌面端关闭窗口默认不是退出，而是隐藏到托盘。极简模式也不是普通页面皮肤，而是独立生命周期策略。

## 6. 代码生成与本地验证

### 6.1 代码生成

改了以下内容后必须重新生成：

- `@riverpod`
- `@freezed`
- Drift 表 / 数据库

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 6.2 最低验证

```bash
flutter analyze --no-fatal-infos
flutter test
```

如改动涉及具体平台，再补最小手动运行：

```bash
flutter run -d windows
flutter run -d <device_id>
```

### 6.3 高风险改动建议手测

- 登录态是否正常
- 播放器是否能恢复、切歌、后台继续播放
- 下载完成后是否离线优先
- 分享 / 备份导入后歌单是否可重建
- 字幕是否命中正确内容而不是错配 AI 字幕
- 桌面端关闭窗口是否仍是托盘行为

## 7. 改完代码后要同步哪些文档

优先更新当前主线 docs，不要把新知识继续埋进归档文档。

- 启动、路由、平台壳层：更新 `10-project/project-overview.md` 或 `10-project/ui-and-platform-quirks.md`
- B 站协议：更新 `10-project/bilibili-integration.md`
- 字幕 / 歌词：更新 `10-project/subtitle-and-lyrics.md`
- 分享 / 备份：更新 `10-project/share-and-backup.md`
- 更新系统：更新 `10-project/update-system.md` 和 `20-workflows/release-workflow.md`
- 文档结构自身：更新 `../README.md` 和 `../00-start-here/docs-maintenance.md`

## 8. 相关文档

- 新开发者入口： [../00-start-here/newcomer-path.md](../00-start-here/newcomer-path.md)
- 构建： [build-guide.md](./build-guide.md)
- 调试： [debug-guide.md](./debug-guide.md)
- 发布： [release-workflow.md](./release-workflow.md)
- 架构速查： [../30-reference/architecture.md](../30-reference/architecture.md)
