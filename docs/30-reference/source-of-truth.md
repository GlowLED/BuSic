# Source Of Truth

当文档、代码、历史设计之间出现冲突时，优先信这里列出的“真源”。

## 1. 应用运行与版本

- `pubspec.yaml`
  - 应用版本
  - 核心依赖
  - `x_update` fallback 元数据

- `CHANGELOG.md`
  - 面向人的版本变更记录

## 2. 启动与路由

- `lib/main.dart`
  - 启动初始化、数据库注入、音频服务、窗口 / 托盘、极简模式入口

- `lib/app.dart`
  - `MaterialApp.router`、主题、多语言、静默更新检查

- `lib/core/router/app_router.dart`
  - 全部路由结构
  - 主导航壳层

## 3. 数据库与本地持久化

- `lib/core/database/app_database.dart`
  - 表注册
  - `schemaVersion`
  - 迁移策略

- `lib/core/database/tables/*.dart`
  - 各表字段定义

## 4. B站接入

- `lib/core/api/bili_dio.dart`
  - HTTP 基础行为
  - Cookie 注入
  - `Referer`

- `lib/core/api/wbi_sign.dart`
  - WBI 签名

## 5. 更新系统

- `versions-manifest.json`
  - 应用内更新主真源

- `.github/workflows/ci.yml`
  - CI 真正跑什么

- `.github/workflows/release.yml`
  - Release 真正构建什么、如何发布

- `lib/features/app_update/*`
  - 应用运行时如何解释 manifest、下载、校验和安装

## 6. 播放与缓存

- `lib/features/player/application/player_notifier.dart`
  - 队列、恢复、本地缓存回填、媒体会话桥接

- `lib/features/download/data/download_repository_impl.dart`
  - 下载任务和 `songs` 表联动

## 7. 分享 / 备份

- `lib/features/share/data/share_repository_impl.dart`
  - 剪贴板分享格式

- `lib/features/share/data/sync_repository_impl.dart`
  - 完整备份的导出 / 导入规则

## 8. 字幕 / 歌词

- `lib/features/subtitle/data/subtitle_repository_impl.dart`
  - 字幕获取、前缀校验、重试、缓存

## 9. 平台行为

- `lib/shared/widgets/responsive_scaffold.dart`
  - 桌面 / 移动端主壳层差异

- `lib/core/window/window_service.dart`
  - 桌面窗口行为

- `lib/core/window/tray_service.dart`
  - 托盘行为

- `lib/features/minimal/presentation/minimal_screen.dart`
  - 极简模式生命周期策略
