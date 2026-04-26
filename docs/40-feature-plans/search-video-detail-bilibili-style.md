# 搜索页视频详情 B 站式重构计划

## 1. 背景

当前搜索页点击搜索结果后，会在 `SearchScreen` 内调用 `parseNotifierProvider` 解析 BV，并把解析成功的视频交给 `VideoDetailView` 展示。现有详情页偏工具型，主要服务于封面、标题、分 P 选择、播放、下载、加入歌单和评论入口。

本计划覆盖 `search_and_parse`、`comment`、`auth`、`playlist`、`download` 和 `player` 的协作边界，目标是把搜索结果详情页重构为接近 B 站移动端视频详情页的体验，同时保留 BuSic 的听歌和资料库能力。

## 2. 目标与非目标

### 2.1 目标

- 点击搜索条目后，仍在搜索页内原地进入视频详情，不新增独立路由。
- 详情页采用 B 站式结构：顶部 16:9 媒体区、`简介 / 评论` 双 Tab、UP 信息、标题与统计、简介、标签、互动按钮、分 P / 合集入口和评论列表。
- 保留现有 BuSic 能力：播放音频、下载、添加到本地歌单、多 P 选择、评论查看 / 回复 / 点赞。
- B 站互动按钮接入真实登录态动作：点赞、投币、添加到 B 站收藏夹、分享记录并复制链接。
- 所有新增用户可见文本进入 `lib/l10n/app_en.arb` 和 `lib/l10n/app_zh.arb`。

### 2.2 非目标

- 不接入真实视频流播放。
- 不实现弹幕播放、弹幕发送、关注 UP 主、一键三连、相关推荐信息流。
- 不把搜索详情改成独立路由或深链页面。
- v1 收藏只做添加到 B 站收藏夹，不做从指定收藏夹移除。

## 3. 当前实现

- 搜索入口：`lib/features/search_and_parse/presentation/search_screen.dart`
  - 关键词走 `searchVideos`。
  - BV / URL 走 `parseInput`。
  - 点击搜索结果后复用 `parseInput(video.bvid)`，成功后展示 `VideoDetailView`。
- 详情 UI：`lib/features/search_and_parse/presentation/widgets/video_detail_view.dart`
  - 当前以 `AppPanel` 卡片展示视频信息、分 P 选择、播放、下载、加入歌单和评论折叠面板。
- 数据模型：`BvidInfo` 当前只有 `bvid`、`title`、`owner`、`ownerUid`、`coverUrl`、`pages`、`duration`。
- 评论：`CommentSection` 已支持评论加载、热门 / 最新排序、回复、点赞、登录态校验和输入框。
- B 站接入约束以 `docs/10-project/bilibili-integration.md` 为准，重点包括 raw cookie 注入、Referer、WBI 签名和登录态失效处理。

## 4. 方案设计

### 4.1 数据模型

扩展搜索解析侧 domain model：

- `BvidInfo`
  - 增加 `aid`、`description`、`pubdate`、`tname`、`ownerFace`、`stats`、`rights`、`tags`。
  - 保持现有字段向后兼容，搜索结果列表可以继续只填基础字段。
- 新增 `VideoStats`
  - `view`、`danmaku`、`reply`、`favorite`、`coin`、`share`、`like`。
- 新增 `VideoRights`
  - 至少保留 `noReprint`，用于简介区展示“未经作者授权禁止转载”一类提示。
- 新增 `VideoTag`
  - `id`、`name`。
- 新增 `VideoInteractionState`
  - `isLiked`、`isFavorited`、`coinsGiven`、`isBusy`、`lastError`。

`ParseRepositoryImpl.getVideoInfo` 继续以 `/x/web-interface/view` 作为视频详情真源，并映射 owner、stat、rights、pages 等字段。标签可通过单独方法补拉，失败时返回空列表，不阻塞详情页。

### 4.2 状态与流程

新增视频互动层，避免 Presentation 直接调接口：

- `VideoInteractionRepository`
  - 负责读取互动状态、点赞 / 取消点赞、投币、收藏夹添加、分享记录。
  - Data 层记录 `AppLogger`，把 B 站错误码转换成业务异常。
- `VideoInteractionNotifier`
  - family 参数使用 `bvid + aid`。
  - `build()` 中读取登录态；未登录返回未激活状态，不发需要登录的写接口。
  - 对点赞等轻量动作允许乐观更新；失败时回滚并暴露错误。
  - 投币和收藏属于确认型动作，成功后再更新状态。

搜索页状态保持原地切换：

- 空态、搜索态、解析中、详情态继续由 `SearchScreen` 管理。
- 详情态隐藏搜索输入栏，给 B 站式详情页更多垂直空间。
- 返回详情时只 reset parse state，不清空 `_searchResults`、`_currentKeyword`、`_currentPage`。

### 4.3 UI 与交互

`VideoDetailView` 重构为同文件私有组件组合：

- 顶部媒体区
  - 使用 `MediaCover` 展示 16:9 封面。
  - 中央播放按钮触发当前音频播放逻辑。
  - 左上角返回搜索结果。
  - 右下角显示视频总时长。
- Tab 区
  - `简介`
  - `评论 {count}`
- 简介 Tab
  - UP 主行：头像、昵称、可选 UID / 分区信息。
  - 标题区：默认最多 2 行，支持展开。
  - 统计行：播放、弹幕、发布时间、评论数、BV 号。
  - 授权提示：`rights.noReprint` 为真时展示禁止转载提示。
  - 简介文本：默认折叠，支持展开。
  - 标签区：使用 chips 展示 `VideoTag`。
  - B 站互动行：点赞、投币、收藏、分享。
  - BuSic 操作区：播放、添加到歌单、下载。
  - 分 P 区：多 P 时展示全选、已选数量和分 P 列表。
- 评论 Tab
  - 直接嵌入 `CommentSection(bvid: videoInfo.bvid)`。
  - 保持热门 / 最新、回复、评论输入和评论点赞能力。

布局约束：

- 使用 `context.appPalette`、`context.appSpacing`、`context.appRadii`、`context.appDepth`。
- 页面结构允许模仿 B 站，但不引入独立硬编码主题。
- 桌面宽度下可让媒体区和简介区更宽；移动宽度下保持单列滚动。

## 5. 边界与失败模式

- 未登录：点赞、投币、收藏、评论发送等动作统一提示 `pleaseLoginFirst`，不发写接口。
- Cookie 失效：Repository 抛出业务异常；Notifier 暴露错误；UI 用 SnackBar 展示。
- 网络失败：详情基础信息失败沿用 parse error；标签和互动状态失败不阻塞详情页主内容。
- 互动失败：乐观更新必须回滚，计数不能永久偏移。
- 投币：需要二次确认，支持 1 枚 / 2 枚和“同时点赞”选项。
- 收藏：复用已有 B 站收藏夹获取能力；收藏夹为空或拉取失败时给出明确提示。
- 分享：记录分享失败不影响复制链接；复制链接失败时单独提示。

## 6. 实施步骤

1. 数据模型阶段
   - 扩展 `BvidInfo`。
   - 新增 `VideoStats`、`VideoRights`、`VideoTag`、`VideoInteractionState`。
   - 更新 `ParseRepository` 和测试 fake / mock。
2. 数据层阶段
   - 更新 `ParseRepositoryImpl.getVideoInfo` 字段映射。
   - 新增标签读取方法。
   - 新增视频互动 repository。
3. 状态层阶段
   - 新增 `VideoInteractionNotifier`。
   - 接入登录态、错误态、乐观更新和回滚。
4. UI 阶段
   - 重构 `VideoDetailView` 为 B 站式详情结构。
   - 调整 `SearchScreen` 详情态隐藏输入栏。
   - 保持播放、下载、加入歌单、多 P 选择原行为。
5. 文案与测试阶段
   - 补 ARB 文案。
   - 补 Widget / Notifier / Repository 测试。
   - 跑 codegen、l10n、analyze、test。

## 7. 验证计划

- 自动化验证
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter gen-l10n`
  - `flutter analyze --no-fatal-infos`
  - `flutter test`
- Widget 场景
  - 点击搜索结果进入详情态。
  - 详情态隐藏搜索输入栏。
  - 返回后恢复搜索结果。
  - `简介 / 评论` Tab 可切换。
  - 多 P 视频展示分 P 选择。
- Notifier 场景
  - 未登录阻止点赞、投币、收藏。
  - 点赞成功更新状态，失败回滚。
  - 投币成功更新投币数；同时点赞时同步点赞态。
  - 收藏夹添加成功后刷新收藏态。
- 手测场景
  - 未登录、登录正常、Cookie 失效三种状态。
  - 单 P / 多 P 视频。
  - 标签接口失败但详情主体可展示。
  - 评论加载、排序、回复、点赞。

## 8. 文档落地计划

功能完成后，把稳定结论提炼到：

- `docs/10-project/bilibili-integration.md`
  - 视频互动接口、登录态失败模式、收藏 / 投币 / 分享注意事项。
- `docs/30-reference/ui.md`
  - 搜索详情页最终 UI 结构和响应式规则。
- `docs/30-reference/state-management.md`
  - 如果互动状态形成可复用模式，再补 Notifier 约束。

本计划落地或冻结后，移入 `docs/90-archive/feature-plans/`，并在归档 README 中补索引。
