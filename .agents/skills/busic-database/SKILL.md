---
name: busic-database
description: BuSic数据层规范。用于Drift表定义、迁移、Repository实现和Domain模型映射时快速确认主真源与联动检查项
license: MIT
compatibility: opencode
---

## 何时使用

- 新增或修改 Drift 表
- 调整 `schemaVersion`、迁移逻辑或 Repository 映射
- 想确认 Domain 模型、DB 表和 Repository 的职责边界

## 先看这些真源

- [`docs/30-reference/data-layer.md`](../../../docs/30-reference/data-layer.md)
- [`lib/core/database/app_database.dart`](../../../lib/core/database/app_database.dart)
- [`lib/core/database/tables/`](../../../lib/core/database/tables/)

## 表与迁移 checklist

改表时至少同步检查：

1. 表定义文件
2. `@DriftDatabase(tables: [...])` 注册
3. `schemaVersion`
4. `onUpgrade`
5. `build_runner`

命令：

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Repository 规则

- Repository 接口和实现都放在 `data/` 层
- Domain 模型与 DB 表分离，由 Repository 负责映射
- Repository 不是业务状态容器；业务编排仍在 Notifier
- 需要长期存活的 Repository，再交给手动 Provider 管理

## 常见联动

- 下载链路不要只改任务表，记得回写 `songs.localPath` 与 `songs.audioQuality`
- 分享 / 备份不要把本地路径写进跨设备数据
- 数据库变更后，测试要优先验证真实表状态，而不是只断言中间变量

## 相关 Skill

- [`busic-architecture`](../busic-architecture/SKILL.md)
- [`busic-state-management`](../busic-state-management/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
