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

- **桌面端**（宽度 ≥ 840px）：左侧 `NavigationRail` + 自定义拖拽标题栏 + 窗口控制按钮
- **移动端**（宽度 < 840px）：底部 `NavigationBar`，无窗口管理
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

### Material 3 + Seed Color

主题定义在 `lib/core/theme/app_theme.dart`，使用 `ColorScheme.fromSeed`：

```dart
// 4 种预设种子色
static const Map<String, Color> seedColors = {
  'green': Colors.green,
  'pink': Colors.pink,
  'purple': Colors.purple,
  'yellow': Colors.yellow,
};
```

### 在 Widget 中访问主题

```dart
// ✅ 使用 context 扩展（推荐）
final theme = context.theme;
final colors = context.colorScheme;
final textTheme = context.textTheme;

// ❌ 不推荐直接调用
Theme.of(context).colorScheme;
```

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
- 当前约有 73 个翻译键

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

## 导航

```dart
// 使用 GoRouter
context.go('/search');                    // 替换当前路由
context.push('/playlists/$id');           // 压入路由栈

// 路径常量定义在 AppRoutes 中
context.go(AppRoutes.search);
```
