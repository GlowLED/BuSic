---
name: busic-version-management
description: BuSic版本号管理规范。用于确认SemVer格式、版本变更级别、版本真源文件和发布前必须同步的版本相关数据
license: MIT
compatibility: opencode
---

## 何时使用

- 要判断这次改动应该升 `major`、`minor` 还是 `patch`
- 准备发布版本，需要知道哪些文件必须一起改
- 想确认应用内更新、Git tag、用户可见版本之间的关系

## 先看这些真源

- [`docs/20-workflows/release-workflow.md`](../../../docs/20-workflows/release-workflow.md)
- [`docs/10-project/update-system.md`](../../../docs/10-project/update-system.md)
- [`docs/30-reference/source-of-truth.md`](../../../docs/30-reference/source-of-truth.md)
- [`pubspec.yaml`](../../../pubspec.yaml)
- [`versions-manifest.json`](../../../versions-manifest.json)
- [`CHANGELOG.md`](../../../CHANGELOG.md)

## 版本格式

BuSic 使用：

```text
major.minor.patch+build
```

规则：

- `major`：不兼容变更
- `minor`：向后兼容的新功能
- `patch`：向后兼容的修复或小优化
- `build`：构建序号，只在内部流转和发布资产中使用

用户可见版本与 Git tag 不带 `+build`：

- `pubspec.yaml`：`0.3.8+14`
- 用户可见：`0.3.8`
- Git tag：`v0.3.8`

## 发布时必须同步的文件

- [`pubspec.yaml`](../../../pubspec.yaml)：真实版本号
- [`CHANGELOG.md`](../../../CHANGELOG.md)：面向人的变更记录
- [`versions-manifest.json`](../../../versions-manifest.json)：应用内更新主真源

如果是正式发布，还要同步确认：

- [`lib/features/app_update/`](../../../lib/features/app_update/)
- [`.github/workflows/release.yml`](../../../.github/workflows/release.yml)

## 何时升哪个版本

- 有破坏性协议、迁移或接口调整：升 `major`
- 有新功能但兼容旧行为：升 `minor`
- 只是修复、稳定性改善、非破坏性优化：升 `patch`

如果一次改动同时包含新功能和修复，通常按最高级别处理。

## 容易漏掉的点

- 只改了 `pubspec.yaml`，没改 `versions-manifest.json`
- 改了 Release 资产名，但忘了同步更新应用内匹配逻辑
- 只看 GitHub Releases 页面，没检查 manifest 是否已更新
- 在 skill 里硬编码“当前最新版本号”这种容易过时的信息

## 相关 Skill

- [`busic-release`](../busic-release/SKILL.md)
- [`busic-git-commit`](../busic-git-commit/SKILL.md)
- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
