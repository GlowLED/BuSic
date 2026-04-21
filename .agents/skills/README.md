# BuSic Skills

本目录保存 BuSic 项目的本地 skill 定义。

这次重构后的约定很简单：

- skill 名称保持稳定，避免破坏既有调用习惯
- skill 只保留高频决策、检查清单和跳转入口
- `docs/` 才是长期主真源，skill 负责把执行者带到正确文档
- 需要精确数字、日期、覆盖率、脚本参数时，优先回链到 `docs/` 或真源文件，不在 skill 里重复维护

## 当前技能地图

| Skill | 类型 | 主真源 |
|---|---|---|
| `busic-main-workflow` | 主开发入口 | [`docs/20-workflows/dev-workflow.md`](../../docs/20-workflows/dev-workflow.md) |
| `busic-harness-workflow` | 代理执行节奏兼容层 | [`busic-main-workflow`](./busic-main-workflow/SKILL.md) |
| `busic-architecture` | 架构速查 | [`docs/30-reference/architecture.md`](../../docs/30-reference/architecture.md) |
| `busic-coding-conventions` | 编码规范 | [`docs/30-reference/coding-conventions.md`](../../docs/30-reference/coding-conventions.md) |
| `busic-database` | 数据层 / Drift 规范 | [`docs/30-reference/data-layer.md`](../../docs/30-reference/data-layer.md) |
| `busic-state-management` | Riverpod 规范 | [`docs/30-reference/state-management.md`](../../docs/30-reference/state-management.md) |
| `busic-ui-development` | UI / 主题 / i18n 规范 | [`docs/30-reference/ui.md`](../../docs/30-reference/ui.md) |
| `busic-testing` | 测试维护入口 | [`docs/20-workflows/testing-guide.md`](../../docs/20-workflows/testing-guide.md) |
| `busic-git-commit` | Git 提交规范 | [`docs/20-workflows/dev-workflow.md`](../../docs/20-workflows/dev-workflow.md) |
| `busic-version-management` | 版本号规则 | [`docs/20-workflows/release-workflow.md`](../../docs/20-workflows/release-workflow.md) |
| `busic-release` | 发布流程 | [`docs/20-workflows/release-workflow.md`](../../docs/20-workflows/release-workflow.md) |
| `busic-skills-maintenance` | skills 维护规范 | [`README.md`](./README.md) |

## 统一内容模板

每个 skill 默认按下面的顺序组织：

1. `何时使用`
2. `先看这些真源`
3. `关键规则` 或 `执行 checklist`
4. `相关 Skill`

如果某个 skill 需要更短，也优先保留这四类信息，不再重复维护长篇教程。

## 统一维护规则

- 兄弟 skill 之间使用 `../<skill-name>/SKILL.md` 互相引用
- 指向仓库 `docs/` 时，从 skill 目录使用 `../../../docs/...`
- skill 内不要复制大段与 `docs/` 完全重复的内容
- 旧流程、旧分支模型、旧工具名如果已经不是当前仓库事实，必须及时移除
- 目录名必须与 frontmatter 中的 `name` 一致

## 建议自检

改完 `.agents/skills/` 后，运行：

```bash
python scripts/validate-skills.py
```

这个脚本会检查：

- 目录与 `name` 是否一致
- `description` 是否存在
- 相对 Markdown 链接是否可达

## 相关文档

- Docs 总入口： [`docs/README.md`](../../docs/README.md)
- Docs 维护规范： [`docs/00-start-here/docs-maintenance.md`](../../docs/00-start-here/docs-maintenance.md)
