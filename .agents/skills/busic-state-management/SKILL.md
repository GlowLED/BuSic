---
name: busic-state-management
description: BuSic状态管理规范。用于Riverpod codegen、Notifier编排、依赖注入和AutoDispose生命周期控制时快速查阅
license: MIT
compatibility: opencode
---

## 何时使用

- 新增或重构 `application/` 层
- 需要决定一个状态应该用 `@riverpod` 还是手动 Provider
- 遇到 `autoDispose`、异步生命周期、跨 feature 依赖相关问题

## 先看这些真源

- [`docs/30-reference/state-management.md`](../../../docs/30-reference/state-management.md)
- [`lib/main.dart`](../../../lib/main.dart)

## Provider 选择

- 业务 Notifier 默认使用 `@riverpod`
- 全局注入、GoRouter、需要长期存活的 Repository 才使用手动 Provider
- Repository 依赖通常在 Notifier `build()` 中创建

## Notifier 高频规则

- 异步初始化用 `Future<T>`，纯运行时状态用同步 `T`
- UI 调用公有方法，业务编排留在 Notifier
- 跨 feature 联动优先通过 Provider 或清晰的依赖注入完成
- 所有会跨异步间隙且还要读写 `state` / `ref` 的方法，优先考虑 `ref.keepAlive()`

## UI 使用规则

- `build()` 里用 `ref.watch(...)`
- 回调和事件里用 `ref.read(...)`
- 需要生命周期时用 `ConsumerStatefulWidget`

## 常见坑

- `autoDispose` provider 在对话框、异步回调、跨帧操作中很容易被提前回收
- `state = ...` 不要写在会抛异常的逻辑外面，避免半更新状态
- 不要让 UI 直接拿 Repository 绕过 Notifier

## 相关 Skill

- [`busic-architecture`](../busic-architecture/SKILL.md)
- [`busic-coding-conventions`](../busic-coding-conventions/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
