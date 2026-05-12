# UI And Platform Quirks

这份文档只记录 BuSic 在 UI、桌面 / 移动适配、窗口与极简模式方面的特化行为。

## 1. 主壳层：`ResponsiveScaffold`

`lib/shared/widgets/responsive_scaffold.dart` 是主导航壳层。

当前行为：
- 桌面宽度达到断点时：
  - 不再使用默认 `NavigationRail`
  - 使用「自定义标题栏 + 自定义侧栏 + 内容框架 + 底部 `PlayerBar`」的组合
  - 侧栏仍负责四个主分支入口
  - 侧栏始终使用纯图标的紧凑 icon dock，右侧内容区优先获得可用宽度
  - 紧凑 icon dock 不显示文字，也不显示 hover 名称小窗
  - 侧栏底部有用户头像组件（`UserAvatarWidget`），属于壳层视觉的一部分
- 移动端：
  - 不再使用默认 `NavigationBar`
  - 使用浮动底部 dock 作为主导航
  - `PlayerBar` 仍常驻在页面内容与底部 dock 之间
  - `PopScope` 仍会在返回时先做输入框失焦处理

因此，改任意主导航页面时，要同时考虑：
- 桌面标题栏和侧栏
- 移动端底部 dock
- `PlayerBar` 是否仍正确显示

## 2. Windows 中文字体渲染

Windows 桌面端的中文正文使用全局主题里的系统字体策略：

- 首选 `Microsoft YaHei UI`
- fallback：`Microsoft YaHei`、`Segoe UI`、`Arial`
- 正文 `bodyLarge / bodyMedium / bodySmall` 在 Windows 上使用 `FontWeight.w400`
- 标题、标签、按钮等强调文本仍保留现有 `w600 / w700`

原因是 Windows CJK 字体 fallback 和 `w500` 伪中粗容易在长中文段落中出现粗细不均。改 `AppTheme` 或长文本页面时，不要在局部重新把正文中文强行设回 `w500`。

## 3. 自定义桌面标题栏

桌面标题栏不是系统默认标题栏，而是壳层自绘的一部分，并且和侧栏共用同一套 surface / border / glow 视觉语言：
- 左侧拖拽区显示应用品牌和当前分支标题
- 右侧窗口控制按钮负责最小化、最大化 / 还原
- 关闭按钮默认仍是 **hide to tray**
- Linux 使用 `DesktopWindowResizeFrame` 在应用根部补透明 resize 边缘；隐藏系统标题栏后不能依赖 GNOME / Cinnamon 自动提供窗口边缘调整区域

这意味着“点关闭 = 退出程序”在桌面端并不成立。

## 4. 托盘行为

`TrayService` 当前负责：
- 托盘图标
- 右键菜单
- 点击托盘恢复窗口
- Quit 时显式销毁窗口和托盘

如果你改桌面退出、窗口隐藏、语言切换后的托盘菜单，必须一起看：
- `lib/core/window/tray_service.dart`
- `lib/core/window/window_service.dart`

## 5. 极简模式不是普通主题变体

极简模式当前是：
- 独立路由 `/minimal`
- 应用启动默认不再直接进入极简模式
- 仍会读取已绑定的歌单 ID 作为极简页内部播放来源
- 有自己的独立生命周期策略
- 它不是点击底部播放栏后打开的全屏播放页；全屏播放页是独立路由 `/player`

## 6. 极简模式生命周期策略

这是 BuSic 很特化的一条规则：
- `paused / resumed / hidden`：**不干预播放**
- `detached`：彻底停止播放并停止音频服务

原因是 Flutter 无法可靠区分锁屏和切后台。
如果在 `paused` 里暂停，锁屏听歌会断；如果在 `resumed` 里做播放切换，解锁会误触发。

## 7. 全屏播放器与其他页面的手势关系

全屏播放器并不只是一个静态页面：
- 点击底部 `PlayerBar` 的封面或歌曲信息会进入独立路由 `/player`
- 桌面端顶部栏提供窗口拖动、最小化、最大化 / 还原和关闭到托盘；关闭仍遵守桌面规则：隐藏到托盘，不退出程序
- 横向切换评论
- 纵向切换歌词 / 封面
- 与底部进度条、控制条共存
- PC 宽屏布局右侧内容区额外提供 `信息 / 歌词 / 评论` 分段切换入口，用于显式切换现有 PageView 页面

改全屏播放器 UI 时，不要只看单个 Widget，还要看整套 PageView 与手势冲突。

## 8. 最常见误区

- 以为桌面端关闭就等于退出
- 以为极简模式只是换皮
- 以为主壳层仍然是默认 `NavigationRail` / `NavigationBar`
- 以为紧凑侧栏仍然会显示文字或 tooltip
- 只在一个平台验证就提交

## 9. 修改这部分时要一起看什么？

- `lib/shared/widgets/responsive_scaffold.dart`
- `lib/shared/widgets/desktop_window_resize_frame.dart`
- `lib/core/window/window_service.dart`
- `lib/core/window/tray_service.dart`
- `lib/features/minimal/presentation/minimal_screen.dart`
- `lib/features/player/presentation/full_player_screen.dart`
