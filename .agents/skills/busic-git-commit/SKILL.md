---
name: busic-git-commit
description: BuSic Git提交规范。用于整理提交范围、撰写约定式提交信息、选择安全Git操作并对齐当前main分支事实
license: MIT
compatibility: opencode
---

## 何时使用

- 准备提交代码，但想先确认当前仓库的 Git 事实和提交格式
- 需要给改动写清晰、可回溯的 commit message
- 需要避免把无关文件、危险命令或旧分支流程带进来

## 先看这些真源

- [`docs/20-workflows/dev-workflow.md`](../../../docs/20-workflows/dev-workflow.md)
- [`docs/20-workflows/release-workflow.md`](../../../docs/20-workflows/release-workflow.md)
- [`.github/workflows/ci.yml`](../../../.github/workflows/ci.yml)
- [`scripts/release.py`](../../../scripts/release.py)

## 当前 Git 事实

- 当前长期分支事实以 `main` 为准
- 不要默认仓库存在或依赖 `develop`
- 发布标签格式是 `vX.Y.Z`
- 版本号和发布动作的详细规则交给 [`busic-version-management`](../busic-version-management/SKILL.md) 与 [`busic-release`](../busic-release/SKILL.md)

## 提交信息格式

```text
<type>(<scope>): <subject>
```

常用 `type`：

- `feat`：新增功能
- `fix`：Bug 修复
- `refactor`：重构
- `docs`：文档更新
- `test`：测试相关
- `chore`：工具、构建、依赖或辅助脚本

示例：

```text
feat(playlist): 添加歌单排序
fix(player): 修复播放暂停后进度条不同步
docs(skills): 重构本地skills结构
```

## 推荐提交流程

1. 用 `git status --short` 看清楚工作区
2. 只 stage 本次任务相关文件，优先 `git add <path>`
3. 提交前跑最低验证：

```bash
flutter analyze --no-fatal-infos
flutter test
```

4. 再执行提交：

```bash
git commit -m "type(scope): subject"
```

## 明确禁止

- 不要用 `git add .` 把无关改动一锅端走
- 不要默认使用 `git reset --hard`、`git checkout --` 这类破坏性命令
- 不要为了迁就旧文档而构造 `develop -> main` 的假流程
- 不要把功能改动、版本 bump、发布资产改名混成一个难以审查的提交

## 相关 Skill

- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
- [`busic-version-management`](../busic-version-management/SKILL.md)
- [`busic-release`](../busic-release/SKILL.md)
