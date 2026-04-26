# UI 层 (Widget / 主题 / i18n)

## Widget 编写模式

### 基类选择

| 场景 | 基类 | 说明 |
|---|---|---|
| 纯展示 + 读取 Provider | `ConsumerWidget` | 最常用 |
| 需要 State 生命周期（Timer/Controller/initState） | `ConsumerStatefulWidget` | 如 `LoginScreen`（轮询 Timer）、`SearchScreen`（TextEditingController） |
| 不需要 Provider | `StatelessWidget` | 纯 UI 展示组件 |

### 页面（Screen）模板

```dart
class XxxScreen extends ConsumerWidget {
  const XxxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(xxxNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.xxxTitle),
      ),
      body: state.when(
        data: (data) => _buildContent(context, ref, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, XxxData data) {
    // ...
  }
}
```

### 私有内部 Widget

复杂页面中将 UI 片段提取为私有 Widget，放在同一文件内：

```dart
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) { ... }
}
```

### 功能私有组件

Feature 专属的可复用组件放在 `presentation/widgets/` 子目录：

```
features/player/presentation/
├── player_bar.dart
├── full_player_screen.dart
└── widgets/
    └── play_queue_sheet.dart
```

## 响应式布局

### ResponsiveScaffold

`shared/widgets/responsive_scaffold.dart` 是全局布局骨架，自动适配桌面和移动端：

- **桌面端**（宽度 ≥ 840px）：自定义标题栏 + 音乐控制台式侧栏 + 内容面板
- **移动端**（宽度 < 840px）：浮动底部导航 dock
- **底部**：始终显示 `PlayerBar`（播放控制条）

### 平台判断

```dart
// 方式一：Context 扩展
if (context.isDesktop) {
  // 桌面端逻辑
}

// 方式二：PlatformUtils
if (PlatformUtils.isDesktop) {
  // 桌面端逻辑（无需 context）
}
```

### 响应式断点常量

```dart
// 定义在 AppTheme 中
static const double desktopBreakpoint = 840;
static const double compactBreakpoint = 600;
```

## 主题系统

### AppTheme 设计系统入口

主题定义在 `lib/core/theme/app_theme.dart`，不再只是简单的 `ColorScheme.fromSeed` 包装，而是统一的设计系统入口。当前主题层包含：

- `AppThemePalette`：背景、表面、强调色、边框、文本、状态色、overlay、glow
- `AppThemeSpacing`：统一间距刻度
- `AppThemeRadii`：统一圆角刻度
- `AppThemeDepth`：统一边框宽度、阴影和发光参数

这些 token 通过 `ThemeData.extensions` 暴露，后续页面和共享组件都应复用这套命名，而不是各自发明新的样式语义。

### Seed 色预设

```dart
static const Map<String, Color> seedPresets = {
  'green': AppTheme.greenSeed,
  'blue': AppTheme.blueSeed,
  'teal': AppTheme.tealSeed,
  'pink': AppTheme.pinkSeed,
  'purple': AppTheme.purpleSeed,
  'indigo': AppTheme.indigoSeed,
  'yellow': AppTheme.yellowSeed,
  'orange': AppTheme.orangeSeed,
  'red': AppTheme.redSeed,
  'cyan': AppTheme.cyanSeed,
};
```

### 在 Widget 中访问主题

```dart
// ✅ 基础 Flutter 主题访问
final theme = context.theme;
final colorScheme = context.colorScheme;
final textTheme = context.textTheme;

// ✅ BuSic 设计 token 访问
final palette = context.appPalette;
final spacing = context.appSpacing;
final radii = context.appRadii;
final depth = context.appDepth;
```

推荐规则：

- 优先用 `context.appPalette` 读取 BuSic 特有的视觉语义
- 仍可继续用 `context.colorScheme` / `context.textTheme` 对接 Material 组件
- 不推荐在业务页面里直接写魔法数字圆角、间距、阴影和自定义色值

### 主题覆盖范围

`AppTheme` 现在会统一配置这些组件的基础视觉语言：

- `AppBar`
- `Card`
- `Dialog` / `BottomSheet`
- `NavigationRail` / `NavigationBar`
- `TextField`
- `FilledButton` / `OutlinedButton` / `TextButton`
- `SegmentedButton` / `Chip`
- `ListTile`
- `SnackBar`

### 主题模式

支持三种 `ThemeMode`：system / light / dark，由 `SettingsNotifier` 管理。

## 国际化 (i18n)

### 配置

- ARB 文件位于 `lib/l10n/`（模板：`app_en.arb`）
- 输出类：`AppLocalizations`
- 当前支持：英文 + 中文

### 使用翻译字符串

```dart
// ✅ 使用 context 扩展（推荐）
Text(context.l10n.searchTitle)

// ✅ 也可以直接使用
AppLocalizations.of(context)!.searchTitle
```

### 添加新翻译

1. 在 `lib/l10n/app_en.arb`（英文模板）中添加键值
2. 在 `lib/l10n/app_zh.arb`（中文）中添加对应翻译
3. 运行 `flutter gen-l10n` 或构建时自动生成

```json
// app_en.arb
{
  "newFeatureTitle": "New Feature",
  "@newFeatureTitle": {
    "description": "Title for the new feature page"
  }
}

// app_zh.arb
{
  "newFeatureTitle": "新功能"
}
```

### 翻译规范

- **所有用户可见文本**必须使用 i18n，禁止硬编码
- 英文 ARB 是模板文件（包含 `@` 描述注释）
- 翻译键使用 camelCase
- 翻译键按功能演进持续补充，不维护固定数量描述

## 通用弹窗

使用 `CommonDialogs` 静态方法集：

```dart
// 确认弹窗
final confirmed = await CommonDialogs.showConfirmDialog(
  context,
  title: '确认删除',
  message: '此操作不可撤销',
);

// 输入弹窗
final input = await CommonDialogs.showInputDialog(
  context,
  title: '重命名',
  initialValue: currentName,
);

// 错误弹窗（含重试）
CommonDialogs.showErrorDialog(
  context,
  title: '错误',
  message: '操作失败',
  onRetry: () => retry(),
);
```

## SnackBar 提示

```dart
// 通过 context 扩展调用
context.showSnackBar('操作成功');
```

## 图片处理

### 封面图片

- 网络图片：使用 `cached_network_image` 库缓存
- 本地图片：使用 `File` + `Image.file()`
- 占位图：渐变色背景 + 音符图标

```dart
// 优先级：本地 → 网络 → 占位
if (localCoverPath != null) {
  Image.file(File(localCoverPath));
} else if (coverUrl != null) {
  CachedNetworkImage(imageUrl: coverUrl);
} else {
  GradientPlaceholder();
}
```

## 共享媒体组件

Task 03 起，媒体内容相关展示统一复用 `shared/widgets/` 下的共享媒体积木，不再在业务页面中直接用默认 `ListTile` / `Card` 拼装歌曲项和媒体卡片。

### 组件入口

- `AppPanel`：共享玻璃感面板底座，用于媒体卡片、分页条和其他需要统一 panel 语言的展示层。
- `MediaCover`：统一封面组件，负责本地路径、网络图、空封面和加载失败兜底。
- `MediaRow`：统一横向媒体行骨架，负责封面、标题、副标题、badge、操作区和状态样式。
- `SongTile`：基于 `MediaRow` 的歌曲展示组件。
- `PlaylistTile`：基于 `AppPanel + MediaCover` 的歌单卡片组件。

### 使用约束

- 歌曲列表、搜索结果、歌单卡片优先复用上述组件，而不是重新定义独立的列表项结构。
- 页面内如果需要排序 handle、复选框、箭头等附加控制，优先作为 `MediaRow` 的 accessory / trailing 内容接入。
- 封面兜底必须继续遵守“本地 → 网络 → 占位”的加载优先级。
- `AppPanel` 或任何同类 `ClipRRect + BackdropFilter + BoxDecoration(border)` 结构，内层 `BoxDecoration` 必须显式使用与裁剪一致的 `borderRadius`；否则选中态/高亮态边框会在圆角处出现裁切缺口。
- 壳层面板、内容框和媒体卡片优先复用 `AppPanel`，不要复制一份相似实现后再单独维护圆角与边框逻辑。

### 状态语义

- `hover`：轻微提升 overlay 和边框对比度。
- `playing / active`：使用更强的强调边框、封面 glow 或强调色文本。
- `selected`：使用强调底色和更明确的选中边框。
- `disabled`：降低整体对比度，并禁用点击 / 操作按钮。

## 页面级视觉结构

Task 05 起，主业务页不再依赖默认 `AppBar + 空背景列表 + FAB` 作为主要骨架：

- 歌单首页使用紧凑资料库标题行和单一加号入口；加号弹窗分流到自定义歌单、剪贴板导入和 B 站收藏夹导入，歌单卡片继续复用 `PlaylistTile`。
- 搜索页使用低高度 `AppPanel` command surface 承载关键词 / BV / URL 输入，空态、搜索结果态、解析详情态、错误态和加载态必须有明确层次。
- 解析详情页的封面、信息、分 P 选择和评论入口使用面板化视觉，不再以默认 `Card` / `CheckboxListTile` 作为主视觉。

Task 06 起，设置页使用 feature 私有的控制台式设置积木：

- `SettingsSectionPanel`：设置页分区面板，用于外观、语言、播放、存储、账号、数据管理、关于等区块。
- `SettingsTile`：设置项和设置操作行，负责统一图标、标题、副标题、正文控件、尾部操作和禁用 / 危险态。
- 设置页可在自身 `presentation/widgets/` 内维护这些专用积木；不要让其他 feature 反向依赖 settings presentation。

## 导航

```dart
// 使用 GoRouter
context.go('/search');                    // 替换当前路由
context.push('/playlists/$id');           // 压入路由栈

// 路径常量定义在 AppRoutes 中
context.go(AppRoutes.search);
```
