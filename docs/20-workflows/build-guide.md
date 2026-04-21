# BuSic 构建指南

这份文档只保留 **BuSic 特有的构建注意事项**。Flutter / Android Studio 的通用安装过程请直接看官方文档。

## 1. 版本真源

先看 `pubspec.yaml`：

- Dart：`>=3.2.0 <4.0.0`
- Flutter：`>=3.16.0`

如果本地工具链不满足这里的约束，后续分析、代码生成和构建结果都不可信。

## 2. BuSic 特有依赖

### 2.1 跨平台媒体播放

项目使用：

- `media_kit`
- `media_kit_libs_windows_audio`
- `media_kit_libs_linux`
- `media_kit_libs_macos_audio`
- `media_kit_libs_android_audio`
- `audio_service`

这意味着：

- 桌面端构建不是纯 Dart 应用，依赖原生媒体库
- Android 端不仅是 UI 应用，还带后台音频会话
- 某个平台能编译，不代表所有平台都能编译

### 2.2 桌面端壳层

项目还依赖：

- `window_manager`
- `tray_manager`

桌面构建和运行需要对应平台的原生开发环境正常。

## 3. 首次拉起项目

```bash
flutter doctor -v
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

如果执行者是运行在沙箱中的 agent，请预期 `flutter ...`、`dart run ...` 和远程/写入型 Git 往往需要提权到沙箱外；本地只读 Git（如 `git status`、`git log`、`git diff`）通常可先在沙箱内尝试。统一分类见 [../00-start-here/agent-quickstart.md](../00-start-here/agent-quickstart.md)。

说明：

- `build_runner` 负责 Riverpod / Freezed / Drift 生成代码
- `flutter gen-l10n` 负责本地化代码
- 生成文件不要手改

## 4. 常用调试构建

### 4.1 Windows

```bash
flutter run -d windows
```

Windows 是最适合看桌面壳层、托盘、极简模式、标题栏行为的平台。

### 4.2 Android

```bash
flutter devices
flutter run -d <device_id>
```

Android 适合验证：

- 后台播放
- 通知栏媒体会话
- 登录态
- 真机网络行为

### 4.3 Linux / macOS

```bash
flutter run -d linux
flutter run -d macos
```

这些平台主要用于补充跨平台验证，不是默认首选调试入口。

## 5. Release 构建

### 5.1 Windows

```bash
flutter build windows --release
```

### 5.2 Android APK

```bash
flutter build apk --release --no-tree-shake-icons
```

项目历史上保留 `--no-tree-shake-icons`，避免 Release 版图标被过度裁剪后出现显示异常。

### 5.3 Android App Bundle

```bash
flutter build appbundle --release
```

### 5.4 其他平台

```bash
flutter build linux --release
flutter build macos --release
flutter build ios --release
```

注意：

- Windows 上不能直接交叉构建 macOS / iOS
- iOS / macOS 仍然需要 Apple 工具链
- 发布前优先看 [release-workflow.md](./release-workflow.md)

## 6. Android Release 前置项

Android 正式包需要 keystore。项目默认约定：

- `android/key.properties`
- `android/app/upload-keystore.jks`

这些文件不应提交到仓库。

如果你只是本地调试，不需要先配 Release keystore。

## 7. BuSic 构建时最常见的问题

### 7.1 改了模型 / Provider / Drift 但忘了重新生成

症状：

- `.g.dart` 报错
- Provider 找不到
- Drift 表结构不一致

处理：

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 7.2 只看到了 Flutter 层，忽略了桌面原生依赖

症状：

- 桌面端能 `pub get`，但原生构建失败
- 与窗口、托盘、媒体库相关的链接失败

处理：

- 先保证平台原生工具链可用
- 再判断是否是 BuSic 代码问题

### 7.3 把平台行为当成统一的

BuSic 不是“任意平台完全等价”：

- 托盘只在桌面端有意义
- 关闭窗口隐藏到托盘只在桌面端成立
- `audio_service` 的体验重点在 Android
- 极简模式是独立路由和生命周期策略

## 8. 继续阅读

- 调试： [debug-guide.md](./debug-guide.md)
- 开发流程： [dev-workflow.md](./dev-workflow.md)
- 发布： [release-workflow.md](./release-workflow.md)
- 平台差异： [../10-project/ui-and-platform-quirks.md](../10-project/ui-and-platform-quirks.md)
