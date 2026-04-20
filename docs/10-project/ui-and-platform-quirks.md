# UI And Platform Quirks

这份文档只记录 BuSic 在 UI、桌面 / 移动适配、窗口与极简模式方面的特化行为。

## 1. 主壳层：`ResponsiveScaffold`

`lib/shared/widgets/responsive_scaffold.dart` 是主导航壳层。

当前行为：
- 桌面宽度达到断点时：
  - 不再使用默认 `NavigationRail`
  - 使用「自定义标题栏 + 自定义侧栏 + 内容框架 + 底部 `PlayerBar`」的组合
  - 侧栏仍负责四个主分支入口
  - 宽屏显示图标 + 文案，窄桌面显示纯图标的紧凑 icon dock
  - 紧凑 icon dock 不显示文字，也不显示 hover 名称小窗
  - 侧栏底部有当前播放状态卡片，仍属于壳层视觉的一部分
- 移动端：
  - 不再使用默认 `NavigationBar`
  - 使用浮动底部 dock 作为主导航
  - `PlayerBar` 仍常驻在页面内容与底部 dock 之间
  - `PopScope` 仍会在返回时先做输入框失焦处理

因此，改任意主导航页面时，要同时考虑：
- 桌面标题栏和侧栏
- 移动端底部 dock
- `PlayerBar` 是否仍正确显示

## 2. 自定义桌面标题栏

桌面标题栏不是系统默认标题栏，而是壳层自绘的一部分，并且和侧栏共用同一套 surface / border / glow 视觉语言：
- 左侧拖拽区显示应用品牌和当前分支标题
- 右侧窗口控制按钮负责最小化、最大化 / 还原
- 关闭按钮默认仍是 **hide to tray**

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
- 应用启动默认不再直接进入极简模式
- 仍会读取已绑定的歌单 ID 作为极简页内部播放来源
- 有自己的独立生命周期策略

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

- 以为桌面端关闭就等于退出
- 以为极简模式只是换皮
- 以为主壳层仍然是默认 `NavigationRail` / `NavigationBar`
- 以为紧凑侧栏仍然会显示文字或 tooltip
- 只在一个平台验证就提交

## 8. 修改这部分时要一起看什么？

- `lib/shared/widgets/responsive_scaffold.dart`
- `lib/core/window/window_service.dart`
- `lib/core/window/tray_service.dart`
- `lib/features/minimal/presentation/minimal_screen.dart`
- `lib/features/player/presentation/full_player_screen.dart`
