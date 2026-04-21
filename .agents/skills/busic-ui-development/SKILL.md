---
name: busic-ui-development
description: BuSic UI开发规范。用于Screen和Widget开发时确认基类选择、响应式壳层、主题token、i18n和桌面平台差异
license: MIT
compatibility: opencode
---

## 何时使用

- 新增 Screen、Widget 或路由接入
- 调整主题、响应式布局、国际化或桌面端壳层
- 需要判断某段 UI 逻辑应写在 Widget、Notifier 还是共享组件里

## 先看这些真源

- [`docs/30-reference/ui.md`](../../../docs/30-reference/ui.md)
- [`docs/10-project/ui-and-platform-quirks.md`](../../../docs/10-project/ui-and-platform-quirks.md)
- [`lib/shared/widgets/responsive_scaffold.dart`](../../../lib/shared/widgets/responsive_scaffold.dart)
- [`lib/core/router/app_router.dart`](../../../lib/core/router/app_router.dart)

## Widget 结构

- 纯展示且读 Provider：优先 `ConsumerWidget`
- 需要生命周期：用 `ConsumerStatefulWidget`
- 纯静态展示：`StatelessWidget`
- 复杂页面里的私有 UI 片段优先抽成同文件私有 Widget
- feature 专属可复用组件放到 `presentation/widgets/`

## 主题与响应式

- 统一通过 `AppTheme` 与 theme extensions 取值
- 业务页面优先使用 `context.appPalette`、`context.appSpacing`、`context.appRadii`、`context.appDepth`
- 不要在页面里堆魔法数字颜色、圆角和阴影
- 主壳层布局优先复用 `ResponsiveScaffold`

## i18n 与交互

- 所有用户可见文本必须进 ARB
- 改了 `lib/l10n/*.arb` 后记得 `flutter gen-l10n`
- 常见弹窗优先复用 `CommonDialogs`
- 路由接入以 `app_router.dart` 为准

## 平台差异提醒

- 桌面端关闭窗口默认是托盘隐藏，不一定等于退出
- `minimal` 模式是独立生命周期策略，不是普通页面皮肤
- 改标题栏、托盘、极简模式时要同时检查桌面壳层逻辑

## 相关 Skill

- [`busic-architecture`](../busic-architecture/SKILL.md)
- [`busic-coding-conventions`](../busic-coding-conventions/SKILL.md)
- [`busic-state-management`](../busic-state-management/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
