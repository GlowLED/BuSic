# UI And Platform Quirks

这份文档只记录 BuSic 在 UI、桌面 / 移动适配、窗口与极简模式方面的特化行为。

## 1. 主壳层：`ResponsiveScaffold`

`lib/shared/widgets/responsive_scaffold.dart` 是主导航壳层。

当前行为：
- 桌面平台且宽度达到断点时：
  - 不再使用默认 `NavigationRail`
  - 使用「自定义标题栏 + 自定义侧栏 + 内容框架 + 底部 `PlayerBar`」的组合
  - 侧栏仍负责四个主分支入口
  - 侧栏始终使用纯图标的紧凑 icon dock，右侧内容区优先获得可用宽度
  - 紧凑 icon dock 不显示文字，也不显示 hover 名称小窗
  - 侧栏底部有用户头像组件（`UserAvatarWidget`），属于壳层视觉的一部分
- 移动端：
  - 不再使用默认 `NavigationBar`
  - 竖屏使用只显示名称的紧凑底部 dock，降低导航栏高度占用
  - 横屏使用类似桌面端的左侧纯图标导航栏，不显示名称
  - `PlayerBar` 仍常驻在页面内容与主导航之间
  - `PopScope` 仍会在返回时先做输入框失焦处理

因此，改任意主导航页面时，要同时考虑：
- 桌面标题栏和侧栏
- 移动端竖屏底部 dock 与横屏左侧图标栏
- `PlayerBar` 是否仍正确显示

### 1.1 全局背景图片

设置在「设置 → 背景」中，由 `BackgroundSection` 管理：

- 用户选择本地图片后，**复制到应用私有目录** `Documents/busic/backgrounds/`（`PlatformUtils.getDataPath()`），路径以字符串存入 SharedPreferences；移除 / 更换背景时清理旧副本。不引用原图路径，原图被移动或删除不影响
- 渲染位置是 `ResponsiveScaffold` 的 `_ShellBackdrop`：主题渐变始终保留在底层作兜底，图片层叠加在渐变之上、所有内容（标题栏 / 侧栏 / 内容 / `PlayerBar`）之下
- 三个设置字段都持久化在 `UserPreferences`：`backgroundImagePath`（null = 无背景）、`backgroundImageOpacity`（0.0–1.0，默认 0.5）、`backgroundImageBlur`（sigma 0–60，默认 0）
- 模糊度为 0 时**跳过 `ImageFiltered`**（避免无谓的模糊管线开销）；背景使用固定 `1024 × 1024` 解码上界和稳定缓存 key，不随窗口每像素变化而重复解码，合法切换图片时会保留上一帧；`ResizeImagePolicy.fit` 保持图片原始宽高比、再由 `BoxFit.cover` 裁切铺满窗口，图片不会为了适配窗口而拉伸变形；文件缺失或解码失败时平滑回落到主题渐变
- 仅主壳层四个主页面生效。全屏播放器 `/player`、极简模式 `/minimal` 是独立沉浸路由、自带封面模糊 / 毛玻璃背景，**不叠加**背景图片；`/login` 也保持现状

### 1.2 背景图片模式下的组件半透明

有背景图片时，主壳层内所有组件表面（面板、卡片、列表行、`PlayerBar`、设置分区、对话框 / 底部弹层 / 菜单 / 输入框）统一变为半透明，让背景图全应用透出。无背景图片时完全保持现状（全不透明）。

- 联动规则：组件不透明度 `surfaceOpacity = 0.9 − 0.35 × backgroundImageOpacity`，钳制在 `[0.55, 0.9]`——背景越明显组件越透明，保底区间保证文字可读
  - 背景透明度 0.5（默认）→ 组件 0.725；1.0 → 0.55；接近 0 → 0.9
- 实现：`AppThemePalette` 新增 `surfaceOpacity` token（默认 1.0），`AppTheme.lightTheme/darkTheme` 新增同名可选参数；`app.dart` 根据 `settings.backgroundImagePath/Opacity` 计算后传入。主题级 `cardTheme / dialogTheme / bottomSheetTheme / popupMenuTheme / snackBarTheme / tooltipTheme / inputDecorationTheme` 背景色统一乘 `surfaceOpacity`；局部不走主题的组件（`SettingsSectionPanel`、`PlaylistTile`、`_PlayerBarSurface`、视频详情 Tab 头、歌单详情页 header）单独读取该 token
- `AppPanel` 默认毛玻璃渐变（0.96 / 0.92）同样乘 `surfaceOpacity`，搜索条与搜索结果卡片自动联动；搜索框本身 `filled: false` 透明。播放条内音质徽标、移动端转盘 hub、圆形播放按钮也同步联动
- 弹层（对话框 / 底部弹层 / 菜单）一并半透明；`_ShellBackdrop` 底层渐变保留不透明作兜底
- 已带固定透明度的小徽标 / 按钮底 / 角标（如 `_VideoBadge` 0.72、`_AccessoryPill` 0.9 等）保持现状，不做乘法联动
- 独立沉浸路由 `/player`、`/minimal`、`/login` 不联动

### 1.3 桌面界面缩放与响应式重排

桌面端提供统一界面缩放，当前范围为 80%–150%、步长 10%、默认 100%，
并通过 `SettingsNotifier` 写入本地偏好。移动端不显示该设置且固定使用 100%。

根级 `AppUiScaler` 会同时缩放字体、图标、间距、组件、路由、弹窗、
SnackBar、自绘标题栏和内置 Web 登录。它也会把 `MediaQuery` 的逻辑尺寸、
DPR、安全区和键盘 inset 换算到缩放后的坐标系，因此放大界面时有效宽度会
变小，主壳层可能自然切换到紧凑布局。这是预期的浏览器式重排，不应通过
固定断点分支绕过。

平台边界：

- Linux `DesktopWindowResizeFrame` 必须保持在缩放层之外。
- 原生窗口大小、托盘和系统字体设置不受影响。
- Windows / macOS 修改缩放实现后需要手测内置 WebView 的显示和点击坐标。
- 快捷键支持 `Ctrl + + / = / - / 0` 和数字键盘；macOS 额外支持 `Command`。

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

Windows 的 `tray_manager` 通过 Win32 `LoadImage(..., IMAGE_ICON)` 从文件系统加载托盘图标，因此必须传入 `.ico`，不能复用 PNG。当前 `windows/CMakeLists.txt` 会把 `windows/runner/resources/app_icon.ico` 复制到运行目录的 `data/flutter_assets/assets/images/app_icon.ico`，`TrayService` 再使用该相对 asset 路径；Linux / macOS 继续使用 PNG。

如果你改桌面退出、窗口隐藏、语言切换后的托盘菜单，必须一起看：
- `lib/core/window/tray_service.dart`
- `lib/core/window/window_service.dart`

## 5. macOS App Sandbox 权限

macOS Runner 启用了 App Sandbox，因此 Debug / Profile 和 Release 的 entitlement 都必须声明：

- `com.apple.security.network.client = true`
- `com.apple.security.files.user-selected.read-write = true`

网络权限是所有出站网络请求的共同前提。缺失时，更新检查、B 站接口、网络封面和内置 Web 登录会统一出现 `SocketException: Operation not permitted`；这不是 Dio、目标站点或 CocoaPods 故障。

文件访问权限是 `file_picker` 弹窗（NSOpenPanel / NSSavePanel）的共同前提。缺失时选择背景图片、歌单封面、备份导入 / 导出会直接抛 `PlatformException(ENTITLEMENT_NOT_FOUND)`，且**不会弹出文件选择框**；这不是 file_picker 或平台通道故障。选择 read-write 而不是 read-only，是因为备份导出还要写入用户所选位置。

当前真源：

- `macos/Runner/DebugProfile.entitlements`
- `macos/Runner/Release.entitlements`

修改 macOS 签名或沙箱配置时必须同时检查两份文件，避免 Debug 可用但 Release 失去网络或文件访问能力。

## 6. Linux MPRIS 只能按平台启用

Linux 桌面通过 MPRIS / D-Bus 接入系统媒体控件、桌面壳层和硬件媒体键。当前平台边界是：

- `playerMprisServiceProvider` 只在 Linux 返回 `MprisService`
- Windows、macOS、Android 和 iOS 返回 `null`，不能尝试创建 D-Bus client
- `PlayerNotifier` 对初始化、状态同步和销毁都使用空安全调用

真源：

- `lib/features/player/application/player_notifier.dart`
- `lib/core/services/mpris_service.dart`
- `lib/core/services/mpris_service_dbus.dart`

修改播放器生命周期或媒体会话时，要保留这个平台门禁；仅在 `MprisService.init()` 内再次判断平台不足以避免非 Linux 构造或销毁阶段的异常。

## 7. 极简模式不是普通主题变体

极简模式当前是：
- 独立路由 `/minimal`
- 应用启动默认不再直接进入极简模式
- 仍会读取已绑定的歌单 ID 作为极简页内部播放来源
- 有自己的独立生命周期策略
- 它不是点击底部播放栏后打开的全屏播放页；全屏播放页是独立路由 `/player`

## 8. 极简模式生命周期策略

这是 BuSic 很特化的一条规则：
- `paused / resumed / hidden`：**不干预播放**
- `detached`：彻底停止播放并停止音频服务

原因是 Flutter 无法可靠区分锁屏和切后台。
如果在 `paused` 里暂停，锁屏听歌会断；如果在 `resumed` 里做播放切换，解锁会误触发。

## 9. 全屏播放器与其他页面的手势关系

全屏播放器并不只是一个静态页面：
- 点击底部 `PlayerBar` 的封面或歌曲信息会进入独立路由 `/player`
- 桌面端顶部栏提供窗口拖动、最小化、最大化 / 还原和关闭到托盘；关闭仍遵守桌面规则：隐藏到托盘，不退出程序
- 横向切换评论
- 纵向切换歌词 / 封面
- 与底部进度条、控制条共存
- PC 宽屏布局右侧内容区额外提供 `信息 / 歌词 / 评论` 分段切换入口，用于显式切换现有 PageView 页面
- 全屏播放器的评论区使用比封面背景更深的中性毛玻璃嵌入面板，评论保持简洁行布局；从这里打开的楼中楼回复弹层延续同一视觉语言，其他页面的评论入口仍使用通用样式

改全屏播放器 UI 时，不要只看单个 Widget，还要看整套 PageView 与手势冲突。

## 10. 最常见误区

- 以为桌面端关闭就等于退出
- 以为 MPRIS 可以在所有桌面平台直接实例化
- 以为极简模式只是换皮
- 以为主壳层仍然是默认 `NavigationRail` / `NavigationBar`
- 以为紧凑侧栏仍然会显示文字或 tooltip
- 以为移动端横屏仍然使用底部文字导航
- 以为全局背景图片会覆盖全屏播放器和极简模式
- 只在一个平台验证就提交

## 11. 修改这部分时要一起看什么？

- `lib/shared/widgets/responsive_scaffold.dart`
- `lib/shared/widgets/desktop_window_resize_frame.dart`
- `lib/core/window/window_service.dart`
- `lib/core/window/tray_service.dart`
- `lib/core/services/mpris_service.dart`
- `lib/features/player/application/player_notifier.dart`
- `lib/features/minimal/presentation/minimal_screen.dart`
- `lib/features/player/presentation/full_player_screen.dart`
