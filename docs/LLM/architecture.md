# 架构与项目结构

## 整体架构

项目采用 **Feature-first（按功能划分）** 结合 **Lite DDD（轻量级领域驱动设计）** 架构。`lib/` 目录分为三大区域：

```
lib/
├── main.dart              # 入口：初始化数据库、media_kit、窗口服务
├── app.dart               # MaterialApp.router 配置：路由、主题、i18n
├── core/                  # 全局基础设施（与业务无关）
├── features/              # 业务功能模块（核心代码）
├── shared/                # 跨模块共享组件
└── l10n/                  # 国际化资源
```

## Core 层（核心基建）

`core/` 提供全局通用的基础能力，**不依赖任何 feature 模块**：

| 目录 | 职责 | 关键类 |
|---|---|---|
| `api/` | Bilibili API 底层封装 | `BiliDio`（单例）, `WbiSign`（静态工具类） |
| `database/` | Drift 数据库初始化 + 表定义 | `AppDatabase`, `Songs/Playlists/...` 表 |
| `router/` | GoRouter 全局路由表 | `appRouterProvider`, `AppRoutes` |
| `theme/` | Material 3 主题 + 响应式断点 | `AppTheme`（私有构造工具类） |
| `utils/` | 工具集 | `AppLogger`, `Formatters`, `PlatformUtils` |
| `window/` | 桌面窗口管理 | `WindowService`（静态方法） |

## Feature 层（业务模块）

每个 feature 内部严格遵循**四层分层架构**：

```
features/
└── <feature_name>/
    ├── domain/            # 纯数据模型（Freezed 类），无业务逻辑
    │   └── models/
    ├── data/              # Repository 接口 + 实现（API/DB 操作）
    ├── application/       # Riverpod Notifier（业务逻辑编排）
    └── presentation/      # UI 视图（Screen + Widget）
        └── widgets/       # 功能私有组件
```

### 现有 Feature 模块

| 模块 | 功能 | 核心 Notifier |
|---|---|---|
| `auth/` | 扫码登录、Cookie 管理、会话持久化 | `AuthNotifier` |
| `player/` | 播放控制、队列管理、进度恢复 | `PlayerNotifier`（最复杂） |
| `playlist/` | 歌单 CRUD、歌曲排序、元数据编辑 | `PlaylistListNotifier` + `PlaylistDetailNotifier`(family) |
| `search_and_parse/` | BV 号解析、关键词搜索、多 P 选择 | `ParseNotifier` |
| `download/` | 下载任务队列、进度监听、音质选择 | `DownloadNotifier` |
| `settings/` | 用户偏好（主题/语言/音质/缓存路径） | `SettingsNotifier` |

## 层间依赖规则

```
Presentation (ConsumerWidget / ConsumerStatefulWidget)
    ↓ ref.watch / ref.read (xxxProvider)
Application (Riverpod Notifier)
    ↓ 调用 Repository 接口方法
Data (RepositoryImpl)
    ↓ 调用 BiliDio / AppDatabase / media_kit
Core (API / Database / Utils)
```

### 严格遵守的规则

1. **Presentation 层**只通过 Riverpod provider 与 Application 层交互，**禁止直接调用 Repository**
2. **Application 层** 持有 Repository 实例（通常在 `build()` 中创建），负责编排业务逻辑
3. **Data 层** 实现 Repository 抽象接口，封装具体的 API 调用和数据库操作
4. **Domain 层** 是纯数据模型，**不包含业务逻辑**（仅允许计算属性如 `SongItem.displayTitle`）
5. **Feature 之间**可以通过 Riverpod provider 互相引用，但**不直接导入对方的 Data/Domain 层**
6. **Shared 层**可以被任何 Feature 的 Presentation 层使用
7. **Core 层**可以被任何层使用

## 新增 Feature 模板

创建新功能模块时，遵循以下目录结构：

```
lib/features/<new_feature>/
├── domain/
│   └── models/
│       └── <model_name>.dart          # @freezed 数据模型
├── data/
│   ├── <feature>_repository.dart      # 抽象接口
│   └── <feature>_repository_impl.dart # 具体实现
├── application/
│   └── <feature>_notifier.dart        # @riverpod class XxxNotifier
└── presentation/
    ├── <feature>_screen.dart          # 主页面
    └── widgets/
        └── <widget_name>.dart         # 功能私有组件
```

## Shared 层（共享组件）

`shared/` 存放**跨 Feature 复用**的 UI 组件和 Dart 扩展：

| 文件 | 类型 | 用途 |
|---|---|---|
| `widgets/responsive_scaffold.dart` | Widget | 响应式布局骨架（桌面 NavigationRail / 移动 NavigationBar） |
| `widgets/song_tile.dart` | Widget | 通用歌曲列表项 |
| `widgets/common_dialogs.dart` | 静态方法 | 确认/输入/错误通用弹窗 |
| `extensions/context_extensions.dart` | Extension | `BuildContext` 便捷访问器（theme/l10n/snackBar 等） |

## 路由结构

使用 `StatefulShellRoute.indexedStack` 实现带底部/侧边导航的页面持久化：

```
StatefulShellRoute (ResponsiveScaffold)
├── Branch 0: / → PlaylistListScreen → /playlists/:id (DetailScreen)
├── Branch 1: /search → SearchScreen
├── Branch 2: /downloads → DownloadScreen
└── Branch 3: /settings → SettingsScreen

独立路由（不在 Shell 内）：
├── /login → LoginScreen
└── /player → FullPlayerScreen
```

新增页面时，需在 `lib/core/router/app_router.dart` 中添加路由配置，并在 `AppRoutes` 中定义路径常量。
