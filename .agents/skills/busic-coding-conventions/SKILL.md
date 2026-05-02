---
name: busic-coding-conventions
description: BuSic代码编码规范。用于确认命名、文件结构、导入方式、日志、错误处理和常见风格约定
license: MIT
compatibility: opencode
---

## 何时使用

- 开始写 Dart / Flutter 代码前，想快速确认项目内的命名和风格
- 需要判断导入方式、类名、文件名、日志和错误处理写法
- 做 review 时想确认某段代码是不是偏离了团队约定

## 先看这些真源

- [`docs/30-reference/coding-conventions.md`](../../../docs/30-reference/coding-conventions.md)
- [`analysis_options.yaml`](../../../analysis_options.yaml)

## 高频规则

- 文件名使用 `snake_case`
- 公开类型使用 PascalCase，Provider 使用 codegen 生成的 `xxxProvider`
- 项目内导入优先相对路径，不使用 `package:busic/...`
- 字符串优先单引号
- 能 `const` 的地方尽量 `const`
- 日志统一使用 `AppLogger`，不要直接 `print`

## 结构与可读性

- 一个文件只保留一个主要公开类型
- Widget 参数里 `child` / `children` 放后面
- 注释优先解释“为什么”，不要重复代码在做什么
- 用户可见文本不要硬编码，交给 i18n；具体规则见 [`busic-ui-development`](../busic-ui-development/SKILL.md)
- 主题 token 使用 `context.appPalette` / `context.appSpacing` / `context.appRadii` / `context.appDepth` 访问，不要硬编码魔法数字圆角、间距、阴影和自定义色值；具体 token 清单见 [`busic-ui-development`](../busic-ui-development/SKILL.md)

## 错误处理

- Data 层捕获具体异常并记录日志，必要时再转换或继续抛出
- Application 层负责把异常转成状态
- Presentation 层负责展示错误，不承担底层异常分流

## 相关 Skill

- [`busic-state-management`](../busic-state-management/SKILL.md)
- [`busic-ui-development`](../busic-ui-development/SKILL.md)
- [`busic-testing`](../busic-testing/SKILL.md)
