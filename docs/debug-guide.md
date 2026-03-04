# BuSic 调试指南

本文档描述如何在本地进行热调试（Hot Reload / Hot Restart）及断点调试。

## 前置条件

1. 已完成 [构建指南](build-guide.md) 中的环境搭建（步骤 1-5）
2. 代码生成文件已就绪（`.g.dart`、`.freezed.dart`、`lib/l10n/generated/`）

## 1. VS Code 调试（推荐）

### 安装 Flutter 扩展

```powershell
code --install-extension Dart-Code.flutter
```

### 启动调试

1. 在 VS Code 中打开项目根目录
2. 按 **F5** 或点击 Debug 面板的 **Run and Debug**
3. 选择目标设备（Windows / Android / Chrome）

### 调试功能

| 功能 | 操作 |
|---|---|
| Hot Reload | **Ctrl+S** 保存文件时自动触发 |
| Hot Restart | **Ctrl+Shift+F5** |
| 断点 | 点击行号左侧设置断点 |
| 变量观察 | Debug 面板 → Variables / Watch |
| DevTools | 命令面板 → `Flutter: Open DevTools` |
| Widget Inspector | 命令面板 → `Flutter: Open Widget Inspector` |

### launch.json 配置（可选）

在 `.vscode/launch.json` 中自定义调试配置：

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "BuSic (Windows)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "deviceId": "windows"
    },
    {
      "name": "BuSic (Android)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart"
    },
    {
      "name": "BuSic (Profile Mode)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "flutterMode": "profile"
    }
  ]
}
```

## 2. 终端调试

### Windows 桌面

```powershell
flutter run -d windows
```

### Android 设备/模拟器

```powershell
# 列出已连接设备
flutter devices

# 运行到指定设备
flutter run -d <device_id>
```

### Chrome (Web)

```powershell
flutter run -d chrome
```

### 终端快捷键

应用启动后，在运行终端中可以使用以下快捷键：

| 按键 | 功能 |
|---|---|
| `r` | Hot Reload — 保持状态，仅刷新改动的 Widget |
| `R` | Hot Restart — 重置状态，重新启动应用 |
| `o` | 切换 Android/iOS 模拟平台 |
| `p` | 切换显示构建网格 |
| `i` | 切换 Widget Inspector |
| `P` | 切换性能覆盖层 |
| `q` | 退出 |

## 3. 持续代码生成（Watch 模式）

在调试期间如需修改 Freezed 模型、Riverpod Provider 或 Drift 表定义，在**另一个终端**开启 watch 模式：

```powershell
dart run build_runner watch --delete-conflicting-outputs
```

这样保存 `.dart` 源文件后会自动重新生成 `.g.dart` / `.freezed.dart`，配合 Hot Reload 即时生效。

> 如果只是修改 Widget UI 或业务逻辑（不涉及代码生成），则无需开启 watch 模式。

## 4. 性能调试

### Profile 模式

Profile 模式可在真机上进行性能分析（不可用于模拟器）：

```powershell
flutter run --profile -d <device_id>
```

### Flutter DevTools

```powershell
# 启动 DevTools（在调试运行中）
flutter pub global activate devtools
dart devtools
```

DevTools 提供：
- **Widget Inspector** — Widget 树结构、布局约束可视化
- **Performance** — 帧渲染时间分析、Jank 检测
- **CPU Profiler** — Dart 代码执行热点
- **Memory** — 内存分配与泄漏检测
- **Network** — HTTP 请求日志

## 5. 日志查看

项目禁止使用 `print()`，统一使用 `AppLogger` 输出日志。

### VS Code

日志自动显示在 **Debug Console** 面板中。

### 终端

日志直接输出到运行 `flutter run` 的终端。

### Android 设备日志过滤

```powershell
adb logcat -s flutter
```

## 6. 常见问题

### Hot Reload 不生效

以下变更需要 **Hot Restart**（而非 Hot Reload）：
- 修改 `main()` 函数
- 修改全局变量的初始值
- 修改枚举类型
- 修改泛型类型参数
- 修改原生插件代码

### 代码生成文件报错

```powershell
# 清理后重新生成
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Windows 调试闪退

确保已启用开发者模式（参见 [构建指南](build-guide.md#3-启用-windows-开发者模式)）。

### 端口占用

如 DevTools 端口被占用：

```powershell
flutter run --devtools-server-port=9200
```
