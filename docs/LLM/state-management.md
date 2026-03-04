# 状态管理 (Riverpod)

本项目使用 **Riverpod codegen**（`riverpod_annotation`）进行状态管理。所有业务 Notifier 均使用注解式代码生成。

## Provider 分类

### 注解式 Notifier（主要模式）

所有业务逻辑 Notifier **必须**使用 `@riverpod` 注解 + codegen：

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'xxx_notifier.g.dart';

// 异步 Notifier（返回 Future）
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // 初始化逻辑
    return await _loadSession();
  }
}

// 同步 Notifier
@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  @override
  PlayerState build() {
    // 初始化逻辑
    return PlayerState.initial();
  }
}

// Family Provider（参数化）
@riverpod
class PlaylistDetailNotifier extends _$PlaylistDetailNotifier {
  @override
  Future<List<SongItem>> build(int playlistId) async {
    return await _repository.getSongs(playlistId);
  }
}
```

### 手动 Provider（仅用于特殊场景）

以下场景使用手动 `Provider`，不使用 codegen：

```dart
// 1. 全局单例（通过 ProviderScope.overrides 注入）
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('应通过 override 注入');
});

// 2. 需要 keep-alive 的仓库（防止 notifier 重建时丢失状态）
final downloadRepositoryProvider = Provider<DownloadRepositoryImpl>((ref) {
  final db = ref.watch(databaseProvider);
  return DownloadRepositoryImpl(db);
});

// 3. GoRouter 实例
final appRouterProvider = Provider<GoRouter>((ref) { ... });
```

## Notifier 编写规范

### 结构模板

```dart
@riverpod
class XxxNotifier extends _$XxxNotifier {
  // 1. 私有字段（Repository、缓存等）
  late final XxxRepository _repository;

  @override
  Future<XxxState> build() async {
    // 2. 初始化 Repository（通常在 build 中创建）
    final db = ref.watch(databaseProvider);
    _repository = XxxRepositoryImpl(db);

    // 3. 返回初始状态
    return await _repository.loadInitialData();
  }

  // 4. 公共方法（UI 调用）
  Future<void> doSomething() async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.doSomething();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // 5. 私有辅助方法
  Future<void> _internalHelper() async { ... }
}
```

### 异步 vs 同步 Notifier 选择

| 场景 | 类型 | 示例 |
|---|---|---|
| 启动时需异步加载数据 | `Future<T>` | `AuthNotifier`, `PlaylistListNotifier` |
| 纯运行时状态，不需异步初始化 | `T` | `PlayerNotifier`, `ParseNotifier` |
| 用户偏好设定（同步默认值 + 异步覆盖） | `T`（build 中同步返回默认值，然后异步更新） | `SettingsNotifier` |

### 状态更新方式

```dart
// 异步 Notifier：使用 AsyncValue
state = const AsyncValue.loading();
state = AsyncValue.data(newData);
state = AsyncValue.error(e, st);

// 同步 Notifier：使用 copyWith
state = state.copyWith(isPlaying: true);

// 联合类型状态：直接替换为对应变体
state = ParseState.parsing();
state = ParseState.success(result);
state = ParseState.error('失败原因');
```

## 在 UI 中使用 Provider

### Widget 基类选择

```dart
// 需要读取 provider 的 StatelessWidget
class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(xxxNotifierProvider);
    // ...
  }
}

// 需要 State 生命周期（initState、dispose 等）
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}
```

### watch vs read 规则

```dart
// ✅ build() 中用 watch（响应式重建）
final state = ref.watch(playerNotifierProvider);

// ✅ 回调/事件中用 read（不触发重建）
onPressed: () => ref.read(playerNotifierProvider.notifier).play(),

// ❌ build() 中不要用 read
// ❌ 回调中不要用 watch
```

### 跨 Feature 依赖

Feature 之间可通过 Provider 互相引用：

```dart
// 在 DownloadNotifier 中使用 ParseRepository 解析流地址
@riverpod
class DownloadNotifier extends _$DownloadNotifier {
  @override
  Future<List<DownloadTask>> build() async {
    // 引用另一个 feature 的 repository
    final parseRepo = ParseRepositoryImpl();
    final audioStream = await parseRepo.getAudioStream(bvid, cid);
    // ...
  }
}
```

## 依赖注入

- **数据库**：通过 `ProviderScope.overrides` 在 `main.dart` 中注入
- **Repository**：在 Notifier 的 `build()` 方法中创建实例
- **需要 keep-alive 的 Repository**：用手动 `Provider`（如 `downloadRepositoryProvider`）

```dart
// main.dart
void main() async {
  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const App(),
    ),
  );
}
```
