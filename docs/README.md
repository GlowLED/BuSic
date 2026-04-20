# BuSic Docs

本目录优先为两类读者服务：

1. **清空上下文的 agent**：几分钟内恢复对项目的有效认知，知道真源、坑点和改动入口。
2. **首次接手的新开发者 / 维护者**：按最短路径跑起项目、理解架构并安全修改。

BuSic 的文档重点不是重复 Flutter / Riverpod / Drift 的共识知识，而是记录**项目特有、外部资料少、模型先验弱**的内容：Bilibili 接入细节、字幕错配与前缀校验、`versions-manifest.json`、蓝奏云维护、桌面托盘/窗口行为、极简模式、下载缓存联动、分享/备份约束等。

## 先读哪几篇

### 冷启动 Agent

1. [00-start-here/agent-quickstart.md](./00-start-here/agent-quickstart.md)
2. [10-project/project-overview.md](./10-project/project-overview.md)
3. [10-project/project-specific-rules.md](./10-project/project-specific-rules.md)
4. [30-reference/source-of-truth.md](./30-reference/source-of-truth.md)

### 新开发者 / 新维护者

1. [00-start-here/newcomer-path.md](./00-start-here/newcomer-path.md)
2. [20-workflows/build-guide.md](./20-workflows/build-guide.md)
3. [20-workflows/debug-guide.md](./20-workflows/debug-guide.md)
4. [20-workflows/dev-workflow.md](./20-workflows/dev-workflow.md)

### 改具体系统时

- 播放 / 队列 / 本地缓存：先看 [10-project/project-overview.md](./10-project/project-overview.md)
- B站接口 / Cookie / WBI / 评论 / 收藏夹：先看 [10-project/bilibili-integration.md](./10-project/bilibili-integration.md)
- 字幕 / 歌词：先看 [10-project/subtitle-and-lyrics.md](./10-project/subtitle-and-lyrics.md)
- 分享 / 备份 / 跨设备导入：先看 [10-project/share-and-backup.md](./10-project/share-and-backup.md)
- 更新系统 / Manifest / Release / 蓝奏云：先看 [10-project/update-system.md](./10-project/update-system.md)
- 桌面 / 移动端差异、托盘、窗口、极简模式：先看 [10-project/ui-and-platform-quirks.md](./10-project/ui-and-platform-quirks.md)

## 文档结构

```text
docs/
├── README.md
├── 00-start-here/   # 冷启动入口、阅读路径、docs 维护规范
├── 10-project/      # BuSic 特有的运行机制、坑点和项目知识
├── 20-workflows/    # 构建、调试、开发、发布流程
├── 30-reference/    # 相对稳定的架构 / 编码 / 状态 / 数据层参考
├── 40-feature-plans/# 新功能的活跃规划区
└── 90-archive/      # 历史设计、旧规划、单次发布记录
```

### 各层职责

- `00-start-here/`：默认阅读路径，只放入口和维护规则。
- `10-project/`：只写 BuSic 特有知识，不写大段通用教程。
- `20-workflows/`：只写“怎么做事”，例如构建、调试、发布。
- `30-reference/`：可重复引用的稳定规范和真源索引。
- `40-feature-plans/`：尚未落地或正在实施的大型功能设计文档。
- `90-archive/`：历史背景，不作为当前实现真源。

## 当前真源

开始怀疑文档是否过时时，优先信这些文件：

- `pubspec.yaml`
- `versions-manifest.json`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `lib/main.dart`
- `lib/app.dart`
- `lib/core/router/app_router.dart`
- `lib/core/database/app_database.dart`
- `lib/core/api/bili_dio.dart`

更完整的真源索引见 [30-reference/source-of-truth.md](./30-reference/source-of-truth.md)。

## BuSic 最容易误判的事实

- 数据库方案是 **Drift**，不是 Isar。
- Android 后台播放已经通过 `audio_service` 接入。
- `BiliDio` 不是普通 CookieJar 封装，而是 **raw cookie 注入**，专门绕过 `SESSDATA` 含逗号的问题。
- 歌词/字幕不是“调用一次 API 就能稳定拿到”，存在 **AI 字幕错配**，当前实现依赖 **前缀校验 + 重试**。
- 更新系统的主真源是 `versions-manifest.json`，不是仅靠 GitHub Releases 页面。
- 蓝奏云渠道是**手动维护**的，不是全自动上传。
- 下载完成后会**反向刷新 `songs.localPath / audioQuality`**，播放器会据此优先走离线文件。
- 备份 / 分享数据刻意**不携带本地下载路径**，避免跨设备导入污染。

## 历史文档怎么用

`90-archive/` 下的文档只用于：

- 查设计背景
- 查为什么当时这么做
- 查某个功能的早期方案和演进记录

它们**不是当前实现的真源**。默认阅读路径不会经过这些文档。

## 维护规则

关于 `docs/` 自己如何组织、如何新增文档、哪些改动必须同步更新文档，请看：

- [00-start-here/docs-maintenance.md](./00-start-here/docs-maintenance.md)
