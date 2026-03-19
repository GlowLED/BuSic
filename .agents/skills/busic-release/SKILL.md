---
name: busic-release
description: BuSic版本Release发布流程规范。用于发布新版本时参考，包含发布前检查、版本更新、标签创建、构建验证与GitHub Release发布步骤
license: MIT
compatibility: opencode
---

## Release 发布流程

### 流程概览

```
1. 发布前检查
2. 更新版本号
3. 生成更新日志
4. 提交并合并到main
5. 创建Git标签
6. 推送触发CI/CD
7. 创建GitHub Release
```

## 1. 发布前检查

### 代码检查

```bash
# 静态分析（0 issues）
flutter analyze --no-fatal-infos

# 运行所有测试
flutter test

# 检查依赖更新
flutter pub outdated
```

### 分支状态

```bash
# 确保在develop分支且已同步最新代码
git checkout develop
git pull origin develop

# 检查与main分支的差异
git log main..develop --oneline
```

### CHANGELOG 准备

检查 `CHANGELOG.md` 是否包含所有变更：
- 新增功能 (feat)
- Bug修复 (fix)
- 重大变更 (BREAKING CHANGE)
- 依赖更新

## 2. 更新版本号

参考 `busic-version-management` skill

### 步骤

1. 修改 `pubspec.yaml` 中的 `version` 字段
2. 更新 `CHANGELOG.md` 添加版本发布日期
3. 提交版本更新：

```bash
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): bump version to x.y.z+build"
```

## 3. 生成更新日志

### 手动生成

从 git log 提取：

```bash
git log --pretty=format:"- %s (%h)" main..develop
```

### 格式要求

```markdown
## [x.y.z] - YYYY-MM-DD

### Features
- 新功能A (#123)

### Bug Fixes
- 修复播放崩溃问题 (#456)

### Breaking Changes
- 移除旧版API (#789)
```

## 4. 提交并合并到main

### 合并方式

```bash
# 方式1: 直接合并（推荐）
git checkout main
git merge develop --no-ff -m "merge: release x.y.z"

# 方式2: 使用pull request
# 通过GitHub UI创建PR并合并
```

### 推送

```bash
git push origin main
```

## 5. 创建Git标签

### 标签规范

- 标签名：`v<major>.<minor>.<patch>`
- **不含build号**

```bash
git tag -a v0.4.0 -m "Release version 0.4.0"

# 推送标签
git push origin v0.4.0
```

### 注意事项

- 确保标签指向正确的commit（main分支的最新commit）
- 标签一旦推送不可修改

## 6. 触发CI/CD

### 自动触发

推送 `v*` 标签自动触发 CI：

```
推送 v* tag
  └─► CI (ci.yml)
        ├─► flutter analyze
        ├─► flutter test
        └─► Release 构建
              ├─► Windows (.exe)
              ├─► macOS (.app/.dmg)
              ├─► Linux (.deb/.rpm/.AppImage)
              ├─► Android (.apk/.aab)
              └─► iOS (.ipa)
```

### 手动验证

```bash
# 检查CI状态
git log --oneline -1

# 查看GitHub Actions
gh run list --branch main
```

## 7. 创建GitHub Release

### 手动创建

1. 访问 Releases 页面
2. 点击 "Draft a new release"
3. 选择刚推送的标签
4. 填写 Release 内容
5. 发布

### 手动创建命令

```bash
gh release create v0.4.0 \
  --title "Version 0.4.0" \
  --notes-file CHANGELOG.md \
  --latest
```

### 自动创建

CI 构建完成后自动创建 Release（需配置）

## 8. 发布后操作

### 回到开发分支

```bash
git checkout develop
```

### 同步main到develop（可选）

```bash
git merge main
git push origin develop
```

### 通知相关人员

- 发送版本更新通知
- 更新内部分发列表

## 回滚流程

### 场景：发布后发现严重bug

```bash
# 1. 创建回滚标签
git checkout main
git tag -a v0.4.1 -m "Rollback to stable version"

# 2. 修改版本号
# pubspec.yaml: version: 0.4.1+1

# 3. 提交并推送
git add pubspec.yaml
git commit -m "fix: rollback to stable"
git push origin main

# 4. 重新发布
git tag -a v0.4.1
git push origin v0.4.1
```

## 检查清单

- [ ] 运行 `flutter analyze` 无错误
- [ ] 运行 `flutter test` 全部通过
- [ ] 更新 `pubspec.yaml` 版本号
- [ ] 更新 `CHANGELOG.md`
- [ ] 合并到 main 分支
- [ ] 创建并推送 Git 标签
- [ ] CI 构建成功
- [ ] 创建 GitHub Release
- [ ] 切换回 develop 分支

## Linux 打包说明

### 打包格式

| 格式 | 说明 | 适用系统 |
|------|------|----------|
| `.deb` | Debian/Ubuntu 包 | Debian, Ubuntu, Linux Mint |
| `.rpm` | Red Hat/Fedora 包 | Fedora, RHEL, CentOS, openSUSE |
| `.AppImage` | 便携式包 | 任意 Linux 发行版 |

### 打包脚本位置

| 文件 | 说明 |
|------|------|
| `scripts/linux/postinst.sh` | 安装后脚本（创建桌面快捷方式、安装图标） |
| `scripts/linux/prerm.sh` | 卸载前脚本（清理桌面快捷方式、图标） |
| `scripts/appimage/AppDir/` | AppImage 打包目录 |
| `scripts/appimage/AppDir/busic.desktop` | AppImage 桌面入口文件 |

### 安装脚本功能

#### postinst.sh（安装后执行）

- 安装多尺寸图标到系统图标目录
- 创建 `.desktop` 桌面快捷方式
- 创建 `/usr/bin/busic` 符号链接
- 更新桌面数据库

#### prerm.sh（卸载前执行）

- 删除 `.desktop` 桌面快捷方式
- 删除系统图标
- 删除符号链接

### AppImage 特点

- **无需安装**：直接赋予执行权限即可运行
- **便携性强**：可在任意 Linux 发行版使用
- **自包含**：包含所有运行时依赖
- **无需 root 权限**

## 相关Skill

| Skill | 用途 |
|---|---|
| [busic-version-management](../busic-version-management/SKILL.md) | 版本号管理规范 |
| [busic-git-commit](../busic-git-commit/SKILL.md) | Git提交规范 |
