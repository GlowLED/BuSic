# BuSic — 功能开发流程指南

本文档描述在 BuSic 项目中**新增功能**或**改进现有功能**时的标准工作流程。  
遵循此流程可确保代码质量、架构一致性和团队协作效率。

---

## 1. 需求分析与规划

### 1.1 明确功能范围

- 确定功能的用户场景、输入输出和边界条件。
- 判断功能属于**现有 Feature 的扩展**还是**全新 Feature 模块**。
- 参考 [维护者上手](maintainer-onboarding.md) 和 [架构文档](LLM/architecture.md) 确认功能归属的模块位置。

### 1.2 编写功能规划文档（可选）

对于较复杂的功能，在 `docs/feat/` 目录下新建规划文档。  
参考 [share-and-sync.md](feat/share-and-sync.md) 的格式，包含：

- 功能概述与目标
- 数据模型设计（Freezed 模型 + JSON 示例）
- 数据流与状态管理方案
- UI 交互草案
- 注意事项与边界情况

---

## 2. 数据层实现

若功能涉及新的持久化数据，按以下顺序操作。  
详细规范参考 [数据层文档](LLM/data-layer.md)。

### 2.1 数据库表变更

| 步骤 | 操作 | 文件位置 |
|------|------|----------|
| 1 | 新增或修改 Drift `Table` 类 | `lib/core/database/tables/` |
| 2 | 在 `AppDatabase` 中注册新表 | `lib/core/database/app_database.dart` |
| 3 | 递增 `schemaVersion` | `AppDatabase.schemaVersion` |
| 4 | 编写迁移逻辑 | `AppDatabase.migration` 的 `onUpgrade` |

> ⚠️ **永远不要删除或重命名旧字段**。仅通过 `addColumn` 添加新列并设置默认值。

### 2.2 Domain 模型

- 使用 `@freezed` + `const factory` 定义领域模型。
- 包含 `part '*.freezed.dart'`；需要 JSON 序列化时加 `part '*.g.dart'`。
- 运行时字段（不持久化）使用 `@Default(...)` 注解。

### 2.3 Repository

- 在 `data/` 目录定义抽象接口（`abstract class XxxRepository`）。
- 在同目录实现具体类（`class XxxRepositoryImpl implements XxxRepository`）。
- Repository 仅负责数据读写，不包含业务逻辑。

---

## 3. 状态管理层实现

参考 [状态管理文档](LLM/state-management.md)。

### 3.1 创建 Notifier

```dart
// UI 绑定的短生命周期状态（最常用）
@riverpod
class XxxNotifier extends _$XxxNotifier {
  @override
  Future<XxxState> build() async { ... }
}

// 需要后台持续运行的状态
@Riverpod(keepAlive: true)
class XxxNotifier extends _$XxxNotifier {
  @override
  Future<XxxState> build() async { ... }
}
```

### 3.2 关键原则

- 状态变更后调用 `ref.invalidateSelf()` 刷新。
- 跨 Feature 通信使用信号 Provider（如 `downloadChangeSignalProvider`），避免直接耦合。
- 区分 auto-dispose（默认）和 keep-alive 的使用场景。

---

## 4. UI 层实现

参考 [UI 文档](LLM/ui.md) 和 [编码规范](LLM/coding-conventions.md)。

### 4.1 创建 Screen / Widget

| 约定 | 说明 |
|------|------|
| 继承 | 有状态交互用 `ConsumerStatefulWidget`，纯展示用 `ConsumerWidget` |
| 主题 | 通过 `context.colorScheme`、`context.textTheme` 获取 |
| 反馈 | 通过 `context.showSnackBar()` 显示通知 |
| 布局 | `ResponsiveScaffold` 自动处理桌面端/移动端布局差异 |
| const | 尽量使用 `const` 构造函数和 Widget |

### 4.2 路由注册

若功能需要独立页面，在 `lib/core/router/app_router.dart` 中注册路由：

- Shell 内嵌路由（带底部导航）：加到对应 `StatefulShellBranch` 的 `routes` 中。
- 独立路由（无导航栏）：加到 `StatefulShellRoute` 同级。
- 路由常量定义在 `AppRoutes` 抽象类中。

---

## 5. 国际化（i18n）

**所有用户可见字符串必须国际化。**

| 步骤 | 操作 |
|------|------|
| 1 | 在 `lib/l10n/app_en.arb`（模板）中添加英文条目 |
| 2 | 在 `lib/l10n/app_zh.arb` 中添加中文条目 |
| 3 | 代码中通过 `context.l10n.keyName` 访问 |

带参数的字符串使用 ICU 占位符格式：

```json
{
  "downloadAllStarted": "Started downloading {count} songs",
  "@downloadAllStarted": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

---

## 6. 代码生成

修改了以下任意内容后，**必须运行代码生成**：

- `@riverpod` 注解的 Notifier
- `@freezed` 注解的模型
- `@DriftDatabase` 或 Drift 表定义

```bash
dart run build_runner build --delete-conflicting-outputs
```

生成产物过旧时，先清理再重新生成：

```bash
dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs
```

---

## 7. 测试与验证

### 7.1 本地运行

参考 [构建指南](build-guide.md) 和 [调试指南](debug-guide.md) 进行本地验证。

```bash
# Android 调试运行
flutter run -d <device_id> --debug

# Windows 桌面调试运行
flutter run -d windows --debug

# Linux 桌面调试运行
flutter run -d linux --debug
```

### 7.2 验证清单

- [ ] 功能在目标平台正常运行
- [ ] 新增字符串在中英文下均正确显示
- [ ] 数据库迁移对已有数据无破坏
- [ ] 无 lint 警告（`dart analyze`）
- [ ] 代码生成产物已更新且无冲突

---

## 8. 版本号与发布

### 8.1 版本号规范

项目采用 **`x.y.z+a`** 格式的版本号（`pubspec.yaml` 的 `version` 字段）：

| 段 | 含义 | 何时递增 |
|---|---|---|
| `x` (major) | 不兼容的重大变更（数据格式/API 断裂） | 破坏性升级 |
| `y` (minor) | 新增功能、向前兼容 | 功能版本 |
| `z` (patch) | Bug 修复、小幅改进 | 热修复 |
| `a` (build)  | 构建序号，每次构建递增 | 每次打包 |

> 示例：`0.2.1+3` → 主版本 0，次版本 2，补丁 1，第 3 次构建。

### 8.2 版本号来源

应用内所有版本号展示（关于页面、更新检查等）均通过 `package_info_plus` 在运行时从原生层读取，**唯一真实来源是 `pubspec.yaml` 的 `version` 字段**。禁止在代码中硬编码版本号。

### 8.3 发布流程（CLI 引导 + CI/CD）

推荐通过 **发布 CLI** 完成整个发布流程：

```bash
python3 scripts/release.py
```

CLI 会引导你完成以下 7 个步骤：

#### 流程概览

```
release.py 引导 →
  1. 前置检查（Git 分支 / 工作区状态）
  2. 设置版本号（自动更新 pubspec.yaml）
  3. 静态分析（flutter analyze）
  4. 本地构建（Android APK + Windows ZIP）
  5. 蓝奏云发布（可选，手动上传后录入链接）
  6. 更新 versions-manifest.json
  7. Git commit + tag + push → 触发 CI/CD
```

#### GitHub CI/CD 触发链路

```
推送 v* tag
  └─► CI (ci.yml)          — 代码分析 + 单元测试
        └─► Release (release.yml) — 构建全平台产物 + 发布 GitHub Release
```

- `ci.yml`：在推送至 `main` 分支或任意 `v*` tag 时触发，运行 `flutter analyze` 和 `flutter test`。
- `release.yml`：监听 CI workflow 完成事件（`workflow_run`），当 CI 成功且触发来源以 `v` 开头时，自动构建 Linux / Windows / macOS / Android / iOS 产物并发布到 GitHub Releases。

#### 手动操作（不使用 CLI 时）

1. **更新版本号**：修改 `pubspec.yaml` 中的 `version` 字段，**同步递增 build 号**。
2. **本地构建**：`flutter build apk --release` + `flutter build windows --release`
3. **（可选）上传蓝奏云**：手动上传构建产物，获取分享链接和提取码。
4. **更新 manifest**：编辑 `versions-manifest.json`，添加新版本条目（含 GitHub 链接 + 可选蓝奏云链接）。
5. **提交 + 打 Tag + 推送**：
   ```bash
   git add -A && git commit -m "v0.3.0"
   git tag v0.3.0          # tag 名仅含 semver，不含 build 号
   git push origin main --tags
   ```

> ⚠️ **Tag 格式规则**：tag 名为 `v<major>.<minor>.<patch>`，仅含 semver，不含 build 号。例如 `pubspec.yaml` 中 `version: 0.3.0+5`，对应 tag 为 `v0.3.0`。
>
> ⚠️ **CI 必须通过**：Release 工作流依赖 CI 成功才会触发。如果 CI 失败（analyze/test 不通过），Release **不会**发布。推 tag 前务必确保本地 `flutter analyze --no-fatal-infos` 无报错。

---

## 9. 常见场景速查

### 新增 Feature 模块

```
lib/features/new_feature/
├── domain/
│   └── models/       # @freezed 数据模型
├── data/
│   ├── xxx_repository.dart      # 抽象接口
│   └── xxx_repository_impl.dart # Drift 实现
├── application/
│   └── xxx_notifier.dart        # @riverpod 状态管理
└── presentation/
    ├── xxx_screen.dart          # 主页面
    └── widgets/                 # 子组件
```

### 给现有表添加字段

1. 在 `lib/core/database/tables/` 中给 Table 类添加 Column。
2. 在 `AppDatabase` 中递增 `schemaVersion`。
3. 在 `onUpgrade` 中编写 `addColumn` 迁移。
4. 更新对应的 Freezed 模型和 Repository 映射。
5. 运行 `build_runner`。

### 添加新的弹窗/对话框

1. 在 Feature 的 `presentation/widgets/` 下创建 Dialog Widget。
2. 使用 `showDialog()` 或 `showModalBottomSheet()` 调用。
3. 所有显示文本通过 `context.l10n` 获取。
4. 使用 `context.colorScheme` 适配主题。

---

## 参考文档索引

| 文档 | 描述 |
|------|------|
| [maintainer-onboarding.md](maintainer-onboarding.md) | 维护者开发与发布入口总览 |
| [pro-struc.md](pro-struc.md) | 历史结构说明（存在过时内容） |
| [build-guide.md](build-guide.md) | 从零搭建构建环境 |
| [debug-guide.md](debug-guide.md) | 本地调试指南 |
| [design.md](design.md) | 早期技术设计文档 |
| [LLM/architecture.md](LLM/architecture.md) | 架构速查（面向 AI） |
| [LLM/coding-conventions.md](LLM/coding-conventions.md) | 编码规范速查 |
| [LLM/data-layer.md](LLM/data-layer.md) | 数据层参考 |
| [LLM/state-management.md](LLM/state-management.md) | 状态管理参考 |
| [LLM/ui.md](LLM/ui.md) | UI 层参考 |
| [LLM/device-testing.md](LLM/device-testing.md) | LLM Agent 真机/模拟器交互测试流程 |
