---
name: busic-harness-workflow
description: BuSic代理执行工作流兼容层。用于自动化代理在当前仓库中执行任务时统一进度同步、风险确认、验证收尾和文档回写节奏
license: MIT
compatibility: opencode
---

## 何时使用

- 代理在 BuSic 仓库里执行真实改动，需要统一互动和推进节奏
- 想补充 [`busic-main-workflow`](../busic-main-workflow/SKILL.md) 的执行方式，而不是重复架构或业务规则
- 需要判断什么时候直接推进、什么时候暂停和用户确认

## 执行节奏

1. 先复述任务理解和第一步，说明会先查哪些真源
2. 先读代码与 `docs/` 主线文档，再决定实现，不依赖旧记忆
3. 能直接落地的小中型任务直接推进，不为明显可推断的问题频繁打断用户
4. 工作过程中持续同步进展、已发现的事实和下一步动作
5. 完成后给出改动结果、验证情况、剩余风险和未完成项

## 需要主动确认的场景

- 会改变数据库 schema、迁移或导入导出协议
- 会修改分享 / 备份 / 更新 Manifest / Release 资产这样的外部契约
- 会删除、批量移动或重命名较大范围文件
- 用户需求本身存在两个以上代价明显不同的实现方向

如果只是实现细节可以自行判断，优先自己收敛，不把探索成本转嫁给用户。

## 执行 checklist

- 先用 [`busic-main-workflow`](../busic-main-workflow/SKILL.md) 定位主真源
- 按职责加载对应的子 skill，不重复阅读无关规范
- 改了规则就同步 `docs/`；改了规范入口就同步 `.agents/skills/`
- 验证至少覆盖 `flutter analyze --no-fatal-infos` 与 `flutter test`，必要时加平台手测
- 汇报时明确区分：已完成、已验证、未验证、建议后续

## 不再保留的旧约定

- 不再假设存在旧工具专用的提问 / 计划模式指令
- 不再假设仓库依赖 `develop` 分支工作流
- 不再推荐一上来先写冗长计划后再行动

## 相关 Skill

- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
- [`busic-git-commit`](../busic-git-commit/SKILL.md)
- [`busic-skills-maintenance`](../busic-skills-maintenance/SKILL.md)
