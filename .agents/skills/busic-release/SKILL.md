---
name: busic-release
description: BuSic发布流程规范。用于执行正式发布时快速定位发布真源、推荐脚本、发布前检查项和最容易遗漏的manifest与资产联动
license: MIT
compatibility: opencode
---

## 何时使用

- 准备做正式发布、打 tag、更新 manifest 或检查发布链路
- 需要确认 BuSic 当前真实发布入口，而不是沿用历史流程
- 想快速知道发布前最低检查和最容易漏掉的联动项

## 先看这些真源

- [`docs/20-workflows/release-workflow.md`](../../../docs/20-workflows/release-workflow.md)
- [`docs/10-project/update-system.md`](../../../docs/10-project/update-system.md)
- [`pubspec.yaml`](../../../pubspec.yaml)
- [`versions-manifest.json`](../../../versions-manifest.json)
- [`CHANGELOG.md`](../../../CHANGELOG.md)
- [`.github/workflows/ci.yml`](../../../.github/workflows/ci.yml)
- [`.github/workflows/release.yml`](../../../.github/workflows/release.yml)
- [`scripts/release.py`](../../../scripts/release.py)

## 当前推荐发布路径

优先使用发布脚本，而不是手动拼装一整套旧流程：

```bash
python scripts/release.py
```

如果环境里只有 `python3`，可改为：

```bash
python3 scripts/release.py
```

这个脚本会引导完成版本设置、构建、manifest 更新、提交、打 tag 和推送。

Agent 执行发布脚本时，脚本内会触发构建、写入型 Git、tag 和 push，通常需要提权到沙箱外；完整分类见 [`busic-harness-workflow`](../busic-harness-workflow/SKILL.md)。

## 发布前最低检查

```bash
flutter analyze --no-fatal-infos
flutter test
```

Agent 执行时，`flutter ...` 通常需要提权到沙箱外。

如果改了 codegen：

```bash
dart run build_runner build --delete-conflicting-outputs
```

`dart run ...` 在 agent 沙箱中也按通常需提权处理。

## 当前发布链路的关键事实

- 发布以 `main` 分支与 `v*` tag 为准
- 应用内更新的主真源是 `versions-manifest.json`
- Release 资产命名会影响客户端更新匹配
- 蓝奏云仍然需要人工补链或额外脚本处理

## 最容易漏掉的联动

- 只 bump 了 `pubspec.yaml`，没更新 `versions-manifest.json`
- 改了资产名，没同步 `app_update` feature
- 打 tag 前没跑 analyze / test
- 只检查 GitHub Release 页面，没检查 manifest 是否真的可用

## 相关 Skill

- [`busic-version-management`](../busic-version-management/SKILL.md)
- [`busic-git-commit`](../busic-git-commit/SKILL.md)
- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
- [`busic-harness-workflow`](../busic-harness-workflow/SKILL.md)
