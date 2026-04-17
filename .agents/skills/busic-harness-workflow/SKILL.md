---
name: busic-harness-workflow
description: BuSic开发工作流程规范。用于指导功能开发、bug修复、代码重构，包含需求理解、循环细化、实现计划、代码实现、测试验证、用户确认、代码提交的完整流程
license: MIT
compatibility: opencode
---

## 概述

本 workflow 定义了 BuSic 项目的标准化开发工作流程。从需求理解开始，经过循环细化、实现、测试、确认满意后提交代码。

## 流程图

```
1. 理解用户需求
       ↓
2. 循环细化需求 ◄─────────────────┐
   (触发条件见下方)                  │
   - 细化维度：功能边界、技术实现、兼容性影响    │
   - 循环次数：无限制，直到完成 ────────────────┘
       ↓
3. 编写实现计划
       ↓
4. 询问用户确认实现计划
       ↓
5. 实现代码
       ↓
6. 运行测试（flutter analyze + flutter test）
       ↓
7. 询问用户是否满意
       ↓
8. 提交代码（用户确认满意后）
   - 更新 CHANGELOG
   - 更新相关 Skills 文档
```

## 详细步骤

### 1. 理解用户需求

- 仔细阅读用户的需求描述
- 明确需求的背景和目的
- 确定需求归属的模块（参考 busic-architecture）
- 识别关键技术点

### 2. 循环细化需求

#### 触发条件

以下情况发生时，需要回退到本阶段进一步细化需求：

| 触发条件 | 说明 |
|---|---|
| 需求模糊/不完整 | 用户描述不清晰或缺少关键信息 |
| 实现与预期不符 | 代码实现后发现与用户预期有偏差 |
| 测试失败 | 测试未通过且无法通过简单修复解决 |

#### 细化维度

细化时需确认以下三个方面：

1. **功能边界**
   - 输入输出明确
   - 适用范围定义
   - 限制条件说明

2. **技术实现**
   - 技术栈选择
   - API 设计确认
   - 数据结构定义

3. **兼容性影响**
   - 对现有功能的影响
   - 对数据结构的影响
   - 对 API 的影响
   - 是否需要迁移

#### 细化方式

使用 AskUserQuestion 工具向用户确认：
- 需求的具体范围和边界
- 技术选型的偏好
- 兼容性要求
- 预期结果

### 3. 编写实现计划

实现计划必须包含以下内容：

#### 3.1 文件路径和代码变更

```
修改的文件:
- lib/features/xxx/application/xxx_notifier.dart
- lib/features/xxx/data/xxx_repository.dart

新增的文件:
- lib/features/xxx/domain/models/xxx.dart

删除的文件:
- (如无删除则略过)
```

#### 3.2 步骤分解

```
步骤 1: [具体操作]
  - 子任务 1
  - 子任务 2
  验证方式: [如何验证完成]

步骤 2: [具体操作]
  - 子任务 1
  - 子任务 2
  验证方式: [如何验证完成]
```

#### 3.3 风险评估和替代方案

```
风险 1: [风险描述]
  影响: [影响范围]
  替代方案: [如果失败如何处理]

风险 2: [风险描述]
  影响: [影响范围]
  替代方案: [如果失败如何处理]
```

### 4. 询问用户确认实现计划

在执行实现前，必须使用 ExitPlanMode 或 AskUserQuestion 确认计划：
- 计划是否符合用户预期
- 是否有遗漏或错误
- 是否需要调整

### 5. 实现代码

按照确认后的计划执行：
- 参考 busic-coding-conventions 进行编码
- 参考 busic-state-management 进行状态管理
- 参考 busic-database 进行数据层开发
- 参考 busic-ui-development 进行 UI 开发

### 6. 运行测试

必须验证：

```bash
# 1. 静态分析
flutter analyze --no-fatal-infos

# 2. 所有测试
flutter test

# 3. 如有相关测试文件
flutter test test/features/xxx/data/xxx_test.dart
```

### 7. 询问用户是否满意

展示：
- 完成的功能
- 测试结果
- 任何需要注意的变更

使用 AskUserQuestion 确认用户满意度。

### 8. 提交代码

用户确认满意后执行：

#### 8.1 代码提交

```bash
git add .
git commit -m "$(cat <<'EOF'
<type>(<scope>): <subject>

[optional body]
EOF
)"
```

参考 busic-git-commit 获取提交格式规范。

#### 8.2 文档更新

**CHANGELOG.md**
```markdown
## [x.y.z] - YYYY-MM-DD

### Features
- 新功能描述 (#PR号)

### Bug Fixes
- 修复描述 (#PR号)
```

参考 busic-release 获取详细规范。

**Skills 文档**
如代码变更影响架构、编码规范、数据库、状态管理、UI 等方面，需同步更新相应 Skill：
- busic-architecture
- busic-coding-conventions
- busic-database
- busic-state-management
- busic-ui-development
- busic-testing

参考 busic-skills-maintenance 获取更新规范。

## 不符处理策略

### 小问题（优先修复）

以下情况优先修复而非回退：
- 简单的逻辑错误
- 拼写错误
- 小的 UI 偏差
- 单个测试用例失败

### 大问题（回退需求）

以下情况回退到需求细化阶段：
- 架构层面的设计问题
- 需要大幅重构
- 影响核心功能
- 跨多模块的复杂变更

## 配置持久化

工作流程配置存储在 `.claude/settings.json` 中。

## 相关 Skills

| Skill | 用途 |
|---|---|
| [busic-main-workflow](./busic-main-workflow/SKILL.md) | 主开发流程 |
| [busic-architecture](./busic-architecture/SKILL.md) | 架构规范 |
| [busic-coding-conventions](./busic-coding-conventions/SKILL.md) | 编码规范 |
| [busic-database](./busic-database/SKILL.md) | 数据库规范 |
| [busic-state-management](./busic-state-management/SKILL.md) | 状态管理 |
| [busic-ui-development](./busic-ui-development/SKILL.md) | UI 开发 |
| [busic-testing](./busic-testing/SKILL.md) | 测试规范 |
| [busic-git-commit](./busic-git-commit/SKILL.md) | Git 提交 |
| [busic-release](./busic-release/SKILL.md) | Release 流程 |
| [busic-skills-maintenance](./busic-skills-maintenance/SKILL.md) | Skills 维护 |
