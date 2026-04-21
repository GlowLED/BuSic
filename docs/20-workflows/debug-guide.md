# BuSic 调试指南

这份文档只关注 **在 BuSic 里最容易踩坑的调试点**。

## 1. 调试前的最低准备

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

如果执行者是运行在沙箱中的 agent，请预期 `flutter ...`、`dart run ...` 和远程/写入型 Git 往往需要提权到沙箱外；本地只读 Git（如 `git status`、`git log`、`git diff`）通常可先在沙箱内尝试。统一分类见 [../00-start-here/agent-quickstart.md](../00-start-here/agent-quickstart.md)。

如果你改的是普通 UI 且没有碰 codegen，`build_runner` 可以跳过；但一旦怀疑生成代码过期，先重跑，不要带着脏产物继续查问题。

## 2. 推荐的调试入口

### 2.1 Windows

```bash
flutter run -d windows
```

适合查：

- 主导航壳层
- 桌面标题栏
- 托盘
- 关闭窗口行为
- 极简模式

### 2.2 Android

```bash
flutter run -d <device_id>
```

适合查：

- 后台播放
- 音频会话
- 登录态
- 真实网络请求
- 字幕、下载、评论等 B 站相关链路

## 3. 持续代码生成

如果你正在高频修改：

- Riverpod Notifier
- Freezed 模型
- Drift 表结构

可以单开一个终端：

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 4. BuSic 特有的调试面

### 4.1 启动失败先看 `main.dart`

项目启动不是单纯 `runApp()`，还会依次初始化：

- `media_kit`
- Drift
- `BiliDio`
- `audio_service`
- 桌面窗口 / 托盘
- 极简模式 override

所以“应用进不来”不一定是 UI 问题。

### 4.2 登录态 / B 站请求异常先看 `bili_dio.dart`

先排查：

- Cookie 是否已持久化
- raw cookie 注入是否被改坏
- `Referer` / `User-Agent` 是否仍在
- 是否错误改成了标准 Cookie 解析路径

### 4.3 下载问题不要只看下载任务

下载完成后的真实联动包括：

- 文件落地
- `download_tasks` 状态变化
- `songs.localPath` 回写
- `songs.audioQuality` 回写
- 播放器离线优先逻辑刷新

如果你只盯着下载队列，很容易漏掉根因。

### 4.4 字幕问题不要只看“有没有返回”

字幕链路还有这些判断：

- 本地缓存是否命中
- aid 解析是否成功
- `/x/player/v2` 是否返回字幕列表
- AI 字幕 URL 前缀是否通过校验
- 重试次数是否耗尽

“请求成功但字幕不对”通常是错配，不是接口完全失效。

### 4.5 桌面端退出行为容易误判

桌面端关闭窗口默认是隐藏到托盘，不是彻底退出。

相关文件：

- `lib/shared/widgets/responsive_scaffold.dart`
- `lib/core/window/window_service.dart`
- `lib/core/window/tray_service.dart`

### 4.6 极简模式不是普通页面

`/minimal` 有自己的生命周期策略：

- `paused / resumed` 不主动干预播放
- `detached` 才做彻底停止

排查极简模式时不要套用普通页面假设。

## 5. 日志与工具

### 5.1 日志

项目优先使用 `AppLogger`，不要新增 `print()` 作为长期日志方案。

### 5.2 Android 日志过滤

```bash
adb logcat -s flutter
```

### 5.3 分析与测试

```bash
flutter analyze --no-fatal-infos
flutter test
```

如果这两条命令在 agent 沙箱内异常超时或卡在工具引导阶段，先按上面的规则提权重跑，不要先假设是项目本身坏了。

很多“运行时异常”其实是早就能被分析或测试发现的结构问题。

自动化测试的目录、维护规则和当前覆盖现状见：

- [testing-guide.md](./testing-guide.md)

如果需要真机 / 模拟器交互验证，再看：

- [../30-reference/device-testing.md](../30-reference/device-testing.md)

## 6. 热重载边界

以下场景优先使用 Hot Restart 或重启应用：

- 改了 `main()`
- 改了 Provider 初始化
- 改了全局依赖注入
- 改了原生插件相关配置
- 改了窗口 / 托盘初始化
- 改了 `audio_service` 启动链路

## 7. 常见修复动作

### 7.1 清理生成产物

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 7.2 重新确认 source of truth

优先看：

- `lib/main.dart`
- `lib/core/router/app_router.dart`
- `lib/core/database/app_database.dart`
- `lib/core/api/bili_dio.dart`
- `lib/features/player/application/player_notifier.dart`

### 7.3 做一轮最小回归

高风险改动后至少手测：

- 登录
- 搜索或 BV 解析
- 播放
- 下载完成后的离线播放
- 字幕显示
- 分享 / 备份导入
- 桌面端关闭窗口行为

## 8. 继续阅读

- 构建： [build-guide.md](./build-guide.md)
- 开发流程： [dev-workflow.md](./dev-workflow.md)
- 测试维护： [testing-guide.md](./testing-guide.md)
- B 站集成： [../10-project/bilibili-integration.md](../10-project/bilibili-integration.md)
- 字幕与歌词： [../10-project/subtitle-and-lyrics.md](../10-project/subtitle-and-lyrics.md)
- 平台差异： [../10-project/ui-and-platform-quirks.md](../10-project/ui-and-platform-quirks.md)
