# Bilibili Integration

BuSic 最大的项目特化来源，就是 Bilibili 接入本身。这里汇总**当前实现里外部最难查、最容易误判**的部分。

## 1. HTTP 客户端：`BiliDio`

`lib/core/api/bili_dio.dart` 当前特性：

- 全局单例
- 默认 `baseUrl = https://api.bilibili.com`
- 默认浏览器风格 `User-Agent`
- 强制 `Referer: https://www.bilibili.com`
- 使用 **raw cookie 注入** 而不是 `dart:io Cookie`

### 为什么不用普通 Cookie

因为 B站的 `SESSDATA` 常含逗号，Dart 的 `Cookie` 类会拒绝解析。  
当前实现把 Cookie 存成 `Map<String, String>`，在请求前直接拼成 header：

```text
Cookie: key1=value1; key2=value2; ...
```

### Cookie 存储位置

- `documents/busic/cookies.json`

## 2. 登录态会影响什么

登录不仅影响“是否显示已登录头像”，还直接影响：

- 更高音质音频流
- 评论相关接口
- 收藏夹导入
- 字幕 / 歌词获取

因此很多“接口失败”本质上是登录态失效。

## 3. WBI 签名

不是所有 B站接口都要 WBI。当前需要特别留意的主要是：

- 搜索
- `playurl`

WBI 相关真源：

- `lib/core/api/wbi_sign.dart`
- 调用侧通常在 `search_and_parse` feature

如果你改了这些接口，不要直接套通用 Dio 调用模板。

## 4. 音频流获取

播放器实际播放前，常常还需要再解析一次音频流。

关键事实：

- 当前逻辑优先走本地缓存文件
- 无本地缓存时再请求远端流地址
- 音质选择与用户设置有关
- 高音质能力与登录态有关

这意味着“SongItem 已经在列表里”不代表它已经拥有可直接播放的 `streamUrl`。

## 5. 收藏夹导入

收藏夹导入不是独立 feature，而是复用在 `search_and_parse` + `playlist` 的链路中。

当前已知项目特化点：

- 需要登录
- 收藏夹 API 返回分页数据
- 实际导入按 `bvid + cid` 去重
- 多 P 视频并不是天然完整导入，必须结合具体 `cid`
- 导入时会复用本地已有歌曲，不会盲目重复建 Song

## 6. 评论系统

评论系统有几个易混点：

- 获取主评论列表时 `mode=2` 是按时间，`mode=3` 是按热度
- 回复和点赞都要求登录态
- 评论接口最终依赖 `aid`

所以如果你手里只有 `bvid` / `cid`，很多评论操作前还需要先解析出 `aid`。

## 7. 最常见失败模式

- Cookie 看起来存在，但实际上失效
- 忘了 `Referer`
- 把 `SESSDATA` 交给普通 Cookie 解析
- 误判某个接口是否需要 WBI
- 只拿 `bvid` 不拿 `cid` 就开始做歌曲级处理
- 收藏夹 / 评论 / 字幕问题其实是登录问题

## 8. 修改这部分时要一起看什么

- `lib/core/api/bili_dio.dart`
- `lib/core/api/wbi_sign.dart`
- `lib/features/auth/*`
- `lib/features/search_and_parse/*`
- `lib/features/comment/*`
- `lib/features/subtitle/*`
- `lib/features/playlist/application/bili_fav_import_notifier.dart`
