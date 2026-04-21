---
name: busic-testing
description: BuSic测试规范。用于编写单元测试和集成测试，包含测试结构、Repository测试模式、验证要求
license: MIT
compatibility: opencode
---

## 主真源

测试维护已经整合进：

- `docs/20-workflows/testing-guide.md`

使用这个 skill 时，优先以该文档为准，尤其是：

- CI / 本地验证命令
- 当前 `test/` 目录结构
- Repository / Notifier / Widget 测试模式
- 当前覆盖矩阵与补测优先级

## 最小规则

- 每个功能改动都应补对应测试或明确说明为什么无法自动化
- `group()` / `test()` 优先用中文命名
- 正文优先按 `Arrange / Act / Assert`
- 提交前至少运行：

```bash
flutter analyze --no-fatal-infos
flutter test
```

## 当前常用模式速记

- Drift Repository：`AppDatabase.forTesting(NativeDatabase.memory())`
- 多数据库往返测试：`driftRuntimeOptions.dontWarnAboutMultipleDatabases = true`
- Riverpod：`ProviderContainer`
- Widget：优先复用 `test/test_helpers/test_app.dart`
- SharedPreferences：`SharedPreferences.setMockInitialValues(...)`
