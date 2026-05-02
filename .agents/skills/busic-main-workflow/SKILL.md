---
name: busic-main-workflow
description: BuSic主开发入口。用于功能开发、bug修复、代码重构时快速定位阅读顺序、执行顺序、最低验证和联动文档
license: MIT
compatibility: opencode
---

## 何时使用

- 进入一个新的开发任务，不确定先读什么、先改哪里
- 需要快速确认 BuSic 当前推荐的开发顺序
- 想在实现前先把最低验证和文档联动范围看清楚

## 先看这些真源

1. [`docs/20-workflows/dev-workflow.md`](../../../docs/20-workflows/dev-workflow.md)
2. [`docs/00-start-here/agent-quickstart.md`](../../../docs/00-start-here/agent-quickstart.md)
3. [`docs/10-project/project-overview.md`](../../../docs/10-project/project-overview.md)
4. [`docs/10-project/project-specific-rules.md`](../../../docs/10-project/project-specific-rules.md)
5. [`docs/30-reference/source-of-truth.md`](../../../docs/30-reference/source-of-truth.md)

如果改的是特化系统，再补读：

- 更新系统： [`docs/10-project/update-system.md`](../../../docs/10-project/update-system.md)
- 字幕 / 歌词： [`docs/10-project/subtitle-and-lyrics.md`](../../../docs/10-project/subtitle-and-lyrics.md)
- 分享 / 备份： [`docs/10-project/share-and-backup.md`](../../../docs/10-project/share-and-backup.md)
- 桌面壳层 / 极简模式： [`docs/10-project/ui-and-platform-quirks.md`](../../../docs/10-project/ui-and-platform-quirks.md)
- B 站接入： [`docs/10-project/bilibili-integration.md`](../../../docs/10-project/bilibili-integration.md)
- 视频互动 / 详情： [`docs/10-project/bilibili-integration.md`](../../../docs/10-project/bilibili-integration.md)（视频互动端点、登录态失败模式、收藏/投币/分享注意事项）

## 推荐执行顺序

1. 先判断任务是否需要在 [`docs/40-feature-plans/`](../../../docs/40-feature-plans/) 建规划文档
2. 先定位真源文件，再决定改动范围，不要从旧文档反推实现
3. 涉及数据结构或协议时，优先改数据层和联动约束，再改业务编排，最后改 UI / 路由
4. 改了 `@riverpod`、`@freezed`、Drift 或 ARB 后，补 `build_runner` / `gen-l10n`
5. 改完先跑最低验证，再补受影响的 `docs/` 与 `.agents/skills/`

## 最低验证

```bash
flutter analyze --no-fatal-infos
flutter test
```

如果改了 codegen 或 i18n：

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

如果改动有平台或高风险联动，再补最小手测：

```bash
flutter run -d windows
flutter run -d <device_id>
```

## 高频联动提醒

- 改数据库：同步看 `app_database.dart`、表定义、迁移和 Repository 映射
- 改下载 / 播放：确认 `songs.localPath` 与 `songs.audioQuality` 的反向回写没有断
- 改分享 / 备份：继续以 `bvid + cid` 作为跨设备身份，不要带本地路径
- 改更新系统：同步检查 `versions-manifest.json`、`app_update` feature、Release 资产名
- 改桌面壳层：确认托盘和极简模式生命周期没有被普通页面逻辑误伤
- 改视频互动：确认 `VideoInteractionNotifier` 的乐观更新回滚逻辑，点赞/投币/收藏状态读取失败时按未激活处理，写接口需要 `bili_jct` 作为 csrf

## 改完别忘了

- 更新受影响的主线文档，优先改 `docs/`，不要把新知识继续埋到归档文档
- 如果规范本身发生变化，再更新对应 skill
- 参考 [`busic-git-commit`](../busic-git-commit/SKILL.md) 整理提交

## 相关 Skill

- [`busic-architecture`](../busic-architecture/SKILL.md)
- [`busic-coding-conventions`](../busic-coding-conventions/SKILL.md)
- [`busic-database`](../busic-database/SKILL.md)
- [`busic-state-management`](../busic-state-management/SKILL.md)
- [`busic-ui-development`](../busic-ui-development/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
- [`busic-skills-maintenance`](../busic-skills-maintenance/SKILL.md)
