# Release Workflow

这份文档只关心 **BuSic 当前真实发布链路**。

## 1. 发布真源

发布相关的真源文件是：

- `pubspec.yaml`
- `versions-manifest.json`
- `CHANGELOG.md`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`

## 2. 本地发布前最低检查

```bash
flutter analyze --no-fatal-infos
flutter test
```

如果执行者是运行在沙箱中的 agent，请预期 `flutter ...`、`dart run ...` 和远程/写入型 Git 往往需要提权到沙箱外；本地只读 Git（如 `git status`、`git log`、`git diff`）通常可先在沙箱内尝试。统一分类见 [../00-start-here/agent-quickstart.md](../00-start-here/agent-quickstart.md)。

如果改了 codegen 相关内容：

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 3. 当前推荐发布路径

优先使用：

```bash
python3 scripts/release.py
```

这个 CLI 会引导你完成版本设置、构建、manifest 更新、提交、打 tag 和推送。

## 4. 当前 CI / Release 关系

- `CI`
  - 在 `main` push、`main` PR、`v*` tag 时运行
  - 步骤固定：
    - `flutter pub get`
    - `build_runner`
    - `flutter analyze --no-fatal-infos`
    - `flutter test`

- `Release`
  - 在 `v*` tag 或手动触发时运行
  - 会等待当前提交的 CI 成功
  - 会构建并上传多平台产物

## 5. 当前资产命名

应用内更新逻辑依赖这些固定名字：

- `busic-android.apk`
- `busic-windows-x64.zip`
- `busic-linux-x64.deb` / `busic-linux-x64.rpm` / `busic-linux-x64.AppImage`
- `busic-macos.zip`
- `busic-ios-unsigned.ipa`

若改资产名，必须同步检查：

- `versions-manifest.json`
- `app_update` feature
- Release workflow

## 6. `versions-manifest.json` 维护规则

发布不只是打 tag。还必须确认：

- 新版本条目存在
- `latest` 指向新版本
- 各平台下载地址可用
- 如有蓝奏云渠道，相关链接和提取码已维护

## 7. 蓝奏云规则

- 蓝奏云不是全自动上传链路的一部分
- 需要人工补链或额外脚本维护
- 客户端下载体验依赖 manifest 中的蓝奏云条目是否存在

## 8. 最常见发布失误

- 只改了 `pubspec.yaml`，没改 `versions-manifest.json`
- 改了 Release 资产名，但忘了更新应用内更新逻辑
- 打 tag 前没跑 analyze / test
- 蓝奏云链接没补
- 只看 GitHub Releases 页面，没检查 manifest

## 9. 继续深入

- 开发流程总览： [dev-workflow.md](./dev-workflow.md)
- 更新系统细节： [../10-project/update-system.md](../10-project/update-system.md)
- 真源索引： [../30-reference/source-of-truth.md](../30-reference/source-of-truth.md)
