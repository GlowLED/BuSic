# 分享与备份系统

这部分知识是 BuSic 特化内容，不是“顺手存个 JSON”那么简单。它直接决定：

- 歌单分享是否可跨设备恢复
- 完整备份是否会污染本地数据
- 下载缓存是否会被错误导出

## 1. 当前能力

### 1.1 歌单分享

歌单分享使用剪贴板协议：

- 前缀：`busic://playlist/`
- 内容：Base64 编码的 JSON
- 当前最大支持版本：`1`

导出数据只保留最小可重建字段：

- `bvid`
- `cid`
- 可选 `customTitle`
- 可选 `customArtist`

不会导出：

- 本地数据库主键
- 本地下载路径
- 下载任务

### 1.2 完整备份

完整备份导出的是应用级结构数据：

- `playlists`
- `songs`
- `playlistSongs`

其中：

- `songs` 依然只保留跨设备可重建的歌曲身份和自定义元数据
- `playlistSongs` 不依赖本地 `songId`，而是转成 `bvid + cid`

## 2. 为什么故意不导出本地路径

本地路径和下载任务都是设备相关状态：

- 换设备后路径必然失效
- 直接导入会污染数据库
- 会让播放器误以为本地文件仍然可用

所以当前实现明确排除：

- `songs.localPath`
- `songs.audioQuality`
- `download_tasks`

这不是遗漏，而是设计约束。

## 3. 分享导入如何工作

真实入口：`lib/features/share/data/share_repository_impl.dart`

导入流程：

1. 校验前缀 `busic://playlist/`
2. Base64 解码
3. JSON 反序列化
4. 校验版本号
5. 校验歌曲列表非空
6. 创建新歌单
7. 逐首处理歌曲

逐首处理时的关键规则：

- 先按 `bvid + cid` 查询本地是否已有歌曲
- 已有则复用本地 `Songs.id`
- 没有则通过 `ParseRepository` 拉取视频元数据后新建歌曲
- 并发数当前限制为 `3`，避免过快触发 B 站频控

失败结果不会整批回滚，而是累计：

- `imported`
- `reused`
- `failed`
- `failedBvids`

## 4. 完整备份导入如何工作

真实入口：`lib/features/share/data/sync_repository_impl.dart`

### 4.1 Merge 导入

合并导入规则：

- 歌曲按 `bvid + cid` 去重
- 歌单按 `name` 去重
- 关系表使用 `insertOrIgnore`

当备份中的歌曲本地不存在时：

- 会先创建一条最小歌曲记录
- `originTitle / originArtist` 会使用占位信息
- `customTitle / customArtist` 会按备份值写入

这意味着：

- Merge 导入不依赖实时重新拉取远端元数据
- 导入后仍可在后续使用中补齐元数据

### 4.2 Overwrite 导入

覆盖导入不会粗暴清空整库。

当前行为是：

1. 清空 `playlistSongs`
2. 清空 `playlists`
3. 保留 `songs`
4. 对 `songs` 继续按 `bvid + cid` 复用或新增
5. 重建歌单与关系

保留 `songs` 的直接目的，是避免把已有本地缓存和歌曲记录一起抹掉。

## 5. 当前最重要的身份规则

- 跨设备身份：`bvid + cid`
- 本地主键：`Songs.id`
- 二者不能混用

如果你把导入导出协议改成依赖本地 `songId`，跨设备恢复就会立刻失效。

## 6. 修改这套系统时必须联动检查

- `lib/features/share/data/share_repository_impl.dart`
- `lib/features/share/data/sync_repository_impl.dart`
- `lib/features/share/domain/models/`
- `lib/features/search_and_parse/data/parse_repository.dart`
- `lib/core/database/app_database.dart`
- `docs/10-project/project-specific-rules.md`

如果改动影响导出协议，还要检查：

- 剪贴板兼容性
- 旧版本导入容错
- 备份文件跨版本兼容性

## 7. 最容易犯的错

- 把本地路径加进分享或备份
- 用 `Songs.id` 当跨设备身份
- 覆盖导入时顺手清空 `songs` 表
- 导入失败时直接丢失失败明细
- 忘记同步更新文档中的协议约束

## 8. Source of Truth

- `lib/features/share/data/share_repository_impl.dart`
- `lib/features/share/data/sync_repository_impl.dart`
- `lib/features/share/domain/models/shared_playlist.dart`
- `lib/features/share/domain/models/app_backup.dart`
