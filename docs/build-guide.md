# BuSic 构建指南

本文档描述如何从零搭建本地构建环境，并构建各平台发行版。

## 前置条件

| 工具 | 最低版本 | 说明 |
|---|---|---|
| Flutter SDK | 3.16+ | [安装指南](https://docs.flutter.dev/get-started/install) |
| Dart SDK | 3.2+ | 随 Flutter 一起安装 |
| Visual Studio Build Tools | 2019+ | Windows 构建需要，安装时勾选"C++ 桌面开发" |
| Android SDK | API 35+ | Android 构建需要 |
| JDK | 11+ | Android 签名 & Gradle 构建需要 |

## 1. 安装 Flutter SDK

### Windows

```powershell
# 克隆 stable 分支（浅克隆加速）
git clone https://github.com/flutter/flutter.git -b stable C:\dev\flutter --depth 1

# 添加到用户 PATH（永久生效）
[System.Environment]::SetEnvironmentVariable(
  "Path",
  "C:\dev\flutter\bin;" + [System.Environment]::GetEnvironmentVariable("Path", "User"),
  "User"
)

# 当前会话立即生效
$env:PATH = "C:\dev\flutter\bin;" + $env:PATH

# 验证安装
flutter --version
```

### macOS / Linux

参考 [Flutter 官方安装文档](https://docs.flutter.dev/get-started/install)。

## 2. 配置 Android 工具链

### 安装 cmdline-tools（如缺失）

```powershell
$sdkRoot = "$env:LOCALAPPDATA\Android\sdk"
$url = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
$zip = "$env:TEMP\cmdline-tools.zip"

Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
Expand-Archive -Path $zip -DestinationPath "$sdkRoot\cmdline-tools" -Force
Rename-Item "$sdkRoot\cmdline-tools\cmdline-tools" "$sdkRoot\cmdline-tools\latest"
Remove-Item $zip -Force
```

### 接受 SDK 许可证

```powershell
flutter doctor --android-licenses
```

按提示输入 `y` 接受所有许可证。

## 3. 启用 Windows 开发者模式

Flutter 插件需要符号链接支持，需启用开发者模式：

```powershell
# 以管理员权限运行
Start-Process powershell -Verb RunAs -ArgumentList '-Command',
  'reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"'
```

或手动：**设置 → 系统 → 开发者选项 → 开发人员模式 → 开启**。

## 4. 安装项目依赖

```powershell
cd <项目根目录>
flutter pub get
```

### 常见依赖冲突

若 `intl` 版本与 `flutter_localizations` 冲突：

```powershell
flutter pub add intl:^0.20.2
```

## 5. 代码生成

项目使用 Freezed、Riverpod codegen、Drift、json_serializable，修改模型/Provider/表定义后**必须**运行代码生成：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

同时需要生成 l10n 本地化文件：

```powershell
flutter gen-l10n
```

生成的文件类型：

| 后缀 | 内容 |
|---|---|
| `.g.dart` | Riverpod providers、JSON 序列化、Drift 数据库 |
| `.freezed.dart` | Freezed 不可变类 |
| `lib/l10n/generated/` | 国际化本地化代码 |

> **注意**：生成文件不手动编辑，已在 `.gitignore` 中排除。

## 6. 构建发行版

### 6.1 Windows

```powershell
flutter build windows --release
```

产物位置：`build/windows/x64/runner/Release/`

整个 `Release/` 目录即为可分发的 Windows 应用，包含：
- `busic.exe` — 主程序
- `flutter_windows.dll` — Flutter 引擎
- `libmpv-2.dll` — 媒体播放引擎
- `data/` — Flutter 资源文件
- 其他插件 DLL

### 6.2 Android APK

#### 签名配置

构建 Release APK 需要签名密钥。

**生成 keystore**（首次）：

```powershell
keytool -genkey -v `
  -keystore android/app/upload-keystore.jks `
  -storetype JKS `
  -keyalg RSA -keysize 2048 `
  -validity 10000 `
  -alias upload `
  -storepass <你的密码> `
  -keypass <你的密码> `
  -dname "CN=BuSic, OU=Dev, O=GlowLED, L=Beijing, ST=Beijing, C=CN"
```

**创建签名配置文件** `android/key.properties`：

```properties
storePassword=<你的密码>
keyPassword=<你的密码>
keyAlias=upload
storeFile=upload-keystore.jks
```

> ⚠️ `key.properties` 和 `*.jks` 已在 `.gitignore` 中，不会被提交。

**构建**：

```powershell
flutter build apk --release
```

产物位置：`build/app/outputs/flutter-apk/app-release.apk`

#### 拆分 ABI 构建（可选，减小 APK 体积）

```powershell
flutter build apk --release --split-per-abi
```

将生成 `app-arm64-v8a-release.apk`、`app-armeabi-v7a-release.apk`、`app-x86_64-release.apk` 三个 APK。

### 6.3 Android App Bundle

```powershell
flutter build appbundle --release
```

产物位置：`build/app/outputs/bundle/release/app-release.aab`

### 6.4 Web（可选）

```powershell
flutter build web --release
```

产物位置：`build/web/`

### 6.5 macOS / iOS / Linux

| 平台 | 要求 | 命令 |
|---|---|---|
| macOS | macOS + Xcode | `flutter build macos --release` |
| iOS | macOS + Xcode + Apple 开发者账号 | `flutter build ios --release` |
| Linux | Linux + clang/cmake/gtk3 | `flutter build linux --release` |

> 这些平台无法在 Windows 上交叉编译，需在对应系统上构建。

## 7. 验证环境

```powershell
flutter doctor -v
```

所有目标平台应显示 `[✓]`。

## 产物大小参考

| 平台 | 类型 | 大致大小 |
|---|---|---|
| Windows | Release 目录 | ~36 MB |
| Android | APK (全架构) | ~80 MB |
| Android | APK (仅 arm64) | ~30 MB |
