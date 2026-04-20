# Project-Specific Rules

这里只写 **BuSic 特有规则**。如果一条规则在普通 Flutter 项目里并不常见，它就应该出现在这里。

## 1. Source of Truth 规则

- **运行与版本真源**：`pubspec.yaml`
- **应用内更新真源**：`versions-manifest.json`
- **路由真源**：`lib/core/router/app_router.dart`
- **数据库真源**：`lib/core/database/app_database.dart`
- **B站 HTTP 行为真源**：`lib/core/api/bili_dio.dart`

历史文档不能覆盖这些文件。

## 2. 歌曲身份与元数据规则

- 歌曲唯一标识是 **`bvid + cid`**
- `Songs.id` 是本地数据库主键，不可替代 `bvid + cid`
- 标题 / 作者采用 **origin + custom 覆盖模式**
  - `originTitle / originArtist`：远端原始值
  - `customTitle / customArtist`：本地覆盖值
- UI 展示时优先用 `displayTitle / displayArtist` 这类封装结果，不要随意直接读 origin/custom 字段

## 3. 下载与本地缓存规则

- 下载任务状态不只存在于 `download_tasks`
- 下载成功后必须回写：
  - `songs.localPath`
  - `songs.audioQuality`
- 删除已完成下载并清理文件时，也必须把这两个字段清空
- 播放器恢复、切歌、继续播放时会**重新查询最新本地路径**，不要假设队列中的 `localPath` 永远最新
- 同一首歌的缓存是按歌曲复用的，不是按歌单隔离的

## 4. 分享 / 备份规则

- 歌单分享使用 `busic://playlist/` 前缀
- 分享数据只带最小重建字段：
  - `bvid`
  - `cid`
  - 可选 `customTitle / customArtist`
- 完整备份也**不包含本地下载路径**
- 完整备份也**不包含下载任务**
- 这是刻意设计，不是遗漏；跨设备导入本地路径会污染数据

## 5. Provider 与状态规则

- 大部分业务状态用 Riverpod codegen
- 少数全局注入或特殊场景使用手动 `Provider`
  - `databaseProvider`
  - `appRouterProvider`
  - `audioHandlerProvider`
  - `downloadRepositoryProvider`
- 涉及跨对话框或异步空档的状态操作，要特别注意 AutoDispose 生命周期
- 后台持续行为一般会用 `keepAlive`
  - 典型例子：`PlayerNotifier`、`DownloadNotifier`

## 6. B站 HTTP 规则

- `BiliDio` 用的是 **raw cookie header 注入**
- 原因：`SESSDATA` 常带逗号，Dart 的 `Cookie` 解析不可靠
- 所有请求默认带：
  - 浏览器风格 `User-Agent`
  - `Referer: https://www.bilibili.com`

## 7. 更新系统规则

- `versions-manifest.json` 是多版本、多渠道下载清单
- GitHub Release 资产命名必须和应用内更新逻辑保持一致
- 蓝奏云不是自动上传链路的一部分，需要额外维护链接
- checksum 缺失时当前逻辑会跳过阻断式校验，不要误以为所有平台都严格强校验

## 8. 字幕 / 歌词规则

- 先查本地缓存，再打远端
- AI 字幕 URL 可能错配，必须前缀校验
- 获取不到字幕不等于接口坏了，也可能是登录态、错配或重试耗尽
- 这条链路的设计目标是“尽量拿到正确字幕”，不是“尽量快返回任意字幕”

## 9. 桌面 / 极简模式规则

- 桌面关闭窗口默认隐藏到托盘
- `ResponsiveScaffold` 决定桌面 / 移动端壳层差异
- 极简模式不是普通页面样式变体，而是单独路由和特殊生命周期策略
- 极简模式不在 `paused / resumed` 中干预播放，只在 `detached` 做彻底清理

## 10. 文档规则

- 主线文档只写当前事实、坑点和联动检查
- 长规划文档默认不再作为主知识源
- 改动特化系统时，必须同步更新对应的 `10-project/` 文档
