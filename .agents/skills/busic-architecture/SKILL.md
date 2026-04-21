---
name: busic-architecture
description: BuSic项目架构速查。用于定位当前分层结构、主链路真源、层间依赖方向和跨系统高耦合约束
license: MIT
compatibility: opencode
---

## 何时使用

- 需要先判断一个改动应该落在哪一层或哪个 feature
- 需要确认启动链路、路由壳层、跨系统联动的真实入口
- 发现文档和代码描述不一致，想先回到当前架构真源

## 先看这些真源

- [`docs/30-reference/architecture.md`](../../../docs/30-reference/architecture.md)
- [`docs/30-reference/source-of-truth.md`](../../../docs/30-reference/source-of-truth.md)
- [`docs/10-project/project-overview.md`](../../../docs/10-project/project-overview.md)

## 当前结构

- `lib/main.dart`：启动初始化、依赖注入、窗口 / 托盘 / 极简模式入口
- `lib/app.dart`：`MaterialApp.router`、主题、语言、静默更新检查
- `lib/core/`：数据库、API、路由、主题、窗口等全局基建
- `lib/features/`：按业务能力拆分，尽量保持 `domain / data / application / presentation`
- `lib/shared/`：跨 feature 复用组件与扩展
- `lib/l10n/`：ARB 与生成的本地化代码

## 不可破坏的规则

- 推荐依赖方向：`presentation -> application -> data -> core`
- UI 通过 Provider / Notifier 访问业务层，不直接写数据库或网络
- `domain` 保持纯模型与少量派生属性，不承载复杂 IO
- `comment`、`subtitle`、`share`、`app_update`、`minimal` 更像系统能力，不要机械按主页面思维处理

## 高耦合系统提醒

- 下载完成后会反向刷新 `songs.localPath` 与 `songs.audioQuality`，播放器依赖它们恢复离线播放
- 分享 / 备份以 `bvid + cid` 作为跨设备身份，不以 `Songs.id` 或本地路径为准
- 更新系统同时依赖 `versions-manifest.json`、`app_update` feature 和 Release 资产命名
- 字幕链路依赖 B 站接口、登录态和 AI 字幕前缀校验，不是单次 API 调用

## 相关 Skill

- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
- [`busic-database`](../busic-database/SKILL.md)
- [`busic-state-management`](../busic-state-management/SKILL.md)
- [`busic-ui-development`](../busic-ui-development/SKILL.md)
