# 编码规范

## 命名约定

| 类型 | 约定 | 示例 |
|---|---|---|
| Notifier 类 | `XxxNotifier` | `AuthNotifier`, `PlayerNotifier` |
| Repository 接口 | `XxxRepository` | `AuthRepository`, `ParseRepository` |
| Repository 实现 | `XxxRepositoryImpl` | `AuthRepositoryImpl`, `ParseRepositoryImpl` |
| Domain 模型 | PascalCase 名词 | `User`, `AudioTrack`, `SongItem` |
| Screen (页面) | `XxxScreen` | `LoginScreen`, `SearchScreen` |
| 可复用 Widget | 描述性名词 | `SongTile`, `PlaylistTile`, `PlayerBar` |
| 私有内部 Widget | `_XxxWidget` | `_DesktopTitleBar`, `_VolumeButton` |
| 工具类 | `XxxUtils` 或 `Xxx`（私有构造） | `PlatformUtils`, `Formatters`, `AppLogger` |
| Provider (codegen) | 自动生成 `xxxProvider` | `authNotifierProvider`, `settingsNotifierProvider` |
| 枚举 | PascalCase 类名 + camelCase 值 | `PlayMode.repeatAll`, `DownloadStatus.downloading` |
| 常量 | camelCase | `desktopBreakpoint`, `compactBreakpoint` |
| 私有成员 | `_camelCase` | `_isPlaying`, `_resolveAudioTrack()` |

## 文件命名

- 使用 **snake_case**：`audio_track.dart`, `player_notifier.dart`
- 与类名一一对应：`AudioTrack` → `audio_track.dart`
- 每个文件一个主要公开类（私有辅助类可在同文件内）

## 导入顺序

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. 第三方包
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 4. 项目内（相对路径）
import '../../core/api/bili_dio.dart';
import '../domain/models/user.dart';

// 5. Part 指令（codegen）
part 'auth_notifier.g.dart';
part 'auth_notifier.freezed.dart';
```

- 项目内文件**只用相对路径**，不用 `package:busic/`
- 各组之间空一行

## 代码风格

### 字符串

```dart
// ✅ 使用单引号
final name = 'BuSic';

// ❌ 不使用双引号
final name = "BuSic";
```

### const 优先

```dart
// ✅ 能用 const 的地方必须用
const SizedBox(height: 8);
const EdgeInsets.all(16);

// Widget 构造函数声明 const
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
}
```

### 日志

```dart
// ✅ 使用 AppLogger
AppLogger.info('播放开始', tag: 'Player');
AppLogger.error('下载失败', tag: 'Download', error: e);

// ❌ 禁止 print
print('debug info');  // lint 规则 avoid_print 会报错
```

### Widget 子属性

```dart
// ✅ child/children 放最后
Container(
  padding: const EdgeInsets.all(16),
  color: Colors.blue,
  child: const Text('Hello'),  // 最后
);

// ❌ child 不在最后
Container(
  child: const Text('Hello'),
  padding: const EdgeInsets.all(16),  // lint 规则报错
);
```

## 错误处理模式

### 网络请求

```dart
Future<void> fetchData() async {
  try {
    final result = await repository.getData();
    state = SuccessState(result);
  } catch (e) {
    AppLogger.error('获取数据失败', tag: 'Feature', error: e);
    state = ErrorState('获取失败: $e');
  }
}
```

### UI 层错误展示

```dart
// AsyncValue 三态渲染
ref.watch(asyncProvider).when(
  data: (data) => DataWidget(data),
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => ErrorWidget(e.toString()),
);

// 用户提示
context.showSnackBar('操作成功');

// 错误弹窗（含重试）
CommonDialogs.showErrorDialog(
  context,
  title: '错误',
  message: '操作失败',
  onRetry: () => retry(),
);
```

### 异常传播规则

1. **Data 层**：捕获具体异常（DioException 等），记录日志，根据情况重新抛出或转为业务异常
2. **Application 层**：`try-catch` 包裹 Repository 调用，catch 后更新 Notifier 的状态为错误态
3. **Presentation 层**：通过 `AsyncValue.when()` 或状态联合类型（如 `ParseState.error`）展示错误 UI

## 注释规范

```dart
/// 解析 BV 号并获取视频信息
///
/// [input] 可以是完整 URL 或纯 BV 号
/// 返回解析后的视频信息，多 P 视频会包含 pages 列表
Future<BvidInfo> parseVideo(String input) async { ... }

// 内联注释用中文，解释"为什么"而非"做什么"
// B站的 SESSDATA 包含逗号，Dart 的 Cookie 类无法解析，
// 所以用 Map 手动拼接
```

## 平台判断

```dart
// ✅ 使用 PlatformUtils
if (PlatformUtils.isDesktop) { ... }

// ✅ 或使用 context 扩展
if (context.isDesktop) { ... }

// 响应式断点
if (MediaQuery.of(context).size.width >= AppTheme.desktopBreakpoint) { ... }
```
