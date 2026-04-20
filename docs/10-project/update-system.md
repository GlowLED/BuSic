# Update System

BuSic 的更新系统不是简单“对比版本号 + 下载 GitHub Asset”。当前实现里有多组项目特化约束。

## 1. 当前真源

更新系统相关真源按优先级分为：

1. `versions-manifest.json`
2. `pubspec.yaml` 中的 `x_update`（fallback）
3. `.github/workflows/release.yml`
4. `lib/features/app_update/*`

## 2. `versions-manifest.json` 的角色

它是当前应用内更新系统的主真源，负责描述：

- 最新版本
- 最低支持版本
- 历史版本列表
- 各平台下载地址
- 多渠道下载信息

不要把它理解成普通 changelog 文件；它是**应用运行时要读取的配置**。

## 3. 检查更新的真实流程

`UpdateRepositoryImpl` 当前逻辑：

1. 获取本地版本
2. 并发获取 `versions-manifest.json`
3. 成功则从 manifest 构建 `UpdateInfo`
4. 失败则 fallback 到 `pubspec.yaml + GitHub Releases API`
5. GitHub 下载链接还会经过代理探测

这意味着：

- 更新检查不是只依赖单个 URL
- manifest 和 fallback 是两条独立链路

## 4. 下载渠道

当前实际支持：

- GitHub
- 蓝奏云（按 manifest 提供）

项目特化点：

- 蓝奏云是手动维护链接，不是自动上传
- GitHub 下载 URL 可能会被代理替换
- 蓝奏云链接解析失败时，预期应允许 fallback 到浏览器或其他渠道

## 5. Release 资产命名耦合

应用内更新逻辑依赖固定资产名：

- Android：`busic-android.apk`
- Windows：`busic-windows-x64.zip`
- Linux：`busic-linux-x64.tar.gz`
- macOS：`busic-macos.zip`

如果 CI 改了资产名而 `app_update` 没同步，应用内更新就会坏。

## 6. 平台安装差异

当前安装逻辑是平台分流的：

- Android：通过平台通道安装 APK
- Windows：解压 ZIP，批处理脚本覆盖当前安装目录后重启
- Linux：解压后覆盖安装目录，若目录只读则抛出手动安装提示
- macOS：替换 `.app`

所以改“更新下载”不等于改“更新安装”，两者是分开的。

## 7. checksum 与代理

当前实现会尝试从 GitHub Release 下载 `checksums.sha256`。  
但如果 checksum 不可用，当前行为是**记录 warning 后跳过阻断式校验**。

因此：

- 不要误以为所有更新路径都严格强校验
- 排查 checksum 问题时，要同时看代理和 Release 文件列表

## 8. 最常见排障点

- `versions-manifest.json` 条目缺失或平台键不对
- GitHub Release 资产名变了
- 蓝奏云链接未维护
- 代理探测拿到的地址异常
- checksum 文件缺失
- Linux 安装目录不可写

## 9. 修改这部分时要一起看什么

- `versions-manifest.json`
- `.github/workflows/release.yml`
- `lib/features/app_update/data/update_repository_impl.dart`
- `lib/features/app_update/data/proxy_prober.dart`
- `lib/features/app_update/data/lanzou_resolver.dart`
- `lib/features/app_update/application/update_notifier.dart`

## 10. 深度背景

历史方案和扩展设计见：

- [../90-archive/feature-plans/app-update.md](../90-archive/feature-plans/app-update.md)
- [../90-archive/feature-plans/update-system-v2.md](../90-archive/feature-plans/update-system-v2.md)
