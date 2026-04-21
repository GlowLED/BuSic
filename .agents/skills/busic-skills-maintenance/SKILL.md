---
name: busic-skills-maintenance
description: BuSic Skills维护规范。用于维护和重构.agents/skills时统一目录结构、模板、更新时机、自检方式和与docs的职责边界
license: MIT
compatibility: opencode
---

## 何时使用

- 维护 `.agents/skills/` 本身
- 新建、删除或重写某个 skill
- 想确认 skill 和 `docs/` 应该各自承载什么内容

## 先看这些真源

- [`README.md`](../README.md)
- [`docs/README.md`](../../../docs/README.md)
- [`docs/00-start-here/docs-maintenance.md`](../../../docs/00-start-here/docs-maintenance.md)

## 目录与命名

目录结构保持：

```text
.agents/skills/<skill-name>/SKILL.md
```

约束：

- 目录名必须与 frontmatter 中的 `name` 一致
- 文件名固定为 `SKILL.md`
- skill 名使用小写字母 / 数字 / 单个连字符

## 当前统一模板

每个 skill 默认保留这四部分：

1. `何时使用`
2. `先看这些真源`
3. `关键规则` 或 `执行 checklist`
4. `相关 Skill`

额外规则：

- skill 负责“入口、约束、跳转”，不负责复制整篇主线文档
- 精确数字、日期、覆盖率、脚本参数优先回链到 `docs/` 或真源文件
- 兄弟 skill 相互引用时使用 `../<skill-name>/SKILL.md`
- 指向仓库 `docs/` 时使用从 skill 目录出发的相对路径

## 什么时候要更新 skill

- 架构约束变了：更新 `busic-architecture`
- 编码约定变了：更新 `busic-coding-conventions`
- Drift / Repository / 迁移规则变了：更新 `busic-database`
- Riverpod 使用方式变了：更新 `busic-state-management`
- UI / 主题 / i18n / 响应式规则变了：更新 `busic-ui-development`
- 测试目录、命令或测试模式变了：更新 `busic-testing`
- 发布、版本或 Git 流程变了：更新 `busic-release` / `busic-version-management` / `busic-git-commit`

## 新建或删除 skill 的原则

适合新建：

- 某块规范有独立职责，且会被重复引用
- 内容经常变化，单独维护更便宜
- 放进现有 skill 会让职责边界明显变糊

适合删除或合并：

- 只是旧工具遗留兼容层，且已无调用价值
- 内容完全被 `docs/` 或其它 skill 覆盖
- skill 名存在，但已无法表达当前仓库事实

## 建议自检

```bash
python scripts/validate-skills.py
```

建议至少确认：

- `name` 与目录名一致
- `description` 非空
- 相对 Markdown 链接全部可达
- 没有继续引用已经过时的旧流程、旧工具名、旧分支模型

## 相关 Skill

- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
- [`busic-harness-workflow`](../busic-harness-workflow/SKILL.md)
