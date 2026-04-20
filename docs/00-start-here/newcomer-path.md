# Newcomer Path

本文档面向第一次接手 BuSic 的开发者或维护者。目标不是一次性讲完所有实现细节，而是让你用**最短路径**完成三件事：

1. 把项目跑起来
2. 知道当前实现和真源在哪里
3. 知道改不同类型问题时应该先读什么

如果你是清空上下文的 agent，请优先读 [agent-quickstart.md](./agent-quickstart.md)。

## 1. 第一小时应该做什么

按这个顺序执行：

```bash
flutter pub get
flutter analyze --no-fatal-infos
flutter test
flutter run -d windows
```

如需 Android 调试：

```bash
flutter devices
flutter run -d <device_id>
```

改了下列内容时再补跑生成：

- `@riverpod`
- `@freezed`
- Drift 表 / 迁移
- `lib/l10n/*.arb`

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## 2. 先建立正确心智模型

BuSic 当前真实状态：

- 数据库是 **Drift**
- 后台播放是 `media_kit + audio_service`
- 更新系统主真源是 `versions-manifest.json`
- 主导航壳层是 `StatefulShellRoute.indexedStack`
- 桌面端存在托盘和“关闭隐藏到托盘”的行为
- 歌词 / 字幕链路有 B 站特有的不稳定性，不能按普通 REST 心智处理

建议先读：

1. [../10-project/project-overview.md](../10-project/project-overview.md)
2. [../10-project/project-specific-rules.md](../10-project/project-specific-rules.md)
3. [../30-reference/source-of-truth.md](../30-reference/source-of-truth.md)

## 3. 改不同系统时先读什么

### 改 B站登录、Cookie、WBI、评论、收藏夹

先读：

- [../10-project/bilibili-integration.md](../10-project/bilibili-integration.md)

### 改播放、缓存、下载联动、离线优先

先读：

- [../10-project/project-overview.md](../10-project/project-overview.md)
- [../10-project/project-specific-rules.md](../10-project/project-specific-rules.md)

### 改歌词、字幕、重试、缓存

先读：

- [../10-project/subtitle-and-lyrics.md](../10-project/subtitle-and-lyrics.md)

### 改更新检查、Manifest、Release、蓝奏云

先读：

- [../10-project/update-system.md](../10-project/update-system.md)
- [../20-workflows/release-workflow.md](../20-workflows/release-workflow.md)

### 改桌面 / 移动端布局、窗口、托盘、极简模式

先读：

- [../10-project/ui-and-platform-quirks.md](../10-project/ui-and-platform-quirks.md)

## 4. 日常开发路径

默认遵循：

```text
Presentation -> Application -> Data -> Core
```

开发工作流看这里：

- [../20-workflows/dev-workflow.md](../20-workflows/dev-workflow.md)
- [../../CONTRIBUTING.md](../../CONTRIBUTING.md)

需要的参考规范：

- [../30-reference/architecture.md](../30-reference/architecture.md)
- [../30-reference/coding-conventions.md](../30-reference/coding-conventions.md)
- [../30-reference/data-layer.md](../30-reference/data-layer.md)
- [../30-reference/state-management.md](../30-reference/state-management.md)
- [../30-reference/ui.md](../30-reference/ui.md)

## 5. 构建、调试、发布

- 构建环境： [../20-workflows/build-guide.md](../20-workflows/build-guide.md)
- 调试方式： [../20-workflows/debug-guide.md](../20-workflows/debug-guide.md)
- 发布流程： [../20-workflows/release-workflow.md](../20-workflows/release-workflow.md)

## 6. 历史文档怎么处理

不要把以下目录当作当前实现真源：

- [../90-archive/historical-design/](../90-archive/historical-design/)
- [../90-archive/feature-plans/](../90-archive/feature-plans/)
- [../90-archive/release-notes/](../90-archive/release-notes/)

它们只适合查背景，不适合直接指导新开发。
