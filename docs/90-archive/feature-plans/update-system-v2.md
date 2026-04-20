# 更新系统 V2 — 多渠道下载 + 版本回退 + 后台下载

## 0. 背景与目标

当前更新系统 (`app_update` feature) 已实现：
- 通过 `pubspec.yaml` + GitHub Releases API 检查更新
- GitHub 代理自动探测 + 下载
- 弹窗式下载进度 → 自动安装

**V2 需解决的问题：**

| 痛点 | 目标 |
|------|------|
| 下载只能在弹窗中进行，关闭弹窗即丢失进度 | 后台下载，设置页内嵌进度条 |
| 下载渠道仅有 GitHub（含代理），国内用户体验差 | 增加蓝奏云渠道，用户可选 |
| 无法暂停/恢复下载 | 点击进度条暂停，长按取消 |
| 无法回退到历史版本 | 选择历史版本 + 选择渠道 → 下载安装 |
| 各渠道下载链接无统一数据源 | 仓库维护 `versions-manifest.json` |

---

## 1. 版本清单（Manifest）设计

### 1.1 文件位置与格式

在仓库根目录新增 `versions-manifest.json`，随代码提交。CI 发布时自动追加新版本条目。

```jsonc
{
  "latest": "0.3.2",
  "min_supported": "0.2.0",
  "versions": [
    {
      "version": "0.3.2",
      "build": 8,
      "date": "2026-03-01",
      "changelog": "新增多渠道下载、版本回退功能",
      "force_update_below": "0.2.0",
      "assets": {
        "android": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.2/busic-android.apk",
          "lanzou": {
            "url": "https://wwxx.lanzouq.com/iXXXXXXX",
            "password": "abcd"
          }
        },
        "windows": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.2/busic-windows-x64.zip",
          "lanzou": {
            "url": "https://wwxx.lanzouq.com/iYYYYYYY",
            "password": "efgh"
          }
        },
        "linux": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.2/busic-linux-x64.tar.gz"
        },
        "macos": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.2/busic-macos.zip"
        }
      },
      "checksums": {
        "busic-android.apk": "sha256:xxxxxxxx",
        "busic-windows-x64.zip": "sha256:xxxxxxxx"
      }
    },
    {
      "version": "0.3.1",
      "build": 7,
      "date": "2026-02-15",
      "changelog": "Bug 修复",
      "force_update_below": "0.2.0",
      "assets": {
        "android": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.1/busic-android.apk"
        },
        "windows": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.1/busic-windows-x64.zip"
        },
        "linux": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.1/busic-linux-x64.tar.gz"
        },
        "macos": {
          "github": "https://github.com/GlowLED/BuSic/releases/download/v0.3.1/busic-macos.zip"
        }
      }
    }
  ]
}
```

### 1.2 Manifest 获取策略

| 源 | URL | 说明 |
|---|---|---|
| jsdelivr CDN | `https://cdn.jsdelivr.net/gh/GlowLED/BuSic@main/versions-manifest.json` | 首选，CDN 缓存 |
| gh-proxy | `https://gh-proxy.com/https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json` | 国内代理 |
| ghfast | `https://ghfast.top/https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json` | 国内代理 |
| ghproxy | `https://ghproxy.net/https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json` | 国内代理 |
| raw.githubusercontent | `https://raw.githubusercontent.com/GlowLED/BuSic/main/versions-manifest.json` | 直连兜底 |

沿用现有竞速策略（并发 GET，取首个成功响应），替代原来解析 `pubspec.yaml` 的方式。`pubspec.yaml` 中的 `x_update` 字段保留作为极简 fallback。

### 1.3 与现有 `x_update` 的关系

- **`versions-manifest.json`** 成为新的 single source of truth，包含所有历史版本及多渠道下载链接。
- **`pubspec.yaml` 的 `x_update`** 保留，作为 manifest 不可用时的降级方案（仅能获取最新版本号，无法获取历史版本和多渠道链接）。
- 检查更新时优先读取 manifest；失败后 fallback 到 `pubspec.yaml` + GitHub Releases API（现有逻辑不删除）。

---

## 2. 下载渠道设计

### 2.1 渠道定义

```dart
/// 下载渠道枚举
enum DownloadChannel {
  github,  // GitHub Releases（全平台）
  lanzou,  // 蓝奏云（Android / Windows）
}
```

### 2.2 渠道规则

| 规则 | 说明 |
|------|------|
| APK 下载固定从 github.com | 即使存在代理，APK 的原始 URL 始终为 `https://github.com/...`。用户明确选择 GitHub 渠道时直连 |
| 蓝奏云仅提供 Android + Windows | 蓝奏云文件大小限制 100MB，Linux/macOS 产物通常超限 |
| 元数据获取保持不变 | manifest 获取仍然使用代理竞速，与下载渠道解耦 |
| 蓝奏云渠道需手动维护 | 蓝奏云无 API 自动上传（官方未提供），需脚本辅助 |

### 2.3 蓝奏云集成方案

蓝奏云不提供官方上传 API，常见方案：

1. **半自动脚本**：CI 构建完成后，运维使用 Python 脚本（基于 `lanzou-api` 或浏览器自动化）上传到蓝奏云，获取分享链接后手动填入 `versions-manifest.json`。
2. **页面获取真实下载链接**：蓝奏云分享链接是一个中间页面，需要解析获取真实下载 URL。客户端内置蓝奏云链接解析逻辑（或直接打开浏览器让用户下载）。

**推荐方案：** 客户端直接使用蓝奏云分享页链接，内置轻量级解析器获取直链，然后走统一的 Dio 下载流程。

---

## 3. 数据层改造

### 3.1 新增 Domain 模型

#### `VersionManifest`（Freezed）

```dart
@freezed
class VersionManifest with _$VersionManifest {
  const factory VersionManifest({
    required String latest,
    required String minSupported,
    required List<VersionEntry> versions,
  }) = _VersionManifest;

  factory VersionManifest.fromJson(Map<String, dynamic> json) =>
      _$VersionManifestFromJson(json);
}
```

#### `VersionEntry`（Freezed）

```dart
@freezed
class VersionEntry with _$VersionEntry {
  const factory VersionEntry({
    required String version,
    required int build,
    required String date,
    required String changelog,
    String? forceUpdateBelow,
    required Map<String, PlatformAssets> assets,
    @Default({}) Map<String, String> checksums,
  }) = _VersionEntry;

  factory VersionEntry.fromJson(Map<String, dynamic> json) =>
      _$VersionEntryFromJson(json);
}
```

#### `PlatformAssets`（Freezed）

```dart
@freezed
class PlatformAssets with _$PlatformAssets {
  const factory PlatformAssets({
    String? github,
    LanzouAsset? lanzou,
  }) = _PlatformAssets;

  factory PlatformAssets.fromJson(Map<String, dynamic> json) =>
      _$PlatformAssetsFromJson(json);
}

@freezed
class LanzouAsset with _$LanzouAsset {
  const factory LanzouAsset({
    required String url,
    String? password,
  }) = _LanzouAsset;

  factory LanzouAsset.fromJson(Map<String, dynamic> json) =>
      _$LanzouAssetFromJson(json);
}
```

### 3.2 UpdateState 改造

扩展现有 `UpdateState`，新增暂停状态：

```dart
@freezed
class UpdateState with _$UpdateState {
  const factory UpdateState.idle() = UpdateStateIdle;
  const factory UpdateState.checking() = UpdateStateChecking;
  const factory UpdateState.available(UpdateInfo info) = UpdateStateAvailable;

  /// 下载中（新增 channel 字段 + 已下载字节数）
  const factory UpdateState.downloading({
    required UpdateInfo info,
    required double progress,
    required double speed,
    required DownloadChannel channel,
    @Default(0) int downloadedBytes,
    @Default(0) int totalBytes,
  }) = UpdateStateDownloading;

  /// 已暂停
  const factory UpdateState.paused({
    required UpdateInfo info,
    required double progress,
    required DownloadChannel channel,
    required int downloadedBytes,
    required int totalBytes,
    required String localPath,
  }) = UpdateStatePaused;

  const factory UpdateState.readyToInstall({
    required UpdateInfo info,
    required String localPath,
  }) = UpdateStateReadyToInstall;

  const factory UpdateState.error(String message) = UpdateStateError;
}
```

### 3.3 UpdateInfo 改造

扩展 `UpdateInfo` 以支持多渠道和多版本：

```dart
@freezed
class UpdateInfo with _$UpdateInfo {
  const factory UpdateInfo({
    required AppVersion latestVersion,
    required AppVersion currentVersion,
    required String changelog,
    required bool isForceUpdate,
    required String assetName,
    String? releaseNotesUrl,
    /// 各渠道下载 URL（新增）
    required Map<DownloadChannel, String> downloadUrls,
    /// 蓝奏云密码（如有）
    String? lanzouPassword,
  }) = _UpdateInfo;
}
```

### 3.4 Repository 改造

#### 新增方法

```dart
abstract class UpdateRepository {
  /// 获取版本清单（所有历史版本）
  Future<VersionManifest> fetchManifest();

  /// 检查更新（现有，内部改用 manifest）
  Future<UpdateInfo> checkForUpdate();

  /// 获取指定版本的下载信息（用于版本回退）
  Future<UpdateInfo> getVersionInfo(String version);

  /// 下载更新（支持断点续传）
  Future<String> downloadUpdate({
    required String url,
    required String savePath,
    required void Function(double progress, double speed) onProgress,
    CancelToken? cancelToken,
    int startByte,  // 新增：断点续传起始字节
  });

  /// 解析蓝奏云分享链接获取直链
  Future<String> resolveLanzouUrl(String shareUrl, {String? password});

  Future<void> applyUpdate(String localPath);
}
```

---

## 4. 状态管理层改造

### 4.1 UpdateNotifier 扩展

新增以下方法：

```dart
@riverpod
class UpdateNotifier extends _$UpdateNotifier {
  // ... 现有方法保留 ...

  /// 选择渠道后开始下载（替代原 startDownload）
  Future<void> startDownloadWithChannel(DownloadChannel channel) async { ... }

  /// 暂停下载
  void pauseDownload() { ... }

  /// 恢复下载（断点续传）
  Future<void> resumeDownload() async { ... }

  /// 取消下载
  void cancelDownload() { ... }  // 已有，保留

  /// 获取历史版本列表
  Future<List<VersionEntry>> fetchHistoryVersions() async { ... }

  /// 选择历史版本 + 渠道下载
  Future<void> downloadHistoryVersion(String version, DownloadChannel channel) async { ... }
}
```

### 4.2 新增独立 Provider

```dart
/// 版本清单缓存（全局，非 AutoDispose）
@Riverpod(keepAlive: true)
class ManifestCache extends _$ManifestCache {
  @override
  Future<VersionManifest> build() async {
    final repo = UpdateRepositoryImpl();
    return repo.fetchManifest();
  }
}
```

---

## 5. UI 层改造

### 5.1 设置页 — AboutSection 改造

**现有布局：**
```
📋 关于 BuSic v0.3.2+8
👥 关注我们
🔄 检查更新
[重置按钮]
```

**改造后布局：**
```
📋 关于 BuSic v0.3.2+8
👥 关注我们
🔄 检查更新                           ← 仅检查，不下载
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📥 下载最新版本  [选择渠道 ▼]          ← 点击选择 GitHub / 蓝奏云
   ┌─ 下载中状态 ──────────────────┐
   │ ████████░░░░░ 65%  2.3 MB/s  │  ← 线性进度条，点击暂停
   │ (长按取消)                    │
   └───────────────────────────────┘
   ┌─ 下载完成状态 ────────────────┐
   │ ✅ 已下载 v0.3.2  [安装]     │  ← 一键安装按钮
   └───────────────────────────────┘
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⏪ 回退到历史版本                     ← 点击弹出版本选择 + 渠道选择
[重置按钮]
```

### 5.2 各状态下的 UI 行为

| UpdateState | 设置页显示 | 交互 |
|-------------|-----------|------|
| `idle` | "下载最新版本" + 渠道选择按钮 | 点击弹出渠道选择 BottomSheet |
| `available` | "新版本可用 vX.Y.Z" + 渠道选择按钮 | 同上 |
| `downloading` | 线性进度条 + 百分比 + 速度 | 点击暂停；长按弹窗确认取消 |
| `paused` | 进度条（暂停状态，半透明）+ "已暂停" | 点击恢复；长按取消 |
| `readyToInstall` | "下载完成 ✅" + "安装" 按钮 | 点击安装 |
| `error` | 错误信息 + "重试" 按钮 | 点击重试 |
| `checking` | 加载指示器 | 禁用交互 |

### 5.3 渠道选择 BottomSheet

```
┌──────────────────────────────┐
│  选择下载渠道                │
│                              │
│  🌐 GitHub                  │  ← 始终可用
│     直连下载，速度取决于网络  │
│                              │
│  ☁️ 蓝奏云                  │  ← 仅 manifest 中存在蓝奏云链接时可用
│     国内高速下载              │
│                              │
└──────────────────────────────┘
```

### 5.4 版本回退 UI 流程

```
用户点击 "回退到历史版本"
  → 加载版本清单
  → 展示版本列表（排除当前版本和更高版本）
    ┌──────────────────────────────────────┐
    │  选择目标版本                        │
    │                                      │
    │  v0.3.1  (2026-02-15)  Bug 修复     │
    │  v0.3.0  (2026-02-01)  新增XX功能   │
    │  v0.2.1  (2026-01-15)  性能优化     │
    └──────────────────────────────────────┘
  → 用户选择版本
  → 弹出渠道选择 BottomSheet（同 5.3）
  → 选择渠道后开始下载（进度条显示在设置页）
```

### 5.5 UpdateDialog 改造

保留现有 `UpdateDialog` 用于**被动通知**场景（启动时检测到新版本弹出），但简化其职责：
- 仅展示更新日志和版本信息
- "立即更新" 按钮改为 "前往设置页下载"（跳转到设置页，自动滚动到下载区域）
- 强制更新时仍在弹窗内提供下载（不可关闭弹窗）

---

## 6. Workflow 改造

### 6.1 现有 `release.yml` 改动

在 `publish` job 末尾增加一步：**自动更新 `versions-manifest.json` 并提交回 main 分支**。

```yaml
  # ───────────── 更新版本清单 ──────────────
  update-manifest:
    needs: [check, publish]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: main
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Update versions-manifest.json
        env:
          TAG: ${{ needs.check.outputs.tag }}
        run: |
          python3 scripts/update-manifest.py \
            --tag "$TAG" \
            --manifest versions-manifest.json

      - name: Commit and push manifest
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add versions-manifest.json
          git diff --cached --quiet || \
            git commit -m "chore: update versions-manifest.json for ${{ needs.check.outputs.tag }}"
          git push origin main
```

### 6.2 新增 `upload-lanzou.yml`（手动触发）

蓝奏云无官方 API，使用半自动工作流：维护者手动在 GitHub Actions 中触发，输入蓝奏云链接后自动更新 manifest。

```yaml
name: Update Lanzou Links

on:
  workflow_dispatch:
    inputs:
      version:
        description: '版本号（如 0.3.2）'
        required: true
      android_url:
        description: '蓝奏云 Android APK 链接'
        required: false
      android_password:
        description: '蓝奏云 Android 提取码'
        required: false
      windows_url:
        description: '蓝奏云 Windows ZIP 链接'
        required: false
      windows_password:
        description: '蓝奏云 Windows 提取码'
        required: false

permissions:
  contents: write

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          ref: main

      - name: Update manifest with Lanzou links
        run: |
          python3 scripts/update-lanzou.py \
            --version "${{ github.event.inputs.version }}" \
            --manifest versions-manifest.json \
            --android-url "${{ github.event.inputs.android_url }}" \
            --android-password "${{ github.event.inputs.android_password }}" \
            --windows-url "${{ github.event.inputs.windows_url }}" \
            --windows-password "${{ github.event.inputs.windows_password }}"

      - name: Commit and push
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add versions-manifest.json
          git diff --cached --quiet || \
            git commit -m "chore: add lanzou links for v${{ github.event.inputs.version }}"
          git push origin main
```

---

## 7. 辅助脚本

### 7.1 `scripts/update-manifest.py` — CI 自动更新 manifest

功能：读取 `versions-manifest.json`，根据新 tag 追加版本条目（GitHub 下载链接自动拼接）。

```python
#!/usr/bin/env python3
"""
CI 发布后自动更新 versions-manifest.json。

用法：
  python3 scripts/update-manifest.py --tag v0.3.2 --manifest versions-manifest.json

功能：
  1. 从 pubspec.yaml 读取 version (含 build number)
  2. 从 tag 名提取 semver
  3. 检查 manifest 中是否已存在该版本
  4. 若不存在，自动生成 GitHub 下载链接并追加到 manifest
  5. 更新 latest 字段
"""

import argparse
import json
import re
import sys
from datetime import date
from pathlib import Path

OWNER = 'GlowLED'
REPO = 'BuSic'

PLATFORM_ASSETS = {
    'android': 'busic-android.apk',
    'windows': 'busic-windows-x64.zip',
    'linux': 'busic-linux-x64.tar.gz',
    'macos': 'busic-macos.zip',
}


def parse_pubspec_version(pubspec_path: str) -> tuple[str, int]:
    """从 pubspec.yaml 解析 version 字段，返回 (semver, build)。"""
    content = Path(pubspec_path).read_text(encoding='utf-8')
    match = re.search(r'^version:\s*(\S+)', content, re.MULTILINE)
    if not match:
        sys.exit('ERROR: version not found in pubspec.yaml')
    version_str = match.group(1)
    if '+' in version_str:
        semver, build = version_str.split('+', 1)
        return semver, int(build)
    return version_str, 0


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--tag', required=True, help='Git tag (e.g. v0.3.2)')
    parser.add_argument('--manifest', required=True, help='Path to versions-manifest.json')
    parser.add_argument('--pubspec', default='pubspec.yaml', help='Path to pubspec.yaml')
    args = parser.parse_args()

    tag = args.tag.lstrip('v')
    semver, build = parse_pubspec_version(args.pubspec)

    # 验证 tag 与 pubspec 版本一致
    if tag != semver:
        sys.exit(f'ERROR: tag v{tag} does not match pubspec version {semver}')

    # 读取现有 manifest
    manifest_path = Path(args.manifest)
    if manifest_path.exists():
        manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    else:
        manifest = {'latest': '', 'min_supported': '0.2.0', 'versions': []}

    # 检查是否已存在
    existing = [v for v in manifest['versions'] if v['version'] == semver]
    if existing:
        print(f'Version {semver} already exists in manifest, skipping.')
        return

    # 生成 GitHub 下载链接
    assets = {}
    for platform, filename in PLATFORM_ASSETS.items():
        assets[platform] = {
            'github': f'https://github.com/{OWNER}/{REPO}/releases/download/v{semver}/{filename}'
        }

    # 新版本条目
    entry = {
        'version': semver,
        'build': build,
        'date': date.today().isoformat(),
        'changelog': '',  # 由维护者后续补充或从 release notes 读取
        'force_update_below': manifest.get('min_supported', '0.2.0'),
        'assets': assets,
    }

    # 插入到列表头部（最新版本在前）
    manifest['versions'].insert(0, entry)
    manifest['latest'] = semver

    # 写回
    manifest_path.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + '\n',
        encoding='utf-8',
    )
    print(f'Added version {semver}+{build} to manifest.')


if __name__ == '__main__':
    main()
```

### 7.2 `scripts/update-lanzou.py` — 手动更新蓝奏云链接

功能：向 manifest 中指定版本追加蓝奏云下载链接。

```python
#!/usr/bin/env python3
"""
向 versions-manifest.json 中指定版本追加蓝奏云下载链接。

用法：
  python3 scripts/update-lanzou.py \
    --version 0.3.2 \
    --manifest versions-manifest.json \
    --android-url "https://wwxx.lanzouq.com/iXXXX" \
    --android-password "abcd" \
    --windows-url "https://wwxx.lanzouq.com/iYYYY" \
    --windows-password "efgh"
"""

import argparse
import json
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--version', required=True)
    parser.add_argument('--manifest', required=True)
    parser.add_argument('--android-url', default='')
    parser.add_argument('--android-password', default='')
    parser.add_argument('--windows-url', default='')
    parser.add_argument('--windows-password', default='')
    args = parser.parse_args()

    manifest_path = Path(args.manifest)
    manifest = json.loads(manifest_path.read_text(encoding='utf-8'))

    # 查找目标版本
    target = None
    for v in manifest['versions']:
        if v['version'] == args.version:
            target = v
            break

    if target is None:
        sys.exit(f'ERROR: version {args.version} not found in manifest')

    # 更新蓝奏云链接
    if args.android_url:
        if 'android' not in target['assets']:
            target['assets']['android'] = {}
        lanzou = {'url': args.android_url}
        if args.android_password:
            lanzou['password'] = args.android_password
        target['assets']['android']['lanzou'] = lanzou

    if args.windows_url:
        if 'windows' not in target['assets']:
            target['assets']['windows'] = {}
        lanzou = {'url': args.windows_url}
        if args.windows_password:
            lanzou['password'] = args.windows_password
        target['assets']['windows']['lanzou'] = lanzou

    manifest_path.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + '\n',
        encoding='utf-8',
    )
    print(f'Updated lanzou links for version {args.version}.')


if __name__ == '__main__':
    main()
```

### 7.3 `scripts/upload-to-lanzou.md` — 蓝奏云上传操作指南

由于蓝奏云没有官方上传 API，提供手动操作指南：

```markdown
# 蓝奏云上传操作指南

## 前置条件
- 蓝奏云 VIP 账号（免费版限制 100MB，VIP 可上传更大文件）
- 浏览器已登录蓝奏云

## 操作步骤

1. 从 GitHub Releases 下载本次发布的 APK 和 Windows ZIP
2. 登录 https://up.woozooo.com 或 https://pc.woozooo.com
3. 上传文件到指定文件夹（建议按版本号命名文件夹）
4. 设置提取码（4位字母数字）
5. 获取分享链接
6. 在 GitHub Actions 中手动触发 "Update Lanzou Links" workflow：
   - 填入版本号、各平台蓝奏云链接和提取码
   - 或直接编辑 `versions-manifest.json` 并提交

## 文件命名规范
- Android: `busic-android-v{version}.apk`
- Windows: `busic-windows-v{version}.zip`
```

---

## 8. 蓝奏云直链解析方案

### 8.1 解析流程

蓝奏云分享链接是一个 HTML 中间页面，需要解析获取真实下载 URL。流程如下：

```
1. GET 蓝奏云分享页 URL
2. 若有密码，POST 密码到验证接口
3. 从响应中提取 iframe src 或 ajax 参数
4. 请求 ajax 接口获取真实下载链接
5. 302 重定向到文件直链
6. 使用直链通过 Dio 下载
```

### 8.2 实现位置

新增 `lib/features/app_update/data/lanzou_resolver.dart`：

```dart
class LanzouResolver {
  final Dio _dio;

  /// 解析蓝奏云分享链接，返回文件直链。
  Future<String> resolve(String shareUrl, {String? password}) async {
    // 1. 获取分享页面 HTML
    // 2. 解析 iframe 中的参数
    // 3. 请求 /ajaxm.php 获取下载信息
    // 4. 拼接真实下载 URL
    // 5. 跟踪重定向获取最终直链
  }
}
```

> **注意**：蓝奏云页面结构可能变化，解析器需要做好容错。建议在解析失败时 fallback 到打开浏览器让用户手动下载。

---

## 9. 断点续传方案

### 9.1 原理

HTTP Range 请求实现断点续传：

```
GET /file.apk HTTP/1.1
Range: bytes=10485760-
```

### 9.2 Dio 实现要点

```dart
await _dio.download(
  url,
  savePath,
  options: Options(
    headers: {
      'Range': 'bytes=$startByte-',
    },
  ),
  // 注意：断点续传需要追加模式写入
  deleteOnError: false,
);
```

### 9.3 状态持久化

暂停时需保存以下信息到 `SharedPreferences`：

```dart
class DownloadProgress {
  final String version;
  final DownloadChannel channel;
  final String savePath;
  final int downloadedBytes;
  final int totalBytes;
  final String downloadUrl;
}
```

App 重启后可从 SharedPreferences 恢复暂停状态。

---

## 10. 实施计划（分阶段）

### Phase 1：manifest + 后台下载 + 进度条

| 序号 | 任务 | 涉及文件 | 优先级 |
|------|------|---------|--------|
| 1.1 | 创建 `versions-manifest.json` 初始文件 | `versions-manifest.json` | P0 |
| 1.2 | 编写 `scripts/update-manifest.py` | `scripts/update-manifest.py` | P0 |
| 1.3 | 修改 `release.yml` 增加 manifest 更新步骤 | `.github/workflows/release.yml` | P0 |
| 1.4 | 新增 Freezed 模型 (`VersionManifest`, `VersionEntry`, `PlatformAssets`) | `lib/features/app_update/domain/models/` | P0 |
| 1.5 | 改造 `UpdateRepositoryImpl` 支持 manifest 获取 | `lib/features/app_update/data/update_repository_impl.dart` | P0 |
| 1.6 | 扩展 `UpdateState` 增加 `paused` 状态 | `lib/features/app_update/domain/models/update_state.dart` | P0 |
| 1.7 | 改造 `UpdateNotifier` 支持暂停/恢复 | `lib/features/app_update/application/update_notifier.dart` | P0 |
| 1.8 | 改造 `AboutSection` 嵌入进度条 UI | `lib/features/settings/presentation/widgets/about_section.dart` | P0 |
| 1.9 | 简化 `UpdateDialog` 为纯通知 | `lib/features/app_update/presentation/widgets/update_dialog.dart` | P1 |
| 1.10 | 添加 i18n 字符串 | `lib/l10n/app_en.arb`, `lib/l10n/app_zh.arb` | P0 |

### Phase 2：多渠道下载

| 序号 | 任务 | 涉及文件 | 优先级 |
|------|------|---------|--------|
| 2.1 | 新增 `DownloadChannel` 枚举 | `lib/features/app_update/domain/models/` | P0 |
| 2.2 | 实现渠道选择 BottomSheet | `lib/features/app_update/presentation/widgets/` | P0 |
| 2.3 | 实现蓝奏云直链解析器 | `lib/features/app_update/data/lanzou_resolver.dart` | P1 |
| 2.4 | 更新 `UpdateInfo` 支持多渠道 URL | `lib/features/app_update/domain/models/update_info.dart` | P0 |
| 2.5 | 编写 `scripts/update-lanzou.py` | `scripts/update-lanzou.py` | P1 |
| 2.6 | 新增 `upload-lanzou.yml` workflow | `.github/workflows/upload-lanzou.yml` | P1 |

### Phase 3：版本回退

| 序号 | 任务 | 涉及文件 | 优先级 |
|------|------|---------|--------|
| 3.1 | 新增 `ManifestCache` Provider | `lib/features/app_update/application/` | P0 |
| 3.2 | 实现版本选择列表 UI | `lib/features/app_update/presentation/widgets/` | P0 |
| 3.3 | `UpdateNotifier` 增加 `downloadHistoryVersion` 方法 | `lib/features/app_update/application/update_notifier.dart` | P0 |
| 3.4 | 设置页增加 "回退到历史版本" 入口 | `lib/features/settings/presentation/widgets/about_section.dart` | P0 |

### Phase 4：断点续传 + 打磨

| 序号 | 任务 | 涉及文件 | 优先级 |
|------|------|---------|--------|
| 4.1 | 实现 HTTP Range 断点续传 | `lib/features/app_update/data/update_repository_impl.dart` | P1 |
| 4.2 | 实现下载进度 SharedPreferences 持久化 | `lib/features/app_update/application/update_notifier.dart` | P1 |
| 4.3 | App 重启后恢复暂停状态 | `lib/features/app_update/application/update_notifier.dart` | P2 |
| 4.4 | 下载失败自动重试（最多 3 次） | `lib/features/app_update/data/update_repository_impl.dart` | P2 |

---

## 11. 文件变更汇总

### 新增文件

| 文件 | 说明 |
|------|------|
| `versions-manifest.json` | 版本清单（仓库根目录） |
| `scripts/update-manifest.py` | CI 自动更新 manifest 的脚本 |
| `scripts/update-lanzou.py` | 手动更新蓝奏云链接的脚本 |
| `scripts/upload-to-lanzou.md` | 蓝奏云上传操作指南 |
| `.github/workflows/upload-lanzou.yml` | 蓝奏云链接更新工作流 |
| `lib/features/app_update/domain/models/version_manifest.dart` | VersionManifest / VersionEntry / PlatformAssets 模型 |
| `lib/features/app_update/domain/models/download_channel.dart` | DownloadChannel 枚举 |
| `lib/features/app_update/data/lanzou_resolver.dart` | 蓝奏云直链解析器 |
| `lib/features/app_update/presentation/widgets/channel_picker_sheet.dart` | 渠道选择 BottomSheet |
| `lib/features/app_update/presentation/widgets/version_picker_dialog.dart` | 版本选择对话框 |
| `lib/features/app_update/presentation/widgets/download_tile.dart` | 设置页内嵌下载进度 Tile |

### 修改文件

| 文件 | 改动 |
|------|------|
| `.github/workflows/release.yml` | 增加 `update-manifest` job |
| `lib/features/app_update/domain/models/update_state.dart` | 增加 `paused` 状态 |
| `lib/features/app_update/domain/models/update_info.dart` | 增加多渠道 URL 字段 |
| `lib/features/app_update/data/update_repository.dart` | 增加 `fetchManifest` / `getVersionInfo` / `resolveLanzouUrl` 接口 |
| `lib/features/app_update/data/update_repository_impl.dart` | 实现新接口，改造 `checkForUpdate` 使用 manifest |
| `lib/features/app_update/data/proxy_prober.dart` | 新增 manifest URL 列表 |
| `lib/features/app_update/application/update_notifier.dart` | 增加暂停/恢复/渠道选择/历史版本方法 |
| `lib/features/app_update/presentation/widgets/update_dialog.dart` | 简化为纯通知 |
| `lib/features/settings/presentation/widgets/about_section.dart` | 嵌入下载进度条 + 回退入口 |
| `lib/l10n/app_en.arb` | 新增 i18n 字符串 |
| `lib/l10n/app_zh.arb` | 新增 i18n 字符串 |

---

## 12. 新增 i18n 字符串清单

| Key | 中文 | English |
|-----|------|---------|
| `downloadLatestVersion` | 下载最新版本 | Download Latest Version |
| `selectDownloadChannel` | 选择下载渠道 | Select Download Channel |
| `channelGithub` | GitHub（国际） | GitHub (International) |
| `channelLanzou` | 蓝奏云（国内高速） | LanZou Cloud (China) |
| `downloadPaused` | 已暂停 | Paused |
| `tapToPause` | 点击暂停 | Tap to pause |
| `tapToResume` | 点击继续 | Tap to resume |
| `longPressToCancel` | 长按取消下载 | Long press to cancel |
| `cancelDownloadConfirm` | 确定取消下载吗？ | Cancel download? |
| `rollbackVersion` | 回退到历史版本 | Rollback to Previous Version |
| `selectTargetVersion` | 选择目标版本 | Select Target Version |
| `installUpdate` | 安装更新 | Install Update |
| `downloadCompleteReady` | 下载完成，可以安装 | Download complete, ready to install |
| `retryDownload` | 重试下载 | Retry Download |
| `channelNotAvailable` | 该渠道暂无此版本 | This channel is not available for this version |
| `lanzouPasswordRequired` | 需要提取码 | Password required |

---

## 13. 风险与注意事项

| 风险 | 缓解措施 |
|------|---------|
| 蓝奏云页面结构变化导致解析失败 | 解析失败 fallback 到打开浏览器；解析器模块化，易于更新 |
| `versions-manifest.json` 被 jsdelivr 缓存导致更新延迟 | jsdelivr 默认 24h 缓存，可通过 `purge.jsdelivr.net` API 主动刷新；首次检查用 GitHub 直链 |
| manifest 被篡改投毒 | 校验 checksum（manifest 中内含 SHA-256），下载后验证 |
| 断点续传服务端不支持 Range | 检测 `Accept-Ranges` 头，不支持则回退全量下载 |
| 蓝奏云免费版文件大小限制 100MB | APK (~30MB) 可以，Windows ZIP (~60MB) 通常可以，超限则不提供蓝奏云渠道 |
| CI 自动提交 manifest 可能与手动提交冲突 | manifest 使用 JSON 格式，冲突容易解决；CI 提交前 pull 最新代码 |
