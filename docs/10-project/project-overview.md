# Project Overview

这份文档只描述 **BuSic 当前真实实现**，不讲历史意图。

## 1. 产品与技术栈

- 产品定位：基于 Bilibili 解析链路的跨平台音乐播放器
- 重点能力：播放、歌单、下载、评论、歌词/字幕、分享/备份、应用更新、极简模式
- 当前技术栈：
  - Flutter
  - Riverpod codegen
  - GoRouter
  - Drift + SQLite
  - Dio
  - `media_kit`
  - `audio_service`
  - `shared_preferences`

## 2. 仓库主结构

```text
lib/
├── main.dart
├── app.dart
├── core/
├── features/
├── shared/
└── l10n/
```

- `core/`：API、数据库、路由、主题、工具、窗口 / 托盘服务
- `features/`：按业务能力拆分，每个 feature 基本采用 `domain / data / application / presentation`
- `shared/`：跨 feature 复用组件
- `l10n/`：ARB 与生成的本地化类

## 3. 运行时主链路

### 启动

`lib/main.dart` 当前会做这些事：

1. 初始化 Flutter 和全局错误捕获
2. 初始化 `media_kit`
3. 初始化 Drift 数据库
4. 初始化 `BiliDio` Cookie 持久化
5. 初始化 `audio_service`
6. 桌面端初始化窗口服务和托盘服务
7. 读取极简模式标志
8. 通过 `ProviderScope.overrides` 注入数据库、音频服务和极简模式初始值

### 应用层

`lib/app.dart` 负责：

- 挂载 `MaterialApp.router`
- 读取 `settingsNotifierProvider` 决定主题 / 语言
- 首帧后静默执行应用更新检查

### 路由

主路由由 `lib/core/router/app_router.dart` 定义：

- Shell：`StatefulShellRoute.indexedStack`
- 主分支：
  - `/` -> 歌单列表
  - `/search`
  - `/downloads`
  - `/settings`
- 独立路由：
  - `/login`
  - `/player`
  - `/minimal`

## 4. 关键 feature

### `player`

系统核心。负责：

- 当前播放状态
- 队列管理
- 锁屏 / 通知栏媒体控制
- 恢复上次播放状态
- 离线优先播放

最重要的实现点：

- `PlayerNotifier` 是 `keepAlive`
- 播放器恢复时会重新解析 URL 或补查本地缓存路径
- 下载完成会触发队列的 `localPath` 刷新

### `playlist`

负责：

- 歌单 CRUD
- 歌曲与歌单关系维护
- 自定义标题 / 作者 / 封面
- “我喜欢”歌单
- 收藏夹导入后的本地承接

### `search_and_parse`

负责：

- 搜索视频
- BV 解析
- 获取音频流 URL
- 收藏夹相关远端模型和解析链路

### `download`

负责：

- 下载任务创建、状态监听、重试、删除
- 任务进度与数据库同步
- 下载成功后回写 `songs.localPath` 和 `songs.audioQuality`

### `share`

负责：

- 剪贴板歌单分享
- 完整备份导入导出
- 导入时复用本地已存在歌曲
- 故意不导出本地路径和下载任务

### `subtitle`

负责：

- 字幕 / 歌词获取
- DB 缓存
- AI 字幕错配规避
- 与播放器时间轴联动显示

### `app_update`

负责：

- 检查更新
- 读取 `versions-manifest.json`
- 下载、校验和、安装
- 蓝奏云 / GitHub 多渠道

### `comment`

负责：

- 评论列表
- 楼中楼
- 发表评论 / 回复 / 点赞

### `minimal`

负责：

- 极简模式独立页面
- 读取极简模式指定歌单
- 特殊生命周期策略

## 5. 当前数据库

`lib/core/database/app_database.dart` 中注册的表：

- `Songs`
- `Playlists`
- `PlaylistSongs`
- `DownloadTasks`
- `UserSessions`
- `Subtitles`

当前迁移版本：

- `schemaVersion = 4`
- v2：下载音质字段
- v3：“我喜欢”歌单标记
- v4：字幕表

## 6. 需要特别警惕的误区

- 不要把旧文档里的 Isar 说法当真
- 不要把 B 站字幕获取当成稳定单请求
- 不要忽略下载完成对 `songs` 表的反向回写
- 不要忽略桌面托盘和“关闭隐藏到托盘”的行为
- 不要把 `versions-manifest.json` 和 GitHub Release 资产命名拆开维护

## 7. 继续深入

- 项目特化规则： [project-specific-rules.md](./project-specific-rules.md)
- B站集成： [bilibili-integration.md](./bilibili-integration.md)
- 字幕与歌词： [subtitle-and-lyrics.md](./subtitle-and-lyrics.md)
- 更新系统： [update-system.md](./update-system.md)
- 平台与 UI 差异： [ui-and-platform-quirks.md](./ui-and-platform-quirks.md)
