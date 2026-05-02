# Feature Plans

这里放 **仍在设计中或正在实施中的大型功能规划**。

## 当前活跃主计划

当前无活跃规划。

已完成的规划：
- 搜索结果视频详情页 B 站式重构已归档到 [../90-archive/feature-plans/search-video-detail-bilibili-style.md](../90-archive/feature-plans/search-video-detail-bilibili-style.md)
- UI 重构主计划已归档到 [../90-archive/feature-plans/ui-redesign-master-plan.md](../90-archive/feature-plans/ui-redesign-master-plan.md)

当前 UI 规则优先读 [../30-reference/ui.md](../30-reference/ui.md)、[../10-project/project-overview.md](../10-project/project-overview.md)、[../10-project/ui-and-platform-quirks.md](../10-project/ui-and-platform-quirks.md)。

## 什么时候把文档放这里？

满足以下任一条件时，优先新建规划文档到本目录：

- 涉及多个 feature / 多层联动
- 需要提前锁定数据流、边界条件和迁移策略
- 需要阶段性实施
- 还不能直接写成稳定知识文档

## 规划文档应该包含什么？

- 目标与边界
- 当前现状
- 数据模型 / 数据流
- UI / 状态管理方案
- 风险与失败模式
- 分阶段实施步骤

## 规划落地后怎么做？

规划文档落地后要做两件事：

1. 把稳定结论提炼到主线文档。
   - `10-project/`
   - `20-workflows/`
   - `30-reference/`
2. 原始规划文档移入 `../90-archive/feature-plans/`

换句话说，这里只放 **活跃规划**，不放历史方案。
