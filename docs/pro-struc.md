# 项目目录结构与模块说明 (Project Structure)

> ⚠️ 本文档保留了部分历史结构描述，不再作为当前架构的首要入口。
> 当前仓库请优先阅读 [维护者上手](maintainer-onboarding.md) 和 [LLM/architecture.md](LLM/architecture.md)。
> 尤其需要注意：数据库方案已经是 **Drift**，播放器后台能力也已经接入 `audio_service`。

本项目基于 Flutter 框架，遵循 **Feature-first (按功能划分)** 与 **Lite DDD (轻量级领域驱动设计)** 原则，结合 Riverpod 进行状态管理。同时内置了完整的 i18n 多语言支持与跨端（Desktop + Mobile）兼容处理。

## 根目录概览

Plaintext

```
bili_music_player/
├── android/               # Android 原生工程目录
├── ios/                   # iOS 原生工程目录 (备用)
├── linux/                 # Linux 原生工程目录
├── macos/                 # macOS 原生工程目录
├── windows/               # Windows 原生工程目录
├── assets/                # 静态资源 (图片、字体、本地占位符等)
├── lib/                   # 核心 Dart 代码 (重点关注)
├── pubspec.yaml           # 项目依赖配置文件
└── l10n.yaml              # 多语言配置文件
```

## `lib/` 核心代码结构详解

`lib/` 目录是所有业务逻辑和 UI 的所在地，主要分为 `core` (核心基建)、`features` (业务模块)、`shared` (共享组件) 和 `l10n` (多语言)。

Plaintext

```
lib/
├── main.dart              # App 入口：初始化 Drift 数据库、media_kit、audio_service、跨端 Window 逻辑
├── app.dart               # MaterialApp 配置：注入 go_router、主题、多语言代理
│
├── l10n/                  # 🌐 国际化与多语言支持
│   ├── app_en.arb         # 英文文案字典
│   └── app_zh.arb         # 中文文案字典
│
├── core/                  # ⚙️ 核心基础基建 (与具体业务无关，全局通用)
│   ├── api/               # B站 API 底层封装 (Dio 实例、拦截器、Wbi 签名算法)
│   ├── database/          # Drift 数据库初始化配置及全局表注册
│   ├── router/            # go_router 全局路由表配置 (支持深层链接)
│   ├── theme/             # 全局主题配置 (明暗色调、Typography、跨端响应式断点)
│   ├── utils/             # 工具类 (日志 Logger、时间格式化、Hash 计算等)
│   └── window/            # 跨端窗口管理器 (处理桌面端无边框拖拽、Android 状态栏沉浸)
│
├── shared/                # 🧩 全局共享 UI 组件 (跨 Feature 复用)
│   ├── widgets/           # 自定义按钮、通用弹窗、跨端自适应布局脚手架 (ResponsiveScaffold)
│   └── extensions/        # Dart 语法糖扩展 (如 BuildContext 扩展，快速获取主题/路由)
│
└── features/              # 🚀 业务功能模块 (Feature-first 核心架构)
    │
    ├── auth/              # 🔐 认证模块 (扫码登录、Cookie 管理)
    │   ├── application/   # 状态管理 (Riverpod Providers：当前登录用户状态)
    │   ├── domain/        # 数据模型 (User, Session)
    │   ├── data/          # 数据仓库 (BiliAuthRepository：请求二维码、轮询状态)
    │   └── presentation/  # UI 视图 (LoginScreen, UserAvatarWidget)
    │
    ├── player/            # 🎵 播放器核心模块 (最核心的模块)
    │   ├── application/   # 播放队列状态、当前播放进度、播放模式 (循环/随机)
    │   ├── domain/        # 音频模型 (AudioTrack, Lyric)
    │   ├── data/          # 封装 media_kit 的底层调用
    │   └── presentation/  # 底部播放控制条、全屏歌词页、频谱动效
    │
    ├── playlist/          # 🗂️ 歌单管理模块 (B站收藏夹同步、本地自建歌单)
    │   ├── application/   # 增删改查歌单状态
    │   ├── domain/        # 歌单及关系模型 (Playlist, SongItem)
    │   ├── data/          # Drift 数据库读写 Repository
    │   └── presentation/  # 歌单列表页、歌曲拖拽排序 UI
    │
    ├── search_and_parse/  # 🔍 解析与搜索模块 (核心解耦部分)
    │   ├── application/   # 解析状态 (解析中、多 P 选择中、解析失败)
    │   ├── domain/        # B站特有模型 (Bvid, Cid, AudioStreamUrl)
    │   ├── data/          # 调用 api 请求 B站真实流地址
    │   └── presentation/  # 搜索栏、BV号输入框、多 P 勾选弹窗
    │
    ├── download/          # ⬇️ 缓存与下载模块
    │   ├── application/   # 任务队列、下载进度监听
    │   ├── data/          # 本地文件 I/O、后台下载服务 (Android 需特殊保活)
    │   └── presentation/  # 下载管理页面 (展示进度条)
    │
    └── settings/          # ⚙️ 设置模块
        ├── application/   # 用户偏好状态 (语言、主题、缓存路径)
        └── presentation/  # 设置页 UI
```

## 跨端适配 (Desktop vs Android) 的关键设计说明

针对你提到的 Android 移动端适配以及桌面端特性，我们在架构设计上需要注意以下几点：

1. **响应式 UI 脚手架 (`shared/widgets/responsive_scaffold.dart`)**：
   - 这个组件会根据屏幕宽度（Breakpoint）自动切换导航模式。
   - **Desktop (宽屏)**：左侧显示固定侧边栏 (Sidebar)，顶部使用自定义拖拽标题栏 (`window_manager`)。
   - **Android (窄屏)**：隐藏左侧侧边栏，启用底部导航栏 (BottomNavigationBar) 或抽屉 (Drawer)，并忽略桌面端窗口管理逻辑。
2. **后台播放与下载**：
   - 桌面端后台播放和下载相对简单。Android 端当前已经通过 `audio_service` 接管媒体通知栏、锁屏控制和后台播放会话。
3. **文件系统权限**：
   - 桌面端的缓存路径可以默认在用户的 Music 或 AppData 目录下。
   - Android 10+ 引入了分区存储 (Scoped Storage)，我们需要在 `core/utils/path_provider` 中根据平台动态获取合法的缓存目录，并向用户动态申请存储权限。
