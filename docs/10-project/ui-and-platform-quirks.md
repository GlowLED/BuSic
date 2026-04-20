# UI And Platform Quirks

这份文档只记录 BuSic 在 UI、桌面 / 移动端适配、窗口与极简模式方面的特化行为。

## 1. 主壳层：`ResponsiveScaffold`

`lib/shared/widgets/responsive_scaffold.dart` 是主导航壳层。

当前行为：

- 桌面宽度达到断点时：
  - 使用 `NavigationRail`
  - 显示自定义标题栏
  - 底部始终有 `PlayerBar`
- 移动端：
  - 使用 `NavigationBar`
  - `PlayerBar` 仍常驻底部
  - `PopScope` 会在返回时做输入框失焦处理

因此，改任意主导航页时，要同时考虑：

- 桌面 rail
- 移动端 bottom nav
- `PlayerBar` 是否仍正确显示

## 2. 自定义桌面标题栏

桌面标题栏不是系统默认标题栏，而是自绘：

- 拖拽移动窗口
- 最小化
- 最大化 / 还原
- 关闭按钮默认是 **hide to tray**

这意味着“点关闭 = 退出程序”在桌面端并不成立。

## 3. 托盘行为

`TrayService` 当前负责：

- 托盘图标
- 右键菜单
- 点击托盘恢复窗口
- Quit 时显式销毁窗口和托盘

如果你改桌面退出、窗口隐藏、语言切换后的托盘菜单，必须一起看：

- `lib/core/window/tray_service.dart`
- `lib/core/window/window_service.dart`

## 4. 极简模式不是普通主题变体

极简模式当前是：

- 独立路由 `/minimal`
- 启动时可由 `main.dart` 直接决定初始入口
- 有单独的 SharedPreferences 开关和绑定歌单 ID
- 有自己独立的生命周期策略

## 5. 极简模式生命周期策略

这是 BuSic 很特化的一条规则：

- `paused / resumed / hidden`：**不干预播放**
- `detached`：彻底停止播放并停止音频服务

原因是 Flutter 无法可靠区分锁屏和切后台。  
如果在 `paused` 里暂停，锁屏听歌会断；如果在 `resumed` 里做播放切换，解锁会误触发。

## 6. 全屏播放器与其他页面的手势关系

全屏播放器并不只是一个静态页面：

- 横向切换评论
- 纵向切换歌词 / 封面
- 与底部进度条、控制条共存

改全屏播放器 UI 时，不要只看单个 Widget，还要看整套 PageView 与手势冲突。

## 7. 最常见误区

- 以为桌面端关闭就是退出
- 以为极简模式只是换皮
- 以为主页面只有移动端 BottomNavigation
- 只在一个平台验证就提交

## 8. 修改这部分时要一起看什么

- `lib/shared/widgets/responsive_scaffold.dart`
- `lib/core/window/window_service.dart`
- `lib/core/window/tray_service.dart`
- `lib/features/minimal/presentation/minimal_screen.dart`
- `lib/features/player/presentation/full_player_screen.dart`
