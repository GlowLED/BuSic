# 贡献指南

感谢你对 BuSic 的关注！在提交代码之前，请阅读以下指南以确保 PR 能顺利通过 CI。

## 开发环境准备

1. 安装 Flutter SDK（>= 3.16）
2. 运行 `flutter pub get` 安装依赖
3. 运行代码生成（见下方）

## Push / PR 前必须执行的检查

CI 流水线会依次执行以下步骤，请在本地**全部通过**后再推送：

### 1. 代码生成

修改 Freezed 模型、Riverpod Provider 或 Drift 表定义后，必须重新生成代码。**即使你不确定是否需要，也建议在提交前执行一次。**

```bash
dart run build_runner build --delete-conflicting-outputs
```

> 生成的 `*.g.dart` 和 `*.freezed.dart` 文件需要一并提交。

### 2. 静态分析

```bash
flutter analyze --no-fatal-infos
```

必须 **0 error、0 warning**。CI 中使用 `--no-fatal-infos` 参数，info 级别不会导致失败，但仍建议尽量消除。

常见的 lint 问题及修复方式：

| Lint 规则 | 说明 | 修复方式 |
|---|---|---|
| `use_super_parameters` | 构造函数参数可直接透传给 super | 改用 `super.paramName` 语法 |
| `prefer_const_declarations` | 用常量初始化的 `final` 变量应改为 `const` | 将 `final` 改为 `const` |
| `unnecessary_import` | 导入的库中所有符号已由另一个导入提供 | 删除多余的 `import` 语句 |
| `unused_field` / `unused_local_variable` | 声明了但未使用的字段或变量 | 删除未使用的声明 |

### 3. 单元测试

```bash
flutter test
```

所有测试必须通过。

### 快速检查（一键执行）

```bash
dart run build_runner build --delete-conflicting-outputs && flutter analyze --no-fatal-infos && flutter test
```

## 编码规范

详细的编码规范请参阅：

- [docs 主入口](docs/README.md) — 默认阅读路径与项目特化知识导航
- [编码规范](docs/30-reference/coding-conventions.md) — 命名约定、代码风格、错误处理
- [架构与项目结构](docs/30-reference/architecture.md) — 分层架构、目录组织

### 核心要点

- 优先使用**中文注释**
- 字符串使用**单引号**
- 尽可能使用 **`const`**
- 禁止 `print()`，使用 `AppLogger`
- 项目内导入使用**相对路径**
- 不手动编辑 `*.g.dart` / `*.freezed.dart`

## 提交规范

- 主分支：`main`
- 提交信息用中文或英文均可，需简明扼要描述变更
- 每次 push 到 `main` 或提交 PR 时，CI 会自动运行检查

## 许可证

提交代码即表示你同意将其以 [GPLv3](LICENSE) 许可证发布。
