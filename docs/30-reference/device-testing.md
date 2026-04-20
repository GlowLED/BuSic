# 真机 / 模拟器交互测试指南（面向 LLM Agent）

本文档描述 AI 编码 Agent 在修复 Bug 或实现功能后，如何通过 ADB + `flutter run` 进行真机（或模拟器）交互测试验证。

## 前置条件

- 模拟器/真机已通过 ADB 连接（MuMu 模拟器地址 `127.0.0.1:7555`）
- PATH 中已包含 Flutter 和 Android SDK platform-tools

```powershell
$env:Path = "C:\dev\flutter\bin;$env:LOCALAPPDATA\Android\Sdk\platform-tools;" + $env:Path
```

## 测试流程

### 1. 确认设备连接

```powershell
adb devices -l
```

若无设备，重连：

```powershell
adb kill-server; Start-Sleep -Seconds 2; adb start-server; Start-Sleep -Seconds 2; adb connect 127.0.0.1:7555; Start-Sleep -Seconds 3; adb devices -l
```

### 2. 构建并部署

使用 **后台终端** 启动 `flutter run`，以免阻塞后续命令：

```powershell
flutter run -d 127.0.0.1:7555 --debug
```

- 设置 `isBackground = true`，等待构建完成
- 用 `get_terminal_output` 检查输出，确认 `Syncing files to device` / `Flutter run key commands` 出现即表示启动成功
- **正常情况下最多等待 10 秒**，超时视为有其他错误

### 3. 检查构建输出

在 `get_terminal_output` 的结果中确认：

| 关键输出 | 含义 |
|---|---|
| `√ Built build\app\outputs\flutter-apk\app-debug.apk` | APK 构建成功 |
| `Syncing files to device` | 文件同步完成 |
| `Flutter run key commands` | 应用已启动，可交互 |
| `[ERROR]` | 运行时错误，需排查 |

### 4. 需要用户交互的场景

**ADB 无法直接操作的情况：**
- 设置剪贴板内容（Android 10+ 限制后台剪贴板访问）
- 需要多步 UI 交互的操作流（如：导航到特定页面 → 点击按钮 → 观察结果）
- 验证 UI 展示效果（对话框是否正确显示/关闭、动画是否流畅）

**处理方式：** 使用 `ask_questions` 工具向用户描述具体操作步骤，提供预设选项让用户快速反馈测试结果：

```
ask_questions:
  question: "请在模拟器中执行以下操作：
    1. [具体步骤1]
    2. [具体步骤2]
    3. [具体步骤3]
    请告诉我测试结果："
  options:
    - "测试通过，功能正常"
    - "仍然存在问题"
    - "出现新问题"
  allowFreeformInput: true   # 允许用户描述具体现象
```

**ADB 可以辅助的操作：**

```powershell
# 启动特定 Activity
adb -s 127.0.0.1:7555 shell am start -n com.busic.busic/.MainActivity

# 发送按键事件
adb -s 127.0.0.1:7555 shell input keyevent KEYCODE_BACK

# 截屏查看状态
adb -s 127.0.0.1:7555 shell screencap -p /sdcard/screen.png
adb -s 127.0.0.1:7555 pull /sdcard/screen.png ./screen.png

# 查看应用日志（过滤 Flutter）
adb -s 127.0.0.1:7555 logcat -s flutter --format=brief
```

### 5. 验证修复结果

从 `flutter run` 的输出中检查：

- **无 `[ERROR]` 日志** → 运行正常
- 出现具体 `[ERROR]` → 根据栈信息定位并继续修复
- Flutter 断言失败 → 通常是 Widget 生命周期或导航问题

### 6. 测试完成后

如果测试通过且不再需要调试：

```powershell
# 在 flutter run 终端中按 q 退出
# 或使用进程管理
Get-Process -Name "flutter*","dart*" -ErrorAction SilentlyContinue | Stop-Process -Force
```

## 常见测试场景速查

| 场景 | 测试方法 |
|---|---|
| 导航/路由修复 | 用户操作触发导航 → 检查无 `go_router` 断言错误 |
| 对话框弹出/关闭 | 用户触发 → 确认无黑屏、无 `Navigator` 断言错误 |
| 数据导入/导出 | 用户准备数据 → 执行操作 → 确认 SnackBar 提示结果 |
| 播放器功能 | 选择歌曲播放 → 检查日志中无异常 |
| 网络请求 | 执行操作 → 检查日志中 API 调用是否正常 |

## 注意事项

1. **Navigator.pop 与 go_router**：在 go_router 中使用 `showDialog` 后关闭对话框时，必须使用 `Navigator.of(context, rootNavigator: true).pop()`，因为 `showDialog` 默认将对话框推入根 Navigator，而 `Navigator.of(context).pop()` 会弹出 go_router 嵌套 Navigator 中的页面路由。
2. **AutoDispose 注意**：异步操作中如果中途被 dispose，`context.mounted` 检查会返回 false，需要在适当位置加 `ref.keepAlive()`。
3. **构建缓存**：如果构建行为异常，先执行 `flutter clean` 再重新构建。
