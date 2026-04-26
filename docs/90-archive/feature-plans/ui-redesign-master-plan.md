# UI 重构主计划（Agent 执行版）

> 当前状态：已完成并归档，不再作为活跃任务入口。
> 当前真源：优先阅读 [`../../30-reference/ui.md`](../../30-reference/ui.md)、[`../../10-project/project-overview.md`](../../10-project/project-overview.md)、[`../../10-project/ui-and-platform-quirks.md`](../../10-project/ui-and-platform-quirks.md)。
> 本文仅保留 UI 重构的执行拆分、验收记录和设计演进背景。

这份文档曾是 BuSic UI 重构总计划。它不是灵感稿，也不是泛泛的设计建议，而是给 **冷启动 agent** 直接执行的任务编排文档。

执行期间每个子任务默认由一个独立 agent 负责。该 agent 在开始工作前，必须先阅读本文档和指定入口文档，不得重新拆分任务边界，也不得自行修改整体方向。

## 1. 背景与目标

当前 UI 的主要问题不是功能缺失，而是 **视觉语言过于接近 Flutter 默认 Material 3**：

- 主题层主要是 `ColorScheme.fromSeed` 换肤
- 页面骨架大量采用 `Scaffold + AppBar + ListView/GridView + FAB`
- 导航、列表项、卡片、设置项强依赖默认 Material 组件造型
- 全屏播放器和极简模式已有一定氛围，但没有被提升为全局设计语言

本计划的目标是把 BuSic 重构成一套明确的 **音乐播放器感** UI：

- 双端统一设计语言
- 以封面、光影、层次为主视觉
- 允许重构页面骨架
- 不只是“换皮”，而是系统性去预制感

## 2. 已冻结的设计决策

以下决策已经确定，后续 agent 不再重新讨论：

- 设计方向：**音乐播放器感**
- 改造力度：**全面重构**
- 平台策略：**双端统一设计语言**
- 视觉主轴：**封面与光影**
- 主题策略：**深浅同权**
- 页面策略：**允许重构布局**
- 任务组织：**严格串行**
- 验收方式：**视觉目标 + 功能回归双验收**

### 2.1 全局不变项

以下内容默认不改：

- 路由语义和页面职责
- Provider / Notifier / Repository 的业务职责
- 数据模型、导入导出协议、更新协议
- B 站接口行为、下载缓存规则、字幕逻辑、分享备份规则

如果某个 UI 重构任务发现现有业务层不足以支撑视觉改造，只能在任务文档允许范围内做 **最小必要调整**，不得把任务扩展成业务重构。

### 2.2 全局视觉原则

所有后续任务都必须遵守：

1. 不再让默认 `NavigationRail`、`NavigationBar`、`ListTile`、`Card` 成为主视觉主角。
2. 不再只靠 seed color 表达风格，必须建立自己的 surface、层级、排版和状态语言。
3. “音乐内容”必须成为视觉焦点，尤其是封面、当前播放、列表媒体项、播放器页。
4. 双端只允许布局差异，不允许设计语言分裂成两套。
5. 后续任务只能复用或扩展前序任务产出的 token / 基础组件，不得另起一套视觉规则。

## 3. 总体实施顺序

严格按以下顺序执行。后一个任务默认依赖前一个任务交付物：

1. Task 01: 设计系统与主题层重构（已完成）
2. Task 02: 主导航壳层重构（已完成）
3. Task 03: 通用媒体组件重构（已完成）
4. Task 04: 全屏播放器切换交互收口（已完成）
5. Task 05: 首页与搜索页重构（已完成）
6. Task 06: 设置页与全局收口（已完成）

不允许跳步。原因：

- Task 01 先固定 token 和排版，避免后续页面各自做样式判断
- Task 02 先打掉最强模板感的壳层
- Task 03 先提供页面共用的媒体组件积木
- Task 04-06 再逐页落地，避免边做边返工底层风格

### 3.1 执行状态

- Task 01: 已完成
- Task 02: 已完成
- Task 03: 已完成（2026-04-21）
- Task 04: 已完成（2026-04-23）
- Task 05: 已完成（2026-04-26）
- Task 06: 已完成（2026-04-26）

### 3.2 最近完成记录

- 2026-04-21：Task 03 完成并验收通过。
  - 新增共享媒体积木：`AppPanel`、`MediaCover`、`MediaRow`
  - `SongTile`、`PlaylistTile` 去默认 `ListTile` / `Card` 主体结构
  - 搜索结果列表、歌单详情页排序模式、批量选择模式接入统一媒体样式
  - 文档已同步到 `docs/30-reference/ui.md`
- 2026-04-21：Task 03 后续维护收口。
  - 修复 `AppPanel` 与壳层面板在圆角高亮边框下的裁切缺口问题
  - 在 `docs/30-reference/ui.md` 中补充共享面板的圆角边框实现约束
- 2026-04-23：Task 04 按新需求完成收口。
  - 保留全屏播放器现有沉浸式外观风格
  - PC 宽屏右侧内容区新增 `信息 / 歌词 / 评论` 分段切换入口
  - 原 PageView 滑动切换、移动端竖屏交互、播放控制和极简模式生命周期策略保持不变
  - 文档已同步到 `docs/10-project/ui-and-platform-quirks.md`
- 2026-04-26：Task 05 完成并验收通过。
  - 首页改为紧凑资料库标题行、单一加号入口和歌单分区，不再依赖 `Grid + FAB` 作为主视觉
  - 搜索页改为紧凑 command surface，空态、搜索结果态、解析详情态和错误态层次更明确
  - 解析详情、分 P 选择和评论入口接入 `AppPanel` / `MediaCover` 视觉语言
  - 文档已同步到 `docs/30-reference/ui.md` 和 `docs/10-project/project-overview.md`
- 2026-04-26：Task 06 完成并验收通过，UI 重构主线收口。
  - 设置页改为控制台式分区页面，移除顶层 `ListTile + Divider` 结构
  - 新增设置页私有面板积木，收口外观、语言、播放、存储、账号、数据管理和关于区
  - 首页、搜索页、设置页新增文案已完成 i18n 和生成文件同步
  - `flutter analyze --no-fatal-infos` 与 `flutter test` 已通过

## 4. 子任务清单

---

## Task 01: 设计系统与主题层重构（已完成）

### 目标

把当前 `AppTheme` 从“seed color 配置器”升级为完整设计系统入口，建立后续所有页面共用的视觉 token。

### 依赖

- 无，首任务

### 必读入口

- `docs/00-start-here/agent-quickstart.md`
- `docs/10-project/project-overview.md`
- `docs/10-project/project-specific-rules.md`
- `docs/30-reference/ui.md`
- `lib/core/theme/app_theme.dart`

### Source of Truth

- `lib/core/theme/app_theme.dart`
- `lib/app.dart`
- `lib/shared/extensions/context_extensions.dart`

### 允许修改范围

- `lib/core/theme/`
- 必要时补充 `lib/shared/extensions/` 中与主题读取相关的 UI 扩展
- 仅限主题 token 暴露所需的少量 `lib/app.dart` 接入

### 禁止修改范围

- 任何 feature 的 data / application / domain
- 路由定义
- 业务模型

### 必做产出

- 建立明确的颜色层级：
  - 主背景
  - 次背景
  - 浮层
  - 强调层
  - 弱边框
  - 强文字 / 弱文字
  - 成功 / 危险 / 警告状态
- 建立统一圆角体系
- 建立统一 spacing 体系
- 建立统一阴影 / 描边 / overlay 体系
- 重做 `TextTheme`，拉开标题层级差
- 给后续页面提供稳定的主题读取方式

### 完成标准

- Theme 层本身已经能表达 BuSic 的视觉方向，而不是默认 Material 3
- 深色和浅色都成立
- 后续任务无需再自己发明新的 token 命名体系

### 回归检查

- `flutter analyze --no-fatal-infos`
- App 启动不受影响
- 现有主题切换和语言切换不回归

### 文档回写

- 如 token 命名或主题读取方式明显变化，更新 `docs/30-reference/ui.md`

---

## Task 02: 主导航壳层重构（已完成）

### 目标

重做全局导航壳层，让桌面与移动端都摆脱默认 `NavigationRail` / `NavigationBar` 模板感。

### 依赖

- 依赖 Task 01 的 token 和排版

### 必读入口

- `docs/00-start-here/agent-quickstart.md`
- `docs/10-project/ui-and-platform-quirks.md`
- `docs/30-reference/architecture.md`
- `lib/shared/widgets/responsive_scaffold.dart`

### Source of Truth

- `lib/shared/widgets/responsive_scaffold.dart`
- `lib/core/router/app_router.dart`
- `lib/core/window/window_service.dart`
- `lib/core/window/tray_service.dart`

### 允许修改范围

- `lib/shared/widgets/responsive_scaffold.dart`
- 必要的壳层级共享 UI 组件
- 与壳层样式直接相关的少量 theme token 扩展

### 禁止修改范围

- 路由结构和路径
- 窗口/托盘业务行为
- 页面内容本身

### 必做产出

- 桌面端自定义音乐控制台式边栏
- 标题栏与侧栏视觉统一
- 移动端自定义底部导航外观
- 双端统一激活态、标签和图标语言
- 壳层与页面内容间的层次关系更明确

### 完成标准

- 主壳层不再一眼看出默认 Flutter 导航组件
- 双端虽然布局不同，但视觉属于同一系统
- 桌面端拖拽、最小化、隐藏到托盘行为保持不变

### 回归检查

- `flutter analyze --no-fatal-infos`
- 手测桌面端导航切换、标题栏拖拽、关闭隐藏到托盘
- 手测移动端底部导航切换

### 文档回写

- 如壳层结构和平台视觉规则明显变化，更新 `docs/10-project/ui-and-platform-quirks.md`

---

## Task 03: 通用媒体组件重构（已完成）

### 目标

重做通用媒体类组件，为后续页面提供统一积木，先解决列表项和卡片的“默认 Material”观感。

### 依赖

- 依赖 Task 01 和 Task 02

### 必读入口

- `docs/00-start-here/agent-quickstart.md`
- `docs/30-reference/ui.md`
- `lib/shared/widgets/song_tile.dart`
- `lib/features/playlist/presentation/widgets/playlist_tile.dart`

### Source of Truth

- `lib/shared/widgets/song_tile.dart`
- `lib/features/playlist/presentation/widgets/playlist_tile.dart`
- 当前所有调用这些组件的 presentation 页面

### 允许修改范围

- `lib/shared/widgets/song_tile.dart`
- `lib/features/playlist/presentation/widgets/playlist_tile.dart`
- 与之直接相关的共享展示组件
- 必要的 theme token 和 UI extension

### 禁止修改范围

- 歌曲/歌单业务逻辑
- Repository / Notifier
- 导入导出和播放逻辑

### 必做产出

- `SongTile` 去除默认 `ListTile` 主体结构
- `PlaylistTile` 去除默认 `Card` 主体结构
- 统一媒体封面、标题、元信息、状态标签、操作按钮的层次
- 明确 hover / selected / playing / disabled 状态视觉
- 如果需要，抽出统一的面板、按钮、section header 基础样式

### 完成标准

- 首页、歌单详情、搜索结果等媒体内容在视觉上属于同一系统
- 即使页面还未完全重构，媒体项本身已经明显去模板化

### 回归检查

- `flutter analyze --no-fatal-infos`
- 手测歌曲点击、更多菜单、收藏按钮、当前播放态
- 手测歌单项点击和封面加载失败兜底

### 文档回写

- 如通用 UI 约束明显变化，更新 `docs/30-reference/ui.md`

### 完成记录

- 已新增共享媒体基础组件：`AppPanel`、`MediaCover`、`MediaRow`
- 已重做 `SongTile` 与 `PlaylistTile` 的视觉骨架和状态语义
- 已将搜索结果、歌单详情页排序态、批量选择态纳入同一媒体组件系统
- 已补充对应 i18n、widget tests 与 `docs/30-reference/ui.md`
- 已修复共享面板与壳层面板在圆角高亮边框下的裁切缺口，并把实现约束回写到文档

---

## Task 04: 全屏播放器切换交互收口

### 目标

在尽量保持当前全屏播放页外观风格的前提下，补强 PC 宽屏下歌词 / 评论区的显式切换入口。

本任务不再要求重做全屏播放器视觉主线，也不再主动统一极简模式与播放器的视觉语义。现有全屏播放器的大封面、背景模糊、白色信息文字与控制区氛围应基本保留。

### 依赖

- 依赖 Task 01-03

### 必读入口

- `docs/00-start-here/agent-quickstart.md`
- `docs/10-project/project-overview.md`
- `docs/10-project/ui-and-platform-quirks.md`
- `lib/features/player/presentation/full_player_screen.dart`
- `lib/features/minimal/presentation/minimal_screen.dart`

### Source of Truth

- `lib/features/player/presentation/full_player_screen.dart`
- `lib/features/player/presentation/widgets/`
- `lib/features/minimal/presentation/minimal_screen.dart`（仅回归关注）
- `lib/features/minimal/presentation/widgets/`（仅回归关注）

### 允许修改范围

- `lib/features/player/presentation/`
- 必要的播放器 presentation widgets
- 必要的 i18n 文案
- 与本任务直接相关的 docs 回写

### 禁止修改范围

- 播放器业务控制逻辑
- 极简模式生命周期策略
- 评论、字幕、下载等 feature 的业务行为

### 必做产出

- PC 宽屏全屏播放器右侧内容区提供显式 `信息 / 歌词 / 评论` 分段切换入口
- 分段入口点击后切换现有右侧 PageView 页面，并保留原滑动切换能力
- 移动端 / 竖屏全屏播放器交互保持现状
- 切换入口视觉应贴近当前全屏播放器风格，避免引入一套新的播放器视觉语言

### 完成标准

- PC 宽屏全屏播放器能明显、稳定地切换信息、歌词和评论页面
- 全屏播放器当前外观风格基本不变
- 不破坏播放控制、歌词、评论功能入口
- 极简模式进入退出和生命周期策略不回归

### 回归检查

- `flutter analyze --no-fatal-infos`
- 手测 PC 宽屏全屏播放器的信息 / 歌词 / 评论分段切换与原 PageView 滑动切换
- 手测播放、暂停、切歌、歌词页、评论页、极简模式进入退出
- 验证极简模式 `paused/resumed/detached` 相关逻辑不回归

### 文档回写

- 如播放器切换交互或平台 UI 规则明显变化，更新 `docs/10-project/ui-and-platform-quirks.md`

---

## Task 05: 首页与搜索页重构（已完成）

### 目标

重做首页歌单列表和搜索页，去掉最典型的“标准 Scaffold 业务页”观感。

### 依赖

- 依赖 Task 01-04

### 必读入口

- `docs/00-start-here/agent-quickstart.md`
- `docs/10-project/project-overview.md`
- `lib/features/playlist/presentation/playlist_list_screen.dart`
- `lib/features/search_and_parse/presentation/search_screen.dart`

### Source of Truth

- `lib/features/playlist/presentation/playlist_list_screen.dart`
- `lib/features/playlist/presentation/widgets/`
- `lib/features/search_and_parse/presentation/search_screen.dart`
- `lib/features/search_and_parse/presentation/widgets/`

### 允许修改范围

- `lib/features/playlist/presentation/`
- `lib/features/search_and_parse/presentation/`
- 这些页面直接依赖的共享展示组件

### 禁止修改范围

- 歌单管理逻辑
- 搜索 / 解析逻辑
- 分享导入逻辑本身

### 必做产出

- 首页不再是“空背景 + Grid + 两个 FAB”
- 重做为紧凑标题行、操作工具条和歌单分区层次
- 搜索输入区改成 command surface 风格
- 明确区分搜索空态、搜索结果态、解析详情态
- 页面与 Task 03 的媒体组件保持一致

### 完成标准

- 首页和搜索页在第一眼上已经像音乐产品，而不是标准工具页
- 操作路径不变，UI 节奏和层次明显提升

### 回归检查

- `flutter analyze --no-fatal-infos`
- 手测创建歌单、导入歌单、收藏夹导入入口
- 手测搜索、BV 解析、结果点击、详情查看

### 文档回写

- 如页面入口和 UI 交互规则有显著变化，更新 `docs/10-project/project-overview.md`

### 完成记录

- 首页顶部已收口为紧凑标题行和单一加号入口；加号弹窗分流到自定义歌单、剪贴板导入和 B 站收藏夹导入
- 搜索页已改为紧凑 command surface，搜索 / BV 解析、搜索结果、解析详情和错误提示形成统一层次
- 解析详情页已替换默认 `Card` / `CheckboxListTile` 主视觉，分 P 选择、播放、下载、添加歌单和评论展开逻辑保持不变
- 已补充对应 i18n，并通过 `flutter analyze --no-fatal-infos` 与 `flutter test`

---

## Task 06: 设置页与全局收口（已完成）

### 目标

重做设置页，并完成全局视觉一致性收口，确保前五个任务形成单一系统而不是局部漂亮。

### 依赖

- 依赖 Task 01-05

### 必读入口

- `docs/00-start-here/agent-quickstart.md`
- `docs/10-project/project-overview.md`
- `docs/30-reference/ui.md`
- `lib/features/settings/presentation/settings_screen.dart`
- `lib/features/settings/presentation/widgets/`

### Source of Truth

- `lib/features/settings/presentation/settings_screen.dart`
- `lib/features/settings/presentation/widgets/`
- 所有前序任务产出的 theme / shared UI 组件

### 允许修改范围

- `lib/features/settings/presentation/`
- 必要的 shared UI 收口调整
- 必要的 theme token 微调
- 与 UI 重构直接相关的 docs 回写

### 禁止修改范围

- 设置业务存储逻辑
- 主题、语言、播放设置本身的业务语义
- 非 UI 目的的大范围代码清理

### 必做产出

- 设置页从默认 `ListTile + Divider` 结构转成更有分区感的控制台式页面
- 收口前五个任务中遗留的不一致样式
- 固化按钮、输入、面板、媒体项、导航、标题的统一规范
- 完成主计划中的 docs 回写

### 完成标准

- 全局页面在视觉上属于同一系统
- 设置页不再拖累整体产品气质
- 后续新页面有明确可复用的 UI 基础设施

### 回归检查

- `flutter analyze --no-fatal-infos`
- 手测主题切换、语言切换、存储设置、极简模式设置、账号区与关于页
- 做一轮桌面端和移动端主流程冒烟

### 文档回写

- 更新 `docs/30-reference/ui.md`
- 必要时更新 `docs/10-project/project-overview.md`
- 在本文件中补充“执行状态”或完成记录

### 完成记录

- 设置页已改为控制台式页头和面板分区，不再以顶层 `ListTile + Divider` 作为页面骨架
- 新增 `SettingsSectionPanel` 与 `SettingsTile` 作为设置页私有 UI 积木，统一设置项、操作项和更新下载状态的展示
- 外观、语言、播放、存储、账号、数据管理、关于区业务行为保持不变
- 已把稳定规则回写到 `docs/30-reference/ui.md`，并通过 `flutter analyze --no-fatal-infos` 与 `flutter test`

## 5. 全局验收标准

所有任务完成后，整体需要满足：

### 视觉目标

- 桌面端与移动端都明显摆脱默认 Flutter 模板感
- 导航、列表项、播放器、搜索页、设置页属于同一语言
- 深色与浅色都可用，不是一套主一套凑合
- 封面与光影成为识别度来源，而不是随机装饰

### 工程目标

- UI 重构主要集中在 theme / shared widgets / presentation
- 业务逻辑、协议和数据层不发生无关扩散
- 后续新页面可直接复用本次重构产出的基础样式与组件

### 回归目标

- 播放、搜索、解析、下载、分享导入、设置修改、桌面托盘、极简模式均不回归
- `flutter analyze --no-fatal-infos` 保持通过

## 6. 执行规则

每个子任务 agent 都必须遵守：

1. 开始前先读：
   - `docs/00-start-here/agent-quickstart.md`
   - `docs/10-project/project-overview.md`
   - `docs/10-project/project-specific-rules.md`
   - 当前任务列出的专题文档
2. 只在本任务允许范围内改动。
3. 如需扩展 theme token，应优先复用前序任务命名体系。
4. 若发现前序任务交付与本文档冲突，先在本文档补充“阻塞/偏差”说明，再继续。
5. 完成任务后必须同步更新对应 docs，而不是把新知识只留在代码里。

## 7. 任务完成后的文档落地

当整条 UI 重构主线落地后：

- 把稳定结论提炼到：
  - `docs/10-project/`
  - `docs/30-reference/`
- 视情况收缩本文件，保留执行记录或迁入归档
- 若该主线不再活跃，再移入 `docs/90-archive/feature-plans/`
