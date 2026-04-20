# B站 AI 字幕歌词系统 — 研究报告

> 对应 Issue: [#15 - [Feat] 实现基于字幕自动抓取、AI 字幕有关的歌词系统](https://github.com/GlowLED/BuSic/issues/15)  
> 日期: 2025-07  
> 状态: 研究完成，待实现

---

## 1. 研究目标

为 BuSic 实现歌词系统，核心需求：
- 播放 B 站音乐视频时自动获取歌词
- 歌词来源：**B 站 AI 生成字幕**（识别音频中的歌词并按时间轴标注）
- 离线缓存已获取的歌词

## 2. API 概览

### 2.1 字幕列表获取

**REST API（Web 端）**

```
GET https://api.bilibili.com/x/player/v2?bvid={bvid}&cid={cid}
Cookie: SESSDATA=xxx
```

响应路径：`data.subtitle.subtitles[]`

字段说明：
| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | int64 | 字幕 ID（如 `1585606170285090048`） |
| `id_str` | string | 字幕 ID 字符串 |
| `lan` | string | 语言代码（如 `ai-zh`） |
| `lan_doc` | string | 语言名称（如 `中文（自动生成）`） |
| `subtitle_url` | string | 字幕文件 URL |
| `type` | int | 0=CC 字幕, 1=AI 字幕 |
| `ai_type` | int | 0=Normal, 1=Translate |
| `ai_status` | int | 0=None, 1=Exposure, 2=Assist |

**gRPC API（客户端）**

```protobuf
service DM {
    rpc DmView(DmViewReq) returns (DmViewReply);
}

message DmViewReq {
    int64 pid = 1;  // aid
    int64 oid = 2;  // cid
    int32 type = 3; // 1=视频
}

// DmViewReply.subtitle → VideoSubtitle → repeated SubtitleItem
```

> gRPC 端点可能比 REST API 更稳定，但需要 protobuf 编译和 gRPC 客户端支持。

### 2.2 字幕内容获取

直接 GET 请求 `subtitle_url` 返回的 URL：

```
GET https://aisubtitle.hdslb.com/bfs/ai_subtitle/prod/{path}?auth_key={auth_key}
```

返回 JSON：
```json
{
  "font_size": 0.4,
  "font_color": "#FFFFFF",
  "background_alpha": 0.5,
  "background_color": "#9C27B0",
  "Stroke": "none",
  "body": [
    {
      "from": 0.0,
      "to": 3.52,
      "sid": 0,
      "location": 2,
      "content": "♪ 那一年你和我一样年轻... ♪",
      "music": 1.0
    }
  ]
}
```

字幕条目字段：
| 字段 | 说明 |
|------|------|
| `from` | 开始时间（秒） |
| `to` | 结束时间（秒） |
| `content` | 字幕文本（歌词行以 `♪` 开头结尾） |
| `music` | 音乐占比（1.0 = 纯音乐/歌词，0.0 = 纯语音） |
| `location` | 显示位置 |

## 3. 关键发现

### 3.1 ⚠️ API 不稳定性（核心问题）

`/x/player/v2` 返回的 `subtitle_url` 存在**严重的不稳定性**：

- 同一个 bvid+cid 请求，每次返回的 `subtitle_url` 可能**完全不同**
- 大部分情况下返回的是**其他视频的 AI 字幕**（服务端 bug / 负载均衡问题）
- 实测命中率约 **10-30%**（10 次请求中仅 1-3 次返回正确字幕）
- 某些视频可能**永远无法命中**（20 次尝试 0 次成功）

### 3.2 URL 结构解析

AI 字幕 URL 格式：
```
https://aisubtitle.hdslb.com/bfs/ai_subtitle/prod/{aid}{cid}{32char_md5}?auth_key={expire}-{rand}-{uid}-{sign}
```

路径部分：
- `/bfs/ai_subtitle/prod/` — 固定前缀
- `{aid}{cid}` — 视频的 aid 和 cid **直接拼接**（无分隔符）
- `{32char_md5}` — 32 位十六进制（服务端生成，无法客户端复现）

auth_key 部分：
- `{expire}` — Unix 时间戳（过期时间，通常为当前时间 + 数小时）
- `{rand}` — 32 位随机十六进制（nonce）
- `{uid}` — 始终为 `0`
- `{sign}` — 32 位 MD5 签名（CDN 防盗链）

| 特性 | 说明 |
|------|------|
| auth_key 有效期 | 数小时（测试显示 5h+ 仍有效） |
| 跨路径使用 | ❌ 403（auth_key 绑定到特定 path） |
| 无 auth_key | ❌ 403 |
| 客户端生成 | ❌ 不可能（CDN 密钥未知） |

CC 字幕 URL 格式（参考）：
```
https://...hdslb.com/bfs/subtitle/{hash}.json
```
CC 字幕无已知错配问题。

### 3.3 🎯 前缀验证策略（关键解决方案）

**核心发现：AI 字幕 URL 路径始终以 `{aid}{cid}` 开头。**

验证逻辑：
```
正确：/prod/4510136291335303605c26b9de05e4fcd...
              ↑ aid=451013629 + cid=1335303605 ✓

错误：/prod/11334972342350626411a3b7f8c9d...
              ↑ 其他视频的 aid+cid ✗
```

这意味着可以在不下载字幕内容的情况下，仅通过 URL 路径**立即判断**返回的字幕是否属于目标视频。

**实测结果（3 个测试视频，各 20 次重试）**：

| 视频 | 描述 | 结果 | 命中次数 | 平均轮次 |
|------|------|------|----------|----------|
| BV1kj411E7XP | 错位时空 | ✅ 成功 | 1/6 | 6 次 |
| BV1MqAozKEo4 | 洛天依歌曲 | ✅ 成功 | 1/3 | 3 次 |
| BV1be411N7JA | DiffSinger | ❌ 失败 | 0/20 | N/A |

DiffSinger 视频失败原因推测：该视频可能本身**未生成 AI 字幕**（所有返回的 URL 均指向其他视频的字幕）。

## 4. 推荐实现方案

### 4.1 获取流程

```
┌─────────────────────────────────────────────┐
│ 1. 获取 aid + cid（from video info API）        │
│ 2. expected_prefix = "${aid}${cid}"            │
│ 3. for attempt in 1..MAX_RETRIES:              │
│    a. GET /x/player/v2?bvid=&cid=              │
│    b. Extract subtitle_url                      │
│    c. Parse URL path after /prod/               │
│    d. if path.startsWith(expected_prefix):      │
│       → Fetch subtitle JSON                    │
│       → Verify music ratio > threshold          │
│       → Cache & return ✓                       │
│    e. else: continue (wrong video)              │
│ 4. Return null (no lyrics available)            │
└─────────────────────────────────────────────┘
```

### 4.2 参数建议

| 参数 | 推荐值 | 说明 |
|------|--------|------|
| MAX_RETRIES | 10-15 | 足以覆盖 ~30% 命中率场景 |
| RETRY_DELAY | 300-500ms | 避免触发频控 |
| MUSIC_RATIO_MIN | 0.3 | 歌词 `music` 字段过滤 |
| AUTH_KEY_CACHE | 启用 | 有效 auth_key 可复用数小时 |

### 4.3 Dart/Flutter 实现要点

```dart
/// 验证 AI 字幕 URL 是否属于目标视频
bool validateSubtitleUrl(String url, int aid, int cid) {
  final uri = Uri.parse(url.startsWith('//') ? 'https:$url' : url);
  final path = uri.path;
  
  if (path.contains('/bfs/ai_subtitle/')) {
    // AI 字幕：路径 /prod/{aid}{cid}{hash}
    final match = RegExp(r'/prod/(\d+)').firstMatch(path);
    if (match != null) {
      final prefix = match.group(1)!;
      final expected = '$aid$cid';
      return prefix.startsWith(expected);
    }
    return false;
  }
  // CC 字幕无已知问题
  return true;
}
```

### 4.4 数据模型

```dart
@freezed
class LyricLine with _$LyricLine {
  const factory LyricLine({
    required double from,       // 开始时间（秒）
    required double to,         // 结束时间（秒）
    required String content,    // 歌词文本
    @Default(0.0) double music, // 音乐占比
  }) = _LyricLine;
}
```

### 4.5 缓存策略

1. **DB 缓存**：歌词按 `(aid, cid)` 缓存到 Drift 表
2. **首次获取**：用前缀验证 + 重试逻辑
3. **后续播放**：直接从 DB 读取
4. **字幕 URL 过期无影响**：内容已缓存，不需要 auth_key

### 4.6 降级与容错

| 场景 | 处理 |
|------|------|
| 重试耗尽无结果 | 显示"无歌词"，标记该视频已尝试 |
| 视频无 AI 字幕 | 检测模式：20 次全miss → 标记无字幕 |
| 网络错误 | 常规重试 + 指数退避 |
| auth_key 过期 | 重新请求 /x/player/v2 获取新 URL |
| SESSDATA 过期 | 提示用户重新登录 |

## 5. 替代方案（备选）

### 5.1 gRPC DmView API

通过 gRPC 调用 `bilibili.community.service.dm.v1.DM/DmView`：
- 入参：`pid=aid, oid=cid, type=1`
- 返回 `DmViewReply.subtitle.subtitles[]`（同 SubtitleItem）
- 优势：可能更稳定（客户端原生使用）
- 劣势：需要 protobuf 编译 + gRPC 库 + 认证头处理

### 5.2 bcut-asr（必剪 API）

- 独立的语音识别服务，可上传音频获取字幕
- 不依赖 B 站视频 API
- 需要额外实现音频提取 + 上传流程
- 延迟较高（需要等待处理）

### 5.3 外部歌词 API（如 QQ 音乐/网易云）

- 按歌曲名搜索匹配歌词
- 不限于 B 站视频
- 匹配可能不精确
- 需要额外 API 对接

## 6. 技术验证脚本

所有验证脚本位于 `temp/` 目录（已被 .gitignore 排除）：

| 脚本 | 说明 |
|------|------|
| `robust_subtitle_fetch.py` | **最终方案验证** — 前缀验证 + 重试策略 |
| `verify_prefix.py` | 前缀假设验证（发现 {aid}{cid} 规律） |
| `analyze_subtitle_url.py` | URL 结构深度分析 |
| `bili_login.py` | B 站扫码登录工具 |
| `session.json` | 保存的登录态 |

## 7. 实现优先级建议

1. **P0 — 核心获取逻辑**：实现前缀验证 + 重试获取 AI 字幕
2. **P0 — 数据模型**：LyricLine + DB 缓存表
3. **P1 — 播放器集成**：歌词与 audio_service 时间轴同步显示
4. **P1 — UI**：歌词显示面板（当前行高亮 + 自动滚动）
5. **P2 — 预加载**：播放列表预获取歌词
6. **P2 — 手动搜索**：支持手动输入歌曲名搜索歌词

## 8. 风险与注意事项

1. **API 限流**：高频重试可能触发 B 站风控，建议控制 QPS ≤ 2
2. **SESSDATA 必须**：获取字幕列表需要登录态
3. **部分视频无字幕**：不是所有音乐视频都有 AI 字幕
4. **字幕质量参差**：AI 生成的歌词可能有识别错误
5. **B 站 API 变更**：API 可能随时变更，需要做好容错

---

*本报告基于 2025-07 实测数据，API 行为可能随 B 站更新而变化。*
