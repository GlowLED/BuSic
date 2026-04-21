---
name: busic-testing
description: BuSic测试规范。用于确认测试真源、最低验证顺序、常用测试模式和补测优先级入口
license: MIT
compatibility: opencode
---

## 何时使用

- 新增功能后补测试
- 改了 codegen、i18n、Repository、Notifier 或共享组件
- 需要确认当前本地与 CI 最低验证顺序

## 先看这些真源

- [`docs/20-workflows/testing-guide.md`](../../../docs/20-workflows/testing-guide.md)
- [`.github/workflows/ci.yml`](../../../.github/workflows/ci.yml)
- [`test/test_helpers/test_app.dart`](../../../test/test_helpers/test_app.dart)

## 最低验证

```bash
flutter analyze --no-fatal-infos
flutter test
```

如果改了 `@riverpod`、`@freezed`、Drift 或 `lib/l10n/*.arb`：

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze --no-fatal-infos
flutter test
```

## 常用测试模式

- Drift Repository：`AppDatabase.forTesting(NativeDatabase.memory())`
- Riverpod / Notifier：`ProviderContainer`
- Widget：优先复用 `buildTestApp`
- SharedPreferences：`SharedPreferences.setMockInitialValues(...)`

## 补测原则

- 每个功能改动都应补相应测试，做不到时要说明原因
- 回归 bug 时优先补能稳定复现旧问题的 targeted test
- 断言优先验证业务结果和真实状态，不要只验证实现细节
- 具体覆盖矩阵、当前测试总量和补测优先级以 `testing-guide.md` 为准，不在 skill 里复制

## 相关 Skill

- [`busic-main-workflow`](../busic-main-workflow/SKILL.md)
- [`busic-database`](../busic-database/SKILL.md)
- [`busic-state-management`](../busic-state-management/SKILL.md)
- [`busic-ui-development`](../busic-ui-development/SKILL.md)
