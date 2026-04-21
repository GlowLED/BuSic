# BuSic 测试维护指南

这篇文档是 **BuSic 自动化测试维护的主真源**。它只负责三件事：

1. 说明当前 CI 和本地验证的最低要求
2. 说明当前测试目录、常用测试模式和维护约定
3. 记录当前覆盖现状与补测优先级

真机 / 模拟器交互测试另见 [../30-reference/device-testing.md](../30-reference/device-testing.md)。

## 1. 当前基线与真源

测试要求的当前真源：

- `.github/workflows/ci.yml`
- `test/`
- `test/test_helpers/test_app.dart`
- `lib/core/database/app_database.dart`

2026-04-21 已确认当前本地基线：

- `flutter analyze --no-fatal-infos` 通过
- `flutter test -r expanded` 通过
- 当前总计 **124 个测试**

CI 当前执行顺序与本地保持一致：

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze --no-fatal-infos
flutter test
```

如果执行者是运行在沙箱中的 agent，请预期 `flutter ...`、`dart run ...` 和远程/写入型 Git 往往需要提权到沙箱外；本地只读 Git（如 `git status`、`git log`、`git diff`）通常可先在沙箱内尝试。统一分类见 [../00-start-here/agent-quickstart.md](../00-start-here/agent-quickstart.md)。

结论：

- 改了代码生成相关内容时，不要跳过 `build_runner`
- 本地测试维护必须以 `.github/workflows/ci.yml` 为准，不要自己发明另一套命令顺序

## 2. 本地最低执行顺序

### 2.1 常规开发

```bash
flutter analyze --no-fatal-infos
flutter test
```

### 2.2 改了 codegen 或 i18n

适用场景：

- `@riverpod`
- `@freezed`
- Drift 表 / 数据库
- `lib/l10n/*.arb`

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze --no-fatal-infos
flutter test
```

### 2.3 只回归单个测试文件

```bash
flutter test test/features/share/data/backup_path_safety_test.dart
flutter test test/features/app_update/data/update_repository_impl_test.dart
flutter test test/shared/widgets/song_tile_test.dart
```

先跑单测定位问题可以接受，但提交前仍要回到全量 `flutter test`。

## 3. 当前测试目录

当前真实结构：

```text
test/
├── core/
│   ├── router/
│   └── theme/
├── features/
│   ├── app_update/
│   ├── download/
│   ├── playlist/
│   ├── search_and_parse/
│   ├── settings/
│   └── share/
├── shared/
│   └── widgets/
├── test_helpers/
│   └── test_app.dart
└── widget_test.dart
```

维护约定：

- 新 feature 测试优先放在 `test/features/<feature>/`
- 目录内优先按 `domain/models`、`data`、`application`、`presentation` 分层
- `test/core/` 只放全局基础设施测试，例如路由、主题
- `test/shared/` 只放跨 feature 复用组件测试
- `test/test_helpers/` 只放公共测试辅助设施
- `test/widget_test.dart` 当前仍是占位文件，**不应算作 feature 覆盖**

推荐目标结构：

```text
test/features/
├── <feature>/domain/models/
├── <feature>/data/
├── <feature>/application/
└── <feature>/presentation/
```

注意：当前仓库并未完全达到这个结构。维护文档时要先写“当前事实”，再写“推荐目标”。

## 4. 常用测试模式

### 4.1 Drift Repository 测试

适用：Repository、备份导入导出、下载缓存联动等数据层场景。

核心约定：

- 使用 `AppDatabase.forTesting(NativeDatabase.memory())`
- `tearDown()` 中关闭数据库
- 多数据库往返测试时设置 `driftRuntimeOptions.dontWarnAboutMultipleDatabases = true`
- 数据层断言优先验证真实表状态，而不是只验证中间变量

基础模板：

```dart
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/core/database/app_database.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late XxxRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = XxxRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });
}
```

### 4.2 Riverpod / Notifier 测试

适用：`application/` 层状态编排。

核心约定：

- 使用 `ProviderContainer`
- 用 `addTearDown(container.dispose)` 回收资源
- 优先断言最终 state 或持久化结果，不要只断言内部调用顺序

### 4.3 SharedPreferences 测试

适用：设置项、启动行为开关、轻量持久化。

核心约定：

- 用 `SharedPreferences.setMockInitialValues(...)` 准备初始值
- 执行动作后重新读取 `SharedPreferences.getInstance()` 验证落盘结果

### 4.4 Widget 测试

适用：共享组件、列表项、轻量交互组件。

核心约定：

- 优先复用 `test/test_helpers/test_app.dart` 中的 `buildTestApp`
- 需要主题和多语言环境时，不要自己拼新的 `MaterialApp`
- 交互测试同时验证可见文本和回调行为

### 4.5 网络与文件系统测试

适用：更新下载、代理探测、外部请求适配层。

核心约定：

- 优先使用本地 `Mock` / `Fake` adapter，不依赖真实网络
- 临时文件放在 `Directory.systemTemp`
- 结束后清理临时目录

## 5. 编写规范

- `group()` 和 `test()` 命名优先使用中文，直接描述场景和预期
- 测试正文优先使用 `Arrange / Act / Assert`
- 回归 bug 时，优先补一个能稳定复现旧问题的 targeted test
- 断言优先验证业务结果和真实状态，不要过度依赖实现细节

示例：

```dart
group('备份导出不含下载路径', () {
  test('有 localPath 的歌曲导出后 SharedSong 不含路径字段', () async {
    // Arrange

    // Act

    // Assert
  });
});
```

## 6. 当前覆盖矩阵

| 范围 | 当前覆盖 | 现状判断 | 下一步 |
|---|---|---|---|
| `test/core/router` | `app_router_test.dart` | 已覆盖 | 路由结构变动时同步补回归 |
| `test/core/theme` | `app_theme_test.dart` | 已覆盖 | 改主题 token 时补断言 |
| `test/shared/widgets` | `app_panel` / `media_cover` / `song_tile` | 部分覆盖 | 新增共享组件时同步补 widget tests |
| `features/app_update` | `data` + `domain/models` | 覆盖较好 | 后续补 `application` / `presentation` |
| `features/download` | `download_cache_mechanism_test.dart` | 关键链路已覆盖 | 后续补 Notifier 与 UI 回归 |
| `features/playlist` | `presentation/widgets/playlist_tile_test.dart` | 覆盖偏浅 | 优先补 `data` / `application` |
| `features/search_and_parse` | `presentation/widgets/search_result_list_test.dart` | 覆盖偏浅 | 优先补解析与数据层 |
| `features/settings` | `application/settings_notifier_test.dart` | 局部覆盖 | 改设置持久化时继续补 |
| `features/share` | `data` 层 3 个文件 | 关键协议已覆盖 | 后续补 `application` / `presentation` |
| `features/auth` | 无 | 未覆盖 | 需要新增数据层和状态层测试 |
| `features/comment` | 无 | 未覆盖 | 需要新增请求适配和状态测试 |
| `features/minimal` | 无 | 未覆盖 | 需要新增生命周期与页面测试 |
| `features/player` | 无 | 未覆盖 | 需要新增主链路状态与缓存联动测试 |
| `features/subtitle` | 无 | 未覆盖 | 需要新增缓存、前缀校验、重试测试 |
| `test/widget_test.dart` | 占位测试 | 不计覆盖 | 后续可替换或删除 |

## 7. 补测优先级

### P0

- `player`
- `subtitle`
- `auth`

原因：

- 都在主链路或强耦合链路上
- 任何回归都容易影响播放、登录、歌词或真实请求
- 当前 `test/features/` 中完全缺失

### P1

- `comment`
- `minimal`

原因：

- 目前完全没有自动化测试
- 逻辑不如 P0 核心，但失败后仍较难靠静态分析发现

### P2

- 为已部分覆盖 feature 补齐层级缺口
- 优先顺序：`playlist` -> `search_and_parse` -> `settings` -> `app_update`

原因：

- 已经有局部测试，继续补齐成本更低
- 有利于把目录结构逐步拉回推荐形态

## 8. 什么时候必须更新本文档

出现以下任一变化时，必须同步更新本文档：

- `.github/workflows/ci.yml` 中的测试命令或顺序变化
- `test/` 目录结构变化
- 新增或删除公共测试辅助设施，例如 `test/test_helpers/test_app.dart`
- 新增大批测试，导致覆盖矩阵和优先级失真
- Repository / Widget / Notifier 的通用测试模式发生变化

如果改的是真机 / 模拟器交互流程，再同步更新 [../30-reference/device-testing.md](../30-reference/device-testing.md)。

## 9. 相关文档

- 开发工作流： [dev-workflow.md](./dev-workflow.md)
- 调试方式： [debug-guide.md](./debug-guide.md)
- 真机 / 模拟器交互测试： [../30-reference/device-testing.md](../30-reference/device-testing.md)
- 新开发者路径： [../00-start-here/newcomer-path.md](../00-start-here/newcomer-path.md)
- PR 提交前检查： [../../CONTRIBUTING.md](../../CONTRIBUTING.md)
