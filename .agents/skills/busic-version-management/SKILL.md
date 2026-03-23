---
name: busic-version-management
description: BuSic版本号管理规范。用于管理版本号时参考，包含版本号格式规则、版本文件位置、版本更新时机与版本命名约定
license: MIT
compatibility: opencode
---

## 版本号格式

采用 **SemVer** 格式：`major.minor.patch+build`

```
major.minor.patch+build
  │    │    │    │
  │    │    │    └─ 构建号：CI/CD 自动递增
  │    │    └────── 补丁版本：Bug修复
  │    └────────── 次版本：新增功能（向后兼容）
  └────────────── 主版本：破坏性变更
```

### 版本号说明

| 平台 | 版本格式 | 说明 |
|------|---------|------|
| Pub (Flutter/Dart) | `0.3.7+1` | `+build` 用于包版本排序 |
| Android (versionCode) | 纯数字 | CI/CD 映射为数字（如 `0.3.7+1` → `30701`） |
| 用户可见版本 | `0.3.7` | **不含** `+build` 后缀 |
| Git Tag | `v0.3.7` | **不含** `+build` 后缀 |

**重要**：`+build` 仅用于 Pub 包管理和 CI/CD 内部流转，不对用户显示。

### 示例

| pubspec.yaml | Git Tag | 用户可见 |
|--------------|---------|----------|
| `0.3.7+1` | `v0.3.7` | `0.3.7` |
| `0.4.0+1` | `v0.4.0` | `0.4.0` |
| `1.0.0+1` | `v1.0.0` | `1.0.0` |

## 版本文件位置

### pubspec.yaml

```yaml
# 主版本文件
name: busic
version: 0.3.4+1  # 必须保持最新

# ...其他配置
```

### CHANGELOG.md

```markdown
## [0.3.4] - 2024-01-15

### Features
- 新增歌单导出功能
```

### Git Tag

```
v0.3.4  # 不含build号
```

### versions-manifest.json

```json
{
  "latest": "0.3.6",
  "min_supported": "0.2.0",
  "versions": [
    {
      "version": "0.3.6",
      "build": 12,
      "date": "2026-03-19",
      "changelog": "## Features\n- 新功能...",
      "force_update_below": "0.2.0",
      "assets": {
        "android": { "github": "https://github.com/..." },
        "windows": { "github": "https://github.com/..." },
        "linux": { "github": "https://github.com/..." },
        "macos": { "github": "https://github.com/..." }
      }
    }
  ]
}
```

**重要**：每次发布新版本时，必须更新此文件！

| 字段 | 说明 |
|------|------|
| `latest` | 最新版本号（不含build号） |
| `min_supported` | 最低支持的版本，低于此版本强制更新 |
| `versions[].version` | 版本号（不含build号） |
| `versions[].build` | 构建号 |
| `versions[].date` | 发布日期 YYYY-MM-DD |
| `versions[].changelog` | 更新日志（支持 Markdown） |
| `versions[].assets` | 各平台下载链接 |

## 版本号更新规则

### Major（主版本）

当包含**破坏性变更**时递增：

- 移除或重命名公共API
- 修改API签名
- 改变数据库结构（需迁移）
- 修改配置文件格式

**示例：**
```
0.3.4 → 1.0.0  （破坏性升级）
0.9.0 → 1.0.0  （重大重构）
```

### Minor（次版本）

当**新增功能**且**向后兼容**时递增：

- 新增功能
- 新增API（不影响现有功能）
- 新增数据库表
- 新增配置项

**示例：**
```
0.3.4 → 0.4.0  （新增功能）
0.4.0 → 0.5.0  （新增多个功能）
```

### Patch（补丁版本）

当**修复问题**且**向后兼容**时递增：

- Bug修复
- 性能优化
- 安全更新
- 文档修正

**示例：**
```
0.3.4 → 0.3.5  （修复bug）
0.3.9 → 0.3.10  （多个bug修复）
```

### Build（构建号）

每次**构建时自动递增**：

- CI/CD 构建时自动更新
- 本地构建不更新

## 版本号更新时机

### 发布前必须更新

1. 合并到 main 分支前
2. 创建 Git tag 前
3. 发布 GitHub Release 前

### 更新步骤

```bash
# 1. 修改 pubspec.yaml
# version: 0.4.0+1

# 2. 添加 CHANGELOG 条目
## [0.4.0] - YYYY-MM-DD

# 3. 提交
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): bump version to 0.4.0+1"
```

## 版本命名约定

### 开发版本

| 后缀 | 含义 | 示例 |
|------|------|------|
| 无 | 稳定版 | `0.4.0+1` |
| `-dev` | 开发版 | `0.5.0-dev+1` |
| `-beta` | 测试版 | `0.5.0-beta+1` |
| `-rc` | 候选版 | `0.5.0-rc+1` |

### 特殊版本

| 版本 | 含义 |
|------|------|
| `0.0.1` | 初始开发版本 |
| `0.1.0` | 早期测试版本 |
| `1.0.0` | 正式发布版本 |

## 版本号变更决策

### 判断变更类型

```
是否破坏现有功能？
  ├─ 是 → Major 递增
  └─ 否 → 是否有新功能？
           ├─ 是 → Minor 递增
           └─ 否 → Patch 递增
```

### 示例场景

| 场景 | 变更类型 | 版本变化 |
|------|----------|----------|
| 修复播放崩溃bug | Patch | 0.3.4 → 0.3.5 |
| 新增歌单导出功能 | Minor | 0.3.4 → 0.4.0 |
| 移除旧版播放API | Major | 0.3.4 → 1.0.0 |
| 同时有修复和新功能 | Minor | 0.3.4 → 0.4.0 |

## 自动化版本号

### CI/CD 自动更新

在 CI 配置中自动递增 build 号：

```yaml
# .github/workflows/release.yml
- name: Update build number
  run: |
    VERSION=$(cat pubspec.yaml | grep "version:" | awk '{print $2}')
    BUILD=$((VERSION##*+))
    NEW_BUILD=$((BUILD + 1))
    sed -i "s/+${BUILD}/+${NEW_BUILD}/" pubspec.yaml
```

### 手动更新

仅在发布时手动更新：

```bash
# 更新 patch
sed -i 's/0.3.4+1/0.3.5+1/' pubspec.yaml

# 更新 minor
sed -i 's/0.3.4+1/0.4.0+1/' pubspec.yaml

# 更新 major
sed -i 's/0.3.4+1/1.0.0+1/' pubspec.yaml
```

## 版本兼容矩阵

| 应用版本 | 数据库版本 | 最低系统版本 |
|----------|------------|--------------|
| 0.3.x | 1 | Android 5.0+ |
| 0.4.x | 2 | Android 6.0+ |
| 1.0.x | 3 | Android 8.0+ |

## 检查清单

- [ ] pubspec.yaml 版本号格式正确 (`major.minor.patch+build`)
- [ ] CHANGELOG.md 已添加条目（用户可见版本，不含 `+build`）
- [ ] versions-manifest.json 已更新
- [ ] Git tag 不含 `+build` 后缀（`v0.3.7` 而非 `v0.3.7+1`）
- [ ] 版本递增符合规则

## 相关Skill

| Skill | 用途 |
|---|---|
| [busic-release](../busic-release/SKILL.md) | Release发布流程 |
| [busic-git-commit](../busic-git-commit/SKILL.md) | Git提交规范 |
