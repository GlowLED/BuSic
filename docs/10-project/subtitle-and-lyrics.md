# Subtitle And Lyrics

BuSic 的歌词系统不是普通“调一个接口拿 SRT”模式。这里记录**当前实现真正依赖的项目特化结论**。

## 1. 当前实现目标

- 自动从 B站字幕系统获取歌词 / 字幕
- 优先用 AI 字幕
- 失败时可回退到 CC 字幕
- 结果缓存到本地数据库
- 播放时按当前进度高亮显示

## 2. 最大坑点：AI 字幕 URL 错配

当前最关键的非共识事实：

- `/x/player/v2` 返回的 `subtitle_url` 并不稳定
- 同一个 `bvid + cid`，返回的 AI 字幕 URL 可能对应**别的视频**
- 所以“接口成功返回 URL”不等于“拿到了正确字幕”

这也是为什么 BuSic 的实现不能按普通 REST 心智直接信任返回结果。

## 3. 当前规避策略

`lib/features/subtitle/data/subtitle_repository_impl.dart` 当前策略是：

1. 先用 `/x/web-interface/view` 拿 `aid`
2. 再请求 `/x/player/v2` 获取字幕列表
3. 优先选 AI 中文字幕，再回退到其他 AI / CC
4. 对 AI 字幕 URL 做前缀校验
5. 错配则重试，默认最多 10 次
6. 成功后下载字幕 JSON
7. 解析并缓存到 DB

### 前缀校验做了什么

AI 字幕 URL 中路径前缀应以 `{aid}{cid}` 开头。  
当前实现会验证这个前缀，不通过就认为拿到的是错字幕。

## 4. 登录态要求

字幕链路不是完全匿名可用的。  
当前实现遇到登录态问题会抛 `SubtitleLoginRequiredException`。

所以出现“没有歌词”时，不要第一时间只怀疑网络或解析逻辑，也要排查：

- 用户是否已登录
- Cookie 是否过期

## 5. 缓存规则

字幕会缓存到 `Subtitles` 表中：

- 键：`bvid + cid`
- 内容：完整 subtitle JSON
- 先查缓存，再打远端

这意味着：

- 同一首歌重复进入歌词页，不会每次重新抓取
- 改远端获取策略时，要考虑旧缓存的兼容性

## 6. UI 与播放器联动

当前歌词展示不是独立系统，而是直接依赖播放器状态：

- 播放进度驱动当前行高亮
- 点击歌词行可跳转播放位置
- 全屏播放器与评论系统存在手势和页面切换关系

改歌词展示时，不能只盯 `subtitle` feature，还要看：

- `player`
- `full_player_screen`
- 评论页和纵向 / 横向 `PageView`

## 7. 当前最常见误区

- 以为 `/x/player/v2` 成功就说明字幕正确
- 忽略登录态
- 只看歌词 UI，不看播放器进度同步
- 改字幕获取逻辑时忘了缓存层
- 忽略 AI / CC 的优先级与回退关系

## 8. 修改这部分时要一起看什么

- `lib/features/subtitle/data/subtitle_repository_impl.dart`
- `lib/features/subtitle/application/subtitle_notifier.dart`
- `lib/features/subtitle/presentation/widgets/lyrics_panel.dart`
- `lib/features/player/presentation/full_player_screen.dart`
- `lib/core/database/tables/subtitles.dart`
- `lib/core/database/app_database.dart`

## 9. 深度背景

如果你需要看研究过程或历史实施方案，再去看：

- [../90-archive/feature-plans/lyrics-research.md](../90-archive/feature-plans/lyrics-research.md)
- [../90-archive/feature-plans/subtitle-system-plan.md](../90-archive/feature-plans/subtitle-system-plan.md)
