# 评论区功能设计文档

## 1. 需求概述

为 BuSic 接入 Bilibili 视频评论区功能，用户可以：

- **浏览评论**：查看当前视频的热门/最新评论
- **查看楼中楼**：展开子评论（回复）
- **发表评论**：登录后可对视频发表评论
- **回复评论**：登录后可回复他人评论
- **点赞评论**：登录后可为评论点赞/取消点赞

## 2. 接入界面分析

| 界面 | 接入方式 | 优先级 | 说明 |
|---|---|---|---|
| **FullPlayerScreen** | 滑动切换 Tab（封面 ↔ 评论） | P0 | 全屏播放时可左右滑动查看评论，最自然的交互入口 |
| **SearchScreen（视频详情）** | 视频信息卡片下方展示评论区 | P0 | 搜索/解析出视频后直接查看评论 |
| **PlaylistDetailScreen** | 长按歌曲 → 查看评论菜单项 | P1 | 歌单中歌曲可快速跳转查看评论 |

### 2.1 FullPlayerScreen 集成方案

将现有的封面 + 控制区域作为 **Tab 0**，新增评论列表作为 **Tab 1**，使用 `PageView` 实现左右滑动切换，底部指示器显示当前 Tab。

### 2.2 SearchScreen 集成方案

在 `_buildVideoDetail` 方法的操作按钮行下方，新增可折叠的评论区组件 `CommentSection`，默认折叠，点击"查看评论"按钮后展开加载。

### 2.3 PlaylistDetailScreen 集成方案（P1）

在歌曲的长按菜单或 `PopupMenuButton` 中新增"查看评论"选项，点击后弹出 `BottomSheet` 展示评论区。

## 3. Bilibili 评论 API

### 3.1 获取评论列表

```
GET /x/v2/reply/main
```

| 参数 | 类型 | 说明 |
|---|---|---|
| `type` | int | 资源类型，视频 = 1 |
| `oid` | int | 视频 AID (avid) |
| `mode` | int | 排序: 2=时间(最新), 3=热度(热门) |
| `next` | int | 分页游标，从 0 开始 |
| `ps` | int | 每页数量，默认 20 |

> **⚠️ 注意 `mode` 参数容易混淆！**
>
> - `mode=2` → **按时间排序**（最新评论在前）
> - `mode=3` → **按热度排序**（热门评论在前）
>
> 与直觉相反，数字越大反而是热度而非时间。代码中默认使用 `mode=3`（热门）。

**响应结构**:
```json
{
  "data": {
    "cursor": {
      "all_count": 1234,
      "next": 2,
      "is_end": false
    },
    "replies": [
      {
        "rpid": 123456,
        "mid": 100000,
        "content": { "message": "评论内容" },
        "ctime": 1700000000,
        "like": 42,
        "rcount": 5,
        "action": 0,
        "member": {
          "mid": "100000",
          "uname": "用户名",
          "avatar": "https://..."
        },
        "replies": [...]
      }
    ]
  }
}
```

### 3.2 获取子评论（楼中楼）

```
GET /x/v2/reply/reply
```

| 参数 | 类型 | 说明 |
|---|---|---|
| `type` | int | 1 |
| `oid` | int | 视频 AID |
| `root` | int | 根评论 rpid |
| `pn` | int | 页码，从 1 开始 |
| `ps` | int | 每页数量 |

### 3.3 发表评论

```
POST /x/v2/reply/add
```

| 参数 | 类型 | 说明 |
|---|---|---|
| `type` | int | 1 |
| `oid` | int | 视频 AID |
| `message` | String | 评论内容 |
| `root` | int? | 回复的根评论 rpid（发表新评论时省略） |
| `parent` | int? | 回复的父评论 rpid（发表新评论时省略） |
| `csrf` | String | bili_jct (CSRF token) |

### 3.4 点赞评论

```
POST /x/v2/reply/action
```

| 参数 | 类型 | 说明 |
|---|---|---|
| `type` | int | 1 |
| `oid` | int | 视频 AID |
| `rpid` | int | 评论 rpid |
| `action` | int | 1=点赞, 0=取消 |
| `csrf` | String | bili_jct |

### 3.5 AID 获取

评论 API 需要视频的 `aid`（数字 ID），而非 `bvid`。`/x/web-interface/view` API 的响应中包含 `aid` 字段，需要在 `BvidInfo` 模型中新增 `aid` 属性。

## 4. 架构设计

### 4.1 Feature 模块结构

```
lib/features/comment/
├── domain/
│   └── models/
│       ├── comment.dart              # 评论 Freezed 模型
│       └── comment_reply_page.dart   # 分页响应模型
├── data/
│   ├── comment_repository.dart       # 抽象接口
│   └── comment_repository_impl.dart  # 具体实现
├── application/
│   └── comment_notifier.dart         # Riverpod family notifier
└── presentation/
    ├── comment_section.dart          # 可复用评论区组件
    └── widgets/
        ├── comment_tile.dart         # 单条评论 Widget
        ├── comment_input.dart        # 评论输入框
        └── reply_sheet.dart          # 子评论 BottomSheet
```

### 4.2 数据模型

#### Comment

```dart
@freezed
class Comment with _$Comment {
  const factory Comment({
    required int rpid,           // 评论 ID
    required int mid,            // 用户 ID
    required String username,    // 用户名
    required String avatarUrl,   // 头像 URL
    required String content,     // 评论内容
    required int ctime,          // 时间戳(秒)
    required int likeCount,      // 点赞数
    required int replyCount,     // 回复数
    @Default(false) bool isLiked, // 当前用户是否点赞
    @Default([]) List<Comment> replies, // 预览子评论
  }) = _Comment;
}
```

#### CommentReplyPage

```dart
@freezed
class CommentReplyPage with _$CommentReplyPage {
  const factory CommentReplyPage({
    required int totalCount,
    required int next,
    required bool isEnd,
    required List<Comment> replies,
  }) = _CommentReplyPage;
}
```

### 4.3 Repository 接口

```dart
abstract class CommentRepository {
  /// 获取评论列表，返回分页数据
  Future<CommentReplyPage> getComments({
    required int oid,
    int mode = 2,
    int next = 0,
    int ps = 20,
  });

  /// 获取子评论
  Future<CommentReplyPage> getReplies({
    required int oid,
    required int rootRpid,
    int page = 1,
    int ps = 20,
  });

  /// 发表评论
  Future<Comment> addComment({
    required int oid,
    required String message,
    required String csrf,
    int? root,
    int? parent,
  });

  /// 点赞/取消评论
  Future<void> likeComment({
    required int oid,
    required int rpid,
    required bool like,
    required String csrf,
  });

  /// 通过 bvid 获取 aid
  Future<int> getAidByBvid(String bvid);
}
```

### 4.4 Notifier 设计

使用 `@riverpod` 注解的 auto-dispose family notifier，参数为视频 `bvid`（内部自动解析为 aid）：

```dart
@riverpod
class CommentNotifier extends _$CommentNotifier {
  // Family parameter: bvid
  // State: AsyncValue<CommentState>

  // CommentState 包含:
  // - aid (已解析的 aid)
  // - comments (当前加载的评论列表)
  // - cursor (分页游标)
  // - isEnd (是否到底)
  // - sortMode (排序模式)
  // - totalCount (评论总数)
}
```

### 4.5 BvidInfo 模型修改

在 `BvidInfo` 中新增 `aid` 字段（int?, 可选），并在 `ParseRepositoryImpl.getVideoInfo()` 中捕获 API 返回的 `aid` 值。

## 5. UI 设计

### 5.1 CommentSection（可复用组件）

- 接收 `bvid` 参数，内部自动获取 `aid` 并加载评论
- 顶部：评论数量 + 排序切换（热度/时间）
- 列表：`ListView` + 上拉加载更多（`ScrollController` 监听滚动到底部）
- 底部固定：评论输入框（未登录时显示"登录后评论"提示）

### 5.2 CommentTile（单条评论）

```
┌──────────────────────────────┐
│ [头像]  用户名        3小时前 │
│         评论内容文本          │
│         👍 42   💬 5 (展开)  │
│         ├── 子评论1预览       │
│         └── 子评论2预览       │
└──────────────────────────────┘
```

- 头像：`CircleAvatar` + `CachedNetworkImage`
- 点赞按钮：登录后可点击，实时更新状态
- 回复数：点击"xx条回复"打开 `ReplySheet` 展示完整子评论

### 5.3 CommentInput（评论输入框）

- 未登录：显示"登录后可发表评论"，点击跳转登录页
- 已登录：输入框 + 发送按钮
- 回复模式：显示"回复 @用户名"，可取消

### 5.4 ReplySheet（子评论弹窗）

- `showModalBottomSheet` + `DraggableScrollableSheet`
- 展示根评论 + 分页加载子评论
- 底部输入框可回复

## 6. FullPlayerScreen 集成详细方案

```
┌─────────────────────────────┐
│  ↓ 返回                 队列 │
│                              │
│  ┌─────────────────────────┐ │ ← PageView
│  │      封面 / 评论区      │ │    Tab 0: 封面
│  │                         │ │    Tab 1: CommentSection
│  └─────────────────────────┘ │
│    ●  ○    ← 页面指示器      │
│                              │
│  歌曲标题                    │
│  歌手名                      │
│                              │
│  ━━━━━●━━━━━━━━ 进度条       │
│  01:23        04:56          │
│                              │
│  ↻   ⏮   ▶   ⏭   🔊      │
│                              │
└─────────────────────────────┘
```

- `PageView` 包含两页：封面页（现有 cover art）和评论页（`CommentSection`）
- 底部添加 `PageIndicator` 小圆点
- 评论区从当前播放的 `bvid` 获取

## 7. 实施计划

| 步骤 | 内容 | 依赖 |
|---|---|---|
| 1 | 创建 `Comment` Freezed 模型 | 无 |
| 2 | 修改 `BvidInfo` 添加 `aid` 字段 | 无 |
| 3 | 实现 `CommentRepository` 接口 + 实现类 | BiliDio |
| 4 | 实现 `CommentNotifier` | Repository |
| 5 | 实现 `CommentTile` Widget | Comment 模型 |
| 6 | 实现 `CommentInput` Widget | AuthNotifier |
| 7 | 实现 `ReplySheet` Widget | CommentNotifier |
| 8 | 组装 `CommentSection` 组件 | 以上所有 |
| 9 | 接入 `FullPlayerScreen`（PageView） | CommentSection |
| 10 | 接入 `SearchScreen`（视频详情下方） | CommentSection |
| 11 | 添加国际化字符串 | 无 |
| 12 | 运行 build_runner，flutter analyze | 所有代码 |
| 13 | Linux 构建测试 | 步骤 12 |

## 8. 注意事项

1. **BiliDio cookie 注入**：评论 API 需要登录 cookie，`BiliDio` 已自动注入 SESSDATA
2. **CSRF token**：发评论/点赞需要 `bili_jct`，从 `AuthNotifier` 的 `User` 状态获取
3. **AID 缓存**：`CommentNotifier` 在首次 build 时解析 bvid→aid 并缓存
4. **错误处理**：API 可能返回 -101（未登录）、-404（视频不存在）等错误码
5. **性能**：评论列表使用 `ListView.builder` 懒加载 + 分页
6. **评论内容安全**：直接展示 B 站返回的内容，不做额外 HTML 解析（`content.message` 已是纯文本）
