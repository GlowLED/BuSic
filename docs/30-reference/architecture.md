# BuSic 架构速查

这份文档只回答三个问题：

1. 仓库现在怎么分层
2. 启动和主链路怎么串起来
3. 改某类功能时应该先看哪里

更偏业务细节的内容请看 `10-project/`。

## 1. 整体结构

```text
lib/
├── main.dart
├── app.dart
├── core/
├── features/
├── shared/
└── l10n/
```

分层职责：

- `core/`
  - 全局基础设施
  - 包括 API、数据库、路由、主题、窗口、服务
- `features/`
  - 按业务能力拆分
  - 每个 feature 尽量保持 `domain / data / application / presentation`
- `shared/`
  - 跨 feature 复用的 UI 组件和扩展
- `l10n/`
  - ARB 与生成的本地化代码

## 2. 启动链路

`lib/main.dart` 当前负责：

1. Flutter 初始化与全局错误捕获
2. 初始化 `media_kit`
3. 初始化 Drift 数据库
4. 初始化 `BiliDio` Cookie 存储
5. 初始化 `audio_service`
6. 桌面端初始化窗口和托盘
7. 读取极简模式开关
8. 通过 `ProviderScope.overrides` 注入关键依赖

`lib/app.dart` 当前负责：

- 挂载 `MaterialApp.router`
- 根据 `settingsNotifierProvider` 读取主题和语言
- 首帧后静默检查应用更新

结论：

- 启动失败不一定是 UI 问题
- Provider 初始化问题常常源自 `main.dart` 或 `app.dart`

## 3. 路由结构

主路由定义在 `lib/core/router/app_router.dart`。

当前模式：

- Shell：`StatefulShellRoute.indexedStack`
- 主导航分支：
  - `/`
  - `/search`
  - `/downloads`
  - `/settings`
- 独立路由：
  - `/login`
  - `/player`
  - `/minimal`

注意：

- 不是每个 feature 都对应一个独立页面
- `comment`、`subtitle`、`share`、`app_update` 更像系统能力或子流程
- `minimal` 是独立路由，不是主壳层内的普通页面

## 4. Feature 地图

### 4.1 主链路 feature

| Feature | 作用 |
|---|---|
| `auth` | B 站登录、Cookie、会话持久化 |
| `playlist` | 本地歌单、歌曲关系、元数据编辑、收藏夹导入承接 |
| `search_and_parse` | 搜索、BV 解析、流地址获取、视频信息拉取 |
| `player` | 队列、播放控制、恢复、离线优先、媒体会话 |
| `download` | 下载队列、任务状态、文件落地、质量回写 |
| `settings` | 主题、语言、音质、路径、极简模式等设置 |

### 4.2 配套系统 feature

| Feature | 作用 |
|---|---|
| `subtitle` | 字幕 / 歌词获取、缓存、时间轴同步 |
| `comment` | 评论列表、楼中楼、发送评论 |
| `share` | 歌单分享、完整备份导入导出 |
| `app_update` | 读取 Manifest、检查更新、下载更新包 |
| `minimal` | 极简模式独立页面与生命周期策略 |

## 5. 层间依赖规则

推荐依赖方向：

```text
presentation
  -> application
  -> data
  -> core
```

实际约束：

- `presentation`
  - 通过 Provider 与 Notifier 交互
  - 不直接写数据库和网络请求
- `application`
  - 负责编排业务和状态变更
  - 可以依赖 Repository
- `data`
  - 负责具体读写
  - 可以访问 Drift、Dio、文件系统、平台服务
- `domain`
  - 纯模型与少量派生属性
  - 不承载复杂 IO 逻辑

## 6. 当前最重要的跨系统耦合

### 6.1 播放器 <- 下载

下载完成后会反向更新：

- `songs.localPath`
- `songs.audioQuality`

播放器恢复和切歌时会重新查询这些字段，因此下载和播放不是两条独立链路。

### 6.2 分享 / 备份 <- 歌曲身份

跨设备识别依赖：

- `bvid + cid`

不是：

- `Songs.id`
- 本地文件路径

### 6.3 更新系统 <- Release 资产命名

应用内更新逻辑同时依赖：

- `versions-manifest.json`
- `app_update` feature 的匹配逻辑
- CI / Release 资产名

改其中一个而不改另外两个，更新功能就会失效。

### 6.4 字幕 <- B 站接口 <- 登录态

字幕获取链路依赖：

- aid 解析
- `/x/player/v2`
- Cookie / 登录态
- AI 字幕 URL 前缀校验

它不是简单的一次接口调用。

## 7. 改动入口速查

| 目标 | 先看哪里 |
|---|---|
| 启动异常 | `lib/main.dart`, `lib/app.dart` |
| 路由或页面壳层 | `lib/core/router/app_router.dart`, `lib/shared/widgets/responsive_scaffold.dart` |
| 数据表或迁移 | `lib/core/database/app_database.dart`, `lib/core/database/tables/` |
| B 站请求 | `lib/core/api/bili_dio.dart` |
| 播放器 | `lib/features/player/application/player_notifier.dart` |
| 下载与离线播放 | `lib/features/download/data/download_repository_impl.dart` |
| 分享与备份 | `lib/features/share/data/share_repository_impl.dart`, `lib/features/share/data/sync_repository_impl.dart` |
| 字幕与歌词 | `lib/features/subtitle/data/subtitle_repository_impl.dart` |
| 更新系统 | `lib/features/app_update/data/update_repository_impl.dart`, `versions-manifest.json` |
| 桌面窗口 / 托盘 / 极简模式 | `lib/core/window/`, `lib/features/minimal/presentation/minimal_screen.dart` |

## 8. 最容易误判的事

- 数据库是 Drift，不是 Isar
- Android 后台播放已经接入 `audio_service`
- `BiliDio` 使用 raw cookie 注入，不是普通 CookieJar 语义
- `share` / `subtitle` / `comment` 不是主壳层路由页面
- 极简模式不是普通页面主题变体

## 9. 继续阅读

- 项目总览： [../10-project/project-overview.md](../10-project/project-overview.md)
- 项目特化规则： [../10-project/project-specific-rules.md](../10-project/project-specific-rules.md)
- Source of truth： [source-of-truth.md](./source-of-truth.md)
