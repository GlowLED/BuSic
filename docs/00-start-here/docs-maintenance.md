# Docs Maintenance

本文档说明 `docs/` 目录**本身**如何组织、如何新增文档、如何归档旧文档，以及哪些开发改动必须同步更新文档。

## 1. 目录结构

```text
docs/
├── README.md
├── 00-start-here/
├── 10-project/
├── 20-workflows/
├── 30-reference/
├── 40-feature-plans/
└── 90-archive/
```

### 目录职责

- `README.md`
  - `docs/` 的唯一默认入口
  - 负责导航，不承载过多实现细节

- `00-start-here/`
  - 给冷启动 agent 和新开发者看的入口文档
  - 只放阅读路径、速读包和 docs 维护规范

- `10-project/`
  - BuSic 特有知识
  - 真正难查、非共识、项目定制的运行机制和坑点

- `20-workflows/`
  - 构建、调试、开发、发布流程
  - 回答“怎么做”

- `30-reference/`
  - 相对稳定的参考规范和真源索引
  - 回答“在哪里看”“应该遵守什么”

- `40-feature-plans/`
  - 当前仍在设计或实现中的大型功能规划
  - 新的 feature 设计文档默认放这里

- `90-archive/`
  - 历史设计、旧规划、单次发布记录
  - 不进入默认阅读路径

## 2. 新文档应该放哪里

### 放到 `10-project/` 的内容

满足以下任一条件：

- 外部资料少，属于 BuSic 自己的实现约定
- 模型先验弱，容易误判
- 改某个系统时必须知道的坑点 / 真源 / 联动检查

示例：

- `BiliDio` raw cookie
- 字幕 URL 前缀校验
- `versions-manifest.json` 与 Release 资产耦合
- 极简模式生命周期策略

### 放到 `20-workflows/` 的内容

满足以下特征：

- 目标是指导执行流程，而不是解释系统原理
- 与“构建、调试、开发、发布”直接相关

### 放到 `30-reference/` 的内容

满足以下特征：

- 相对稳定
- 常被主线文档引用
- 更像速查规范，不像专题知识页

### 放到 `40-feature-plans/` 的内容

满足以下特征：

- 功能尚未完成
- 需要记录分阶段实施方案、数据流、边界条件、UI 方案
- 未来完成后应被提炼到主线知识文档，原文再归档

### 放到 `90-archive/` 的内容

满足以下任一条件：

- 文档描述的是旧实现
- 只保留设计背景价值
- 对应一次性发布记录或历史方案
- 已被新的主线知识文档替代

## 3. 文档生命周期

### 主线文档

当前有效、默认可读。要求：

- 结论先行
- 明确真源
- 明确坑点
- 明确联动检查
- 避免长篇历史背景

### 规划文档

还在推动中的设计。要求：

- 放 `40-feature-plans/`
- 说明当前状态
- 记录边界和决策
- 落地后把稳定知识抽到主线文档

### 归档文档

只保留背景，不参与默认导航。要求：

- 文件顶部必须标注“历史设计 / 深度参考 / 非当前真源”
- 指向对应的主线文档
- 不再被 README 或 `docs/README.md` 直接推荐

## 4. 编写原则

BuSic 的 docs 统一遵守以下原则：

- **优先写项目特化内容，不写大段共识性教程**
- **先写当前事实，再写原因**
- **真源优先于叙事**
- **把坑点和失败模式写清楚**
- **把“改动时必须一起看什么”写清楚**
- **中文为主，必要术语保留英文标识**

对主线文档，优先使用这种结构：

1. 当前系统如何工作
2. 真实 source of truth
3. 最常见误区 / 坑点
4. 修改时联动检查什么

## 5. 哪些改动必须同步更新 docs

### 改启动、路由、主结构、平台壳层

至少检查：

- `10-project/project-overview.md`
- `10-project/ui-and-platform-quirks.md`
- `30-reference/source-of-truth.md`

### 改 B站接口、Cookie、WBI、评论、收藏夹

至少检查：

- `10-project/bilibili-integration.md`
- 必要时 `10-project/project-specific-rules.md`

### 改下载缓存、歌曲唯一标识、分享/备份规则

至少检查：

- `10-project/project-specific-rules.md`

### 改歌词、字幕、字幕缓存、前缀校验、重试策略

至少检查：

- `10-project/subtitle-and-lyrics.md`

### 改更新系统、Release 资产、Manifest、蓝奏云

至少检查：

- `10-project/update-system.md`
- `20-workflows/release-workflow.md`
- `30-reference/source-of-truth.md`

### 改构建、调试、发布流程

至少检查：

- `20-workflows/build-guide.md`
- `20-workflows/debug-guide.md`
- `20-workflows/dev-workflow.md`
- `20-workflows/release-workflow.md`

### 改 docs 目录结构本身

必须同步更新：

- `docs/README.md`
- `00-start-here/docs-maintenance.md`
- 需要时更新 `README.md`

## 6. 归档策略

任何旧文档在归档前都要先做两件事：

1. 把仍然有效的结论提炼进主线文档
2. 在归档文档顶部写清楚：
   - 当前状态
   - 对应主线文档
   - 它不再是当前实现真源

不要把仍然在默认阅读路径中的文档直接改成“历史记录”。  
先把入口迁走，再归档。

## 7. README 与 docs 的关系

- 仓库根 `README.md` 只负责把开发/维护相关读者引到 `docs/README.md`
- 项目开发知识不再散落在根 README 中
- `docs/README.md` 负责维护 docs 内部导航

## 8. 对 Agent 的特殊要求

以下文档必须保持高密度、低铺垫：

- `00-start-here/agent-quickstart.md`
- `10-project/project-specific-rules.md`
- `30-reference/source-of-truth.md`

这些文档不应被写成教学型长文，否则会降低冷启动效率。
