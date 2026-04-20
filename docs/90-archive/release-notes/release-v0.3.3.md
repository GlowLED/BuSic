# V0.3.3 发布操作清单

> 使用发布 CLI 一键完成全部流程，参考 [dev-workflow.md 第 8 节](dev-workflow.md#8-版本号与发布)。

## 一键发布（推荐）

```powershell
python3 scripts/release.py
```

CLI 将引导你完成以下步骤：

1. **前置检查** — 验证 Git 分支与工作区状态
2. **设置版本号** — 输入 `0.3.3`，自动更新 `pubspec.yaml` 为 `0.3.3+9`
3. **静态分析** — 自动运行 `flutter analyze`
4. **本地构建** — 自动构建 Android APK + Windows ZIP
5. **蓝奏云发布** — 提示你手动上传后录入链接（可选，可跳过）
6. **更新 manifest** — 自动写入 `versions-manifest.json`
7. **Git 推送** — 自动 commit + tag `v0.3.3` + push，触发 CI/CD

## 完成确认清单

- [ ] `pubspec.yaml` version = `0.3.3+9`
- [ ] `versions-manifest.json` 已含 0.3.3 条目且 `latest` = `0.3.3`
- [ ] Git tag `v0.3.3` 已推送
- [ ] GitHub Actions CI + Release 均通过
- [ ] GitHub Releases 包含全平台产物
- [ ] （可选）蓝奏云已上传 Android APK + Windows ZIP
- [ ] （可选）manifest 已更新蓝奏云链接
