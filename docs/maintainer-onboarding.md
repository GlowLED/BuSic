# BuSic 维护者上手

本文档面向第一次接手 BuSic 仓库的维护者，目标是帮你在最短时间内完成三件事：

1. 把项目跑起来
2. 看懂当前代码和文档的主入口
3. 知道日常开发、验证和发布分别看哪里

如果你只想参与普通功能开发，也建议先读完本文，再继续深入 [构建指南](build-guide.md)、[开发工作流](dev-workflow.md) 和 [贡献指南](../CONTRIBUTING.md)。

## 1. 先建立项目全貌

截至当前仓库状态：

- 应用版本：`0.3.8+14`，定义于 `pubspec.yaml`
- 更新清单最新版本：`0.3.8`，发布日期 `2026-04-16`，定义于 `versions-manifest.json`
- 主发布平台：Android、Windows、Linux、macOS
- 仓库定位：基于 Bilibili 解析链路的跨平台音乐播放器，重点是播放、歌单、下载、分享同步和应用更新

当前主要技术栈：

- Flutter 3.29.x
- Riverpod + `riverpod_generator`
- GoRouter
- Drift + SQLite
- Dio
- `media_kit`
- `audio_service`
- `shared_preferences`

维护时优先相信以下“真实来源”：

- 运行和依赖：`pubspec.yaml`
- 应用入口：`lib/main.dart`、`lib/app.dart`
- 路由结构：`lib/core/router/app_router.dart`
- 数据库结构：`lib/core/database/app_database.dart`
- 更新元数据：`versions-manifest.json`
- CI / Release：`.github/workflows/ci.yml`、`.github/workflows/release.yml`

## 2. 第一天最短路径

第一次接手仓库时，按下面顺序走一遍：

```bash
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter run -d windows
```

如果你在 Android 设备上验证：

```bash
flutter devices
flutter run -d <device_id>
```

如果出现以下情况，再补跑代码生成或国际化生成：

- `*.g.dart` / `*.freezed.dart` 缺失或过期
- 你修改了 `@riverpod`、`@freezed`、Drift 表定义
- 你修改了 `lib/l10n/*.arb`

对应命令：

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

环境准备的细节不要在这里反复查，直接看：

- [构建指南](build-guide.md)：Flutter、Android、Windows 构建环境
- [调试指南](debug-guide.md)：VS Code、Hot Reload、断点和 watch 模式

## 3. 当前真实架构

仓库主结构是：

```text
lib/
├── main.dart
├── app.dart
├── core/
├── features/
├── shared/
└── l10n/
```

其中：

- `core/`：全局基础设施，包含 API、数据库、路由、主题、工具、桌面窗口服务
- `features/`：按业务模块拆分，每个 feature 基本遵循 `domain / data / application / presentation`
- `shared/`：跨 feature 复用的 UI 组件和扩展
- `l10n/`：国际化文案和生成产物

当前需要优先理解的入口文件：

- `lib/main.dart`：启动时初始化 Drift、本地 Cookie、`audio_service`、窗口/托盘服务
- `lib/app.dart`：挂载 `MaterialApp.router`、主题、多语言，并在首帧后静默检查更新
- `lib/core/router/app_router.dart`：`StatefulShellRoute.indexedStack` 主导航壳层
- `lib/shared/widgets/responsive_scaffold.dart`：桌面 `NavigationRail` 与移动端 `NavigationBar` 的切换入口
- `lib/core/database/app_database.dart`：Drift 数据库、表注册和迁移版本

主要 feature 可以按下面理解：

- `player`：播放控制、队列、恢复、媒体会话桥接，耦合度最高
- `playlist`：歌单 CRUD、本地元数据管理、收藏夹导入
- `search_and_parse`：BV 解析、搜索、流地址获取
- `download`：下载队列、音质选择、缓存文件和数据库联动
- `auth`：扫码登录、Cookie 登录、会话持久化
- `share`：剪贴板歌单分享、完整备份导入导出
- `app_update`：更新检查、下载、校验和安装流程
- `comment`、`subtitle`、`minimal`、`settings`：评论、歌词/字幕、极简模式和全局设置

两个容易误判的事实需要记住：

- 当前数据库方案已经是 Drift，不是 Isar
- Android 后台播放能力已经通过 `audio_service` 接入，不是“待集成”

更细的架构说明请看 [LLM/architecture.md](LLM/architecture.md)。如果和旧文档冲突，以代码和这份架构文档为准。

## 4. 日常开发怎么走

日常改动默认遵循这条链路：

```text
Presentation -> Application -> Data -> Core
```

维护时重点遵守：

- UI 通过 Riverpod provider 和状态层交互，不直接碰 Repository
- Repository 负责 API / DB / 文件等数据访问，不承担页面编排逻辑
- 生成文件不要手改：`*.g.dart`、`*.freezed.dart`、`lib/l10n/generated/*`
- 所有用户可见字符串都进 `lib/l10n/app_en.arb` 和 `lib/l10n/app_zh.arb`

提交前的最低验证基线：

```bash
flutter analyze --no-fatal-infos
flutter test
```

如果你改了下列内容，务必先生成再验证：

- Riverpod Notifier
- Freezed / JSON 模型
- Drift 表或迁移
- ARB 文案

开发流程细则请看：

- [开发工作流](dev-workflow.md)：从需求分析到验证、发布的完整路径
- [贡献指南](../CONTRIBUTING.md)：本地提交前必须通过的检查

## 5. 发布和版本维护看什么

版本和发布相关的“真源”分别是：

- `pubspec.yaml`：应用版本号，格式为 `x.y.z+build`
- `versions-manifest.json`：应用内更新系统读取的版本清单和下载地址
- `CHANGELOG.md`：面向人的变更记录

仓库当前自动化链路：

- `CI`：对 `main` 分支 push、`main` 的 PR、以及 `v*` tag 运行
- CI 内容固定为：`flutter pub get` -> `build_runner` -> `flutter analyze --no-fatal-infos` -> `flutter test`
- `Release`：对 `v*` tag 或手动 `workflow_dispatch` 运行
- Release 会等待同一提交的 CI 成功，然后构建 Linux、Windows、macOS、Android 和 iOS（unsigned）产物，并发布到 GitHub Releases

本地维护发布时，优先参考：

- [开发工作流](dev-workflow.md) 中的“版本号与发布”章节
- `scripts/release.py` 对应的发布 CLI

几个维护要点：

- Android Release 依赖 CI 中的 keystore secrets
- iOS 工作流当前产出的是 unsigned IPA
- 应用内更新能力依赖 `versions-manifest.json` 和 GitHub Release 资产命名保持一致

## 6. 常见坑

- `docs/pro-struc.md` 含有历史结构描述，不应再作为当前架构的唯一依据
- 只要改了 Riverpod / Freezed / Drift，先想到 `build_runner`
- Windows 本地开发如果插件或桌面构建异常，先确认系统已开启开发者模式
- 播放、下载、极简模式和桌面窗口行为都带平台差异，改动后至少在一个桌面平台和一个移动平台验证
- 如果更新系统行为异常，优先同时检查 `versions-manifest.json`、`CHANGELOG.md`、Release 资产名和 `.github/workflows/release.yml`

## 7. 文档索引

建议按这个顺序继续深入：

1. [构建指南](build-guide.md)
2. [调试指南](debug-guide.md)
3. [开发工作流](dev-workflow.md)
4. [贡献指南](../CONTRIBUTING.md)
5. [LLM/architecture.md](LLM/architecture.md)
6. [LLM/coding-conventions.md](LLM/coding-conventions.md)
7. [feat/](feat/) 下的专题设计文档

如果你发现本文档和代码现状不一致，优先修正文档入口，再决定是否回补旧文档内容。BuSic 目前更需要“入口一致性”，而不是继续堆积平行说明。
