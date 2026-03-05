# 应用自动更新 — 功能规划

## 概述

为 BuSic 实现**检查更新 + 自动更新**功能。  
核心思路：利用本仓库已有的 `pubspec.yaml` 作为版本清单（manifest），通过 GitHub 代理获取远端版本信息，与本地版本比对；在检测到新版本后展示更新日志，用户确认后自动下载对应平台的 Release 产物并应用安装。

---

## 一、现状分析

### 1.1 版本管理

| 项 | 现状 |
|----|------|
| 版本号 | `pubspec.yaml` → `version: 0.2.1+3`（语义化版本 `major.minor.patch+buildNumber`） |
| 构建触发 | 推送 `v*` tag → CI 通过后触发 `release.yml` |
| Release 产物 | `busic-android.apk` · `busic-windows-x64.zip` · `busic-linux-x64.tar.gz` · `busic-macos.zip` · `busic-ios-unsigned.ipa` |
| Release 页面 | `softprops/action-gh-release` 自动生成，含 `generate_release_notes: true` |
| 本地版本显示 | `settings_screen.dart` 中硬编码 `'0.2.1'`，未从 `pubspec.yaml` 动态读取 |

### 1.2 可用基础设施

| 组件 | 作用 |
|------|------|
| `BiliDio`（单例 Dio） | 通用 HTTP 客户端，可复用或新建独立 Dio 实例 |
| `PlatformUtils` | 平台判断（`isWindows / isAndroid / isDesktop / isMobile`） |
| `DownloadRepositoryImpl` | 已有完整的 Dio 下载 + 进度回调实现，可参考 |
| `AppLogger` | 统一日志 |
| `UserPreferences`（Freezed） | 用户偏好持久化，可扩展存储「跳过版本」等字段 |
| `SettingsScreen` | About 区域可新增「检查更新」入口 |

---

## 二、版本清单（Manifest）设计

### 2.1 方案对比

| 方案 | 优点 | 缺点 |
|------|------|------|
| **A. 直接读取 `pubspec.yaml`** | 零额外维护；版本号即 single source of truth | 需解析 YAML；无法携带额外元数据（更新日志、最低兼容版本等） |
| **B. 新增 `update.json`** | 结构自由，可含 changelog、force update 等 | 需额外维护，CI 需同步生成 |
| **C. 利用 GitHub Releases API** | 元数据最丰富（tag、body、assets 列表） | 依赖 GitHub API，需代理，速率限制 60 次/小时(未认证) |

### 2.2 推荐方案：A + C 组合

- **主路径（轻量快速）**：获取仓库 `pubspec.yaml` 的 `version` 字段，仅 ~3 KB 流量即可完成版本比对。
- **补充路径（详情获取）**：检测到新版本后，调用 GitHub Releases API 获取 Release Notes 和资产下载链接。
- **降级策略**：若 Releases API 被限流，直接拼接已知资产 URL 模式（`https://github.com/GlowLED/BuSic/releases/download/v{version}/busic-{platform}.{ext}`）。

### 2.3 仓库 Manifest（pubspec.yaml）中的额外信息

在 `pubspec.yaml` 尾部增加自定义字段（Flutter 忽略未知字段），用于携带更新元数据：

```yaml
# ── App Update Metadata (机器可读, 勿手动删除) ──
x_update:
  min_supported: "0.2.0"          # 低于此版本强制更新
  changelog: "新增自动更新功能"     # 简短更新说明（单行）
  release_notes_url: ""            # 可选：外部更新日志链接
```

> **CI 不需要改动**：`x_update` 随 `pubspec.yaml` 一起提交，tag 推送时自动包含。

---

## 三、GitHub 代理策略

中国大陆用户直连 `raw.githubusercontent.com` 和 `github.com/releases/download` 经常失败。需维护代理列表并自动选择最快节点。

### 3.1 代理列表

```dart
/// GitHub 原始文件代理（用于获取 pubspec.yaml）
const kRawProxies = [
  'https://raw.githubusercontent.com',           // 直连（海外/VPN 用户）
  'https://ghfast.top/https://raw.githubusercontent.com',
  'https://raw.gitmirror.com',
  'https://fastraw.ixnic.net',
  'https://gh-raw.bjzhk.xyz/https://raw.githubusercontent.com',
];

/// GitHub Release 资产代理（用于下载安装包）
const kReleaseProxies = [
  'https://github.com',                          // 直连
  'https://ghfast.top/https://github.com',
  'https://ghproxy.cc/https://github.com',
  'https://gh-proxy.ygxz.in/https://github.com',
];
```

### 3.2 代理选择策略

```
1. 并发请求所有代理（HEAD 请求, timeout 5s）
2. 取首个成功响应的代理作为本次会话首选
3. 缓存结果到内存（不持久化，每次启动重新探测）
4. 下载时若当前代理失败，自动回退到下一个代理
```

### 3.3 URL 拼接规则

| 用途 | URL 模板 |
|------|---------|
| 获取 manifest | `{rawProxy}/GlowLED/BuSic/{tag或main}/pubspec.yaml` |
| 获取 Release 信息 | `https://api.github.com/repos/GlowLED/BuSic/releases/latest`（或代理） |
| 下载安装包 | `{releaseProxy}/GlowLED/BuSic/releases/download/v{version}/{assetName}` |

---

## 四、版本比对逻辑

### 4.1 版本号解析

```dart
class AppVersion implements Comparable<AppVersion> {
  final int major;
  final int minor;
  final int patch;
  final int build; // +N 部分

  /// 从 "0.2.1+3" 格式解析
  factory AppVersion.parse(String versionString);

  /// 本地版本，编译时注入
  static AppVersion get current;
}
```

### 4.2 比对流程

```
获取远端 pubspec.yaml
  → 解析 version 字段 → remoteVersion
  → 解析 x_update.min_supported → minSupported

本地版本 → currentVersion (从 package_info_plus 获取)

if (currentVersion >= remoteVersion)
  → 已是最新版本
else if (currentVersion < minSupported)
  → 强制更新（不可跳过）
else
  → 普通更新（可跳过）
```

### 4.3 跳过版本

用户可选择「跳过此版本」，将 `remoteVersion` 字符串存入 `SharedPreferences`。  
下次检查时，若远端版本 == 已跳过版本 且非强制更新，则静默跳过。

---

## 五、更新流程（按平台）

### 5.1 Android

```
1. 下载 busic-android.apk → 应用缓存目录
2. 使用 open_file 或 android_intent 调用系统安装器
3. 需声明 REQUEST_INSTALL_PACKAGES 权限（Android 8+）
4. 需配置 FileProvider 以通过 content:// URI 共享 APK
```

**关键权限（AndroidManifest.xml）**：
```xml
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```

**FileProvider 配置**：
```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_paths" />
</provider>
```

### 5.2 Windows

```
1. 下载 busic-windows-x64.zip → 临时目录
2. 解压到临时安装目录
3. 生成 update.bat 脚本：
   a. 等待当前进程退出（taskkill /pid 或 timeout）
   b. 复制新文件覆盖旧安装目录
   c. 重新启动应用
   d. 删除临时文件
4. 启动 update.bat 后调用 exit(0) 退出当前进程
```

**update.bat 模板**：
```bat
@echo off
timeout /t 2 /nobreak >nul
xcopy /s /y /q "%TEMP_DIR%\*" "%INSTALL_DIR%\"
start "" "%INSTALL_DIR%\busic.exe"
rd /s /q "%TEMP_DIR%"
del "%~f0"
```

### 5.3 Linux

```
1. 下载 busic-linux-x64.tar.gz → 临时目录
2. 解压
3. 生成 update.sh 脚本（逻辑同 Windows）：
   a. 等待当前进程退出
   b. 复制新文件覆盖旧安装目录
   c. 重启应用
   d. 清理临时文件
4. chmod +x update.sh && 启动后退出
```

### 5.4 macOS

```
1. 下载 busic-macos.zip → 临时目录
2. 解压得到 busic.app
3. 替换 /Applications/busic.app（需要权限）
4. 重启应用
```

### 5.5 iOS

iOS 无法自更新（App Store 策略），仅展示「有新版本可用」提示，引导用户前往下载页面或 TestFlight。

---

## 六、模块设计（Feature-first 架构）

### 6.1 模块位置

```
lib/features/app_update/
├── domain/
│   └── models/
│       ├── app_version.dart           # AppVersion（版本号解析与比较）
│       └── update_info.dart           # UpdateInfo（Freezed：远端版本、changelog、是否强制等）
├── data/
│   ├── update_repository.dart         # 抽象接口
│   └── update_repository_impl.dart    # 实现：获取 manifest、解析版本、下载安装包
├── application/
│   └── update_notifier.dart           # @riverpod UpdateNotifier（检查/下载/安装编排）
└── presentation/
    └── widgets/
        └── update_dialog.dart         # 更新弹窗组件（显示版本号、changelog、进度条）
```

### 6.2 Domain 模型

```dart
/// 版本号模型
class AppVersion implements Comparable<AppVersion> {
  final int major;
  final int minor;
  final int patch;
  final int build;
  // ... parse, compareTo, toString
}

/// 更新信息
@freezed
class UpdateInfo with _$UpdateInfo {
  const factory UpdateInfo({
    required AppVersion latestVersion,
    required AppVersion currentVersion,
    required String changelog,
    required bool isForceUpdate,
    required String downloadUrl,
    required String assetName,
    String? releaseNotesUrl,
  }) = _UpdateInfo;
}

/// 更新状态
@freezed
class UpdateState with _$UpdateState {
  /// 空闲（未检查 / 已是最新）
  const factory UpdateState.idle() = _Idle;
  /// 检查中
  const factory UpdateState.checking() = _Checking;
  /// 发现新版本
  const factory UpdateState.available(UpdateInfo info) = _Available;
  /// 下载中
  const factory UpdateState.downloading({
    required UpdateInfo info,
    required double progress,
    required double speed,         // bytes/sec
  }) = _Downloading;
  /// 下载完成，准备安装
  const factory UpdateState.readyToInstall({
    required UpdateInfo info,
    required String localPath,
  }) = _ReadyToInstall;
  /// 错误
  const factory UpdateState.error(String message) = _Error;
}
```

### 6.3 Repository 接口

```dart
abstract class UpdateRepository {
  /// 从远端获取最新版本信息
  Future<UpdateInfo> checkForUpdate();

  /// 下载安装包，返回本地文件路径
  Future<String> downloadUpdate({
    required String url,
    required String savePath,
    required void Function(double progress, double speed) onProgress,
    CancelToken? cancelToken,
  });

  /// 应用更新（平台相关）
  Future<void> applyUpdate(String localPath);

  /// 探测最快的代理并缓存
  Future<void> probeProxies();
}
```

### 6.4 Notifier

```dart
@riverpod
class UpdateNotifier extends _$UpdateNotifier {
  @override
  UpdateState build() => const UpdateState.idle();

  /// 检查更新（可由用户手动触发或启动时自动执行）
  Future<void> checkForUpdate({bool silent = false});

  /// 开始下载
  Future<void> startDownload();

  /// 应用更新
  Future<void> applyUpdate();

  /// 跳过当前版本
  void skipVersion(String version);
}
```

### 6.5 UI 交互

#### 设置页 — 检查更新入口

在 `SettingsScreen` 的 About 区域下方新增：

```dart
ListTile(
  leading: const Icon(Icons.system_update),
  title: Text(l10n.checkForUpdate),
  subtitle: Text('v${AppVersion.current}'),
  onTap: () => ref.read(updateNotifierProvider.notifier).checkForUpdate(),
),
```

#### 更新弹窗 — UpdateDialog

```
┌─────────────────────────────────────┐
│          发现新版本 v0.3.0           │
│                                     │
│  更新内容：                          │
│  · 新增自动更新功能                   │
│  · 修复播放器若干 bug                │
│                                     │
│  ┌───────────────────────────┐      │
│  │  ██████████░░░░   65%     │      │
│  │  1.2 MB/s                 │      │
│  └───────────────────────────┘      │
│                                     │
│  [跳过此版本]          [立即更新]     │
│             [稍后提醒]               │
└─────────────────────────────────────┘
```

**强制更新模式**：隐藏「跳过此版本」和「稍后提醒」按钮，`barrierDismissible: false`。

---

## 七、自动检查时机与频率

| 时机 | 行为 |
|------|------|
| **应用启动** | 静默检查（silent=true），仅在发现新版本时弹窗 |
| **手动点击「检查更新」** | 显式检查，未发现更新也给出「已是最新」提示 |

### 频率控制

- 启动时静默检查最多每 **24 小时** 一次（记录上次检查时间到 `SharedPreferences`）。
- 手动检查不受频率限制。

---

## 八、安全考量

| 风险 | 缓解措施 |
|------|---------|
| 中间人篡改安装包 | 在 Release CI 中计算 SHA-256 并写入 Release Notes；客户端下载后校验 hash |
| 代理节点不可信 | 代理仅做转发，最终内容来自 GitHub；配合 hash 校验双重保障 |
| 降级攻击 | 客户端始终比较版本号，**不允许安装低于当前版本的包** |
| 恶意 manifest | 仅解析 `version` 和 `x_update` 字段，不执行任何远端代码 |

### 8.1 CI 增强（SHA-256）

在 `release.yml` 的 `publish` job 中新增步骤：

```yaml
- name: Generate checksums
  run: |
    sha256sum busic-* > checksums.sha256

- name: Create GitHub Release
  uses: softprops/action-gh-release@v2
  with:
    tag_name: ${{ needs.check.outputs.tag }}
    generate_release_notes: true
    files: |
      busic-linux-x64.tar.gz
      busic-windows-x64.zip
      busic-macos.zip
      busic-android.apk
      busic-ios-unsigned.ipa
      checksums.sha256
```

---

## 九、国际化 (i18n) 新增 Key

```json
// app_en.arb
{
  "checkForUpdate": "Check for updates",
  "updateAvailable": "New version available",
  "updateChangelog": "What's new",
  "updateNow": "Update now",
  "updateLater": "Later",
  "skipThisVersion": "Skip this version",
  "downloading": "Downloading",
  "downloadComplete": "Download complete",
  "installing": "Installing update...",
  "upToDate": "You're up to date",
  "updateError": "Update check failed",
  "forceUpdateTitle": "Required update",
  "forceUpdateMessage": "This version is no longer supported. Please update to continue using BuSic."
}
```

```json
// app_zh.arb
{
  "checkForUpdate": "检查更新",
  "updateAvailable": "发现新版本",
  "updateChangelog": "更新内容",
  "updateNow": "立即更新",
  "updateLater": "稍后提醒",
  "skipThisVersion": "跳过此版本",
  "downloading": "下载中",
  "downloadComplete": "下载完成",
  "installing": "正在安装更新...",
  "upToDate": "已是最新版本",
  "updateError": "检查更新失败",
  "forceUpdateTitle": "必须更新",
  "forceUpdateMessage": "当前版本已不受支持，请更新后继续使用 BuSic。"
}
```

---

## 十、依赖变更

### 新增依赖

| 包名 | 用途 | 平台 |
|------|------|------|
| `package_info_plus` | 运行时获取 app 版本号和 build number | 全平台 |
| `archive` | 解压 `.zip` / `.tar.gz` 安装包 | 桌面端 |
| `open_file` 或 `url_launcher` | Android 调用系统安装器安装 APK | Android |
| `yaml` | 解析远端 `pubspec.yaml`（轻量 YAML 解析器） | 全平台 |
| `crypto`（已有） | SHA-256 校验 | 全平台 |

### 无需新增

- **Dio**：已有 `dio` 依赖，用于下载。
- **path_provider**：已有，用于获取临时/缓存目录。
- **shared_preferences**：已有，用于存储跳过版本、上次检查时间。

---

## 十一、实施步骤

### Phase 1：基础设施（预计工时 1-2 天）

1. 添加 `package_info_plus`、`yaml`、`archive` 依赖
2. 实现 `AppVersion` 版本号模型
3. 实现代理探测工具（`ProxyProber`）
4. 在 `pubspec.yaml` 中添加 `x_update` 字段
5. 修改 `release.yml` 增加 `checksums.sha256` 生成

### Phase 2：检查更新（预计工时 1 天）

6. 实现 `UpdateRepository` 与 `UpdateRepositoryImpl`
7. 实现 `UpdateNotifier`
8. 在 `SettingsScreen` 添加「检查更新」入口
9. 替换硬编码版本号为 `package_info_plus` 动态读取

### Phase 3：下载与安装（预计工时 2-3 天）

10. 实现安装包下载（含进度、断点续传、代理回退）
11. 实现 SHA-256 校验
12. 实现平台特定安装逻辑：
    - Android：FileProvider + Intent 安装 APK
    - Windows：生成 `update.bat` + 进程替换
    - Linux：生成 `update.sh` + 进程替换
    - macOS：替换 `.app` bundle
13. 实现 `UpdateDialog` UI 组件

### Phase 4：完善（预计工时 1 天）

14. 添加 i18n 字符串
15. 实现静默检查（启动时 + 24h 冷却）
16. 实现「跳过此版本」逻辑
17. 错误处理与日志完善
18. 测试（各平台 E2E 验证）

---

## 十二、完整数据流图

```
应用启动 / 用户点击「检查更新」
  │
  ▼
UpdateNotifier.checkForUpdate()
  │
  ├─ ProxyProber.probe(kRawProxies) ──→ 最快 raw 代理
  │
  ├─ GET {bestRawProxy}/GlowLED/BuSic/main/pubspec.yaml
  │   │
  │   ▼
  │   YAML 解析 → remoteVersion, x_update
  │
  ├─ AppVersion.current (package_info_plus) → localVersion
  │
  ├─ 比较: localVersion < remoteVersion ?
  │   ├── No →  State = idle（已是最新）
  │   └── Yes → 获取 Release 详情
  │       │
  │       ├─ GET api.github.com/.../releases/tags/v{remoteVersion}
  │       │   └─ 解析 body (changelog) + assets (download URLs)
  │       │   └─ 若失败 → 拼接默认 URL + 使用 x_update.changelog
  │       │
  │       ▼
  │       State = available(UpdateInfo)
  │       │
  │       ▼
  │   显示 UpdateDialog
  │       │
  │       ├── 用户点击「跳过此版本」→ 存储 skipVersion → dismiss
  │       ├── 用户点击「稍后提醒」→ dismiss
  │       └── 用户点击「立即更新」
  │           │
  │           ▼
  │       UpdateNotifier.startDownload()
  │           │
  │           ├─ ProxyProber.probe(kReleaseProxies) → 最快 release 代理
  │           ├─ Dio.download(url, savePath, onProgress)
  │           │   └─ State = downloading(progress, speed)
  │           ├─ SHA-256 校验
  │           │   └─ 不匹配 → State = error
  │           ▼
  │       State = readyToInstall(localPath)
  │           │
  │           ▼
  │       UpdateNotifier.applyUpdate()
  │           │
  │           ├── Android: 调用系统安装器
  │           ├── Windows: 写 update.bat → Process.start → exit(0)
  │           ├── Linux: 写 update.sh → Process.start → exit(0)
  │           └── macOS: 替换 .app → 重启
  ▼
  完成
```

---

## 十三、注意事项与边界情况

1. **网络异常**：所有网络请求设置合理超时（检查 5s，下载根据文件大小动态调整），失败时显示友好错误信息。
2. **磁盘空间不足**：下载前检查可用空间，APK ~30MB、桌面端 ~50-80MB。
3. **用户取消下载**：使用 `CancelToken` 中断 Dio 请求，清理已下载的临时文件。
4. **下载中途退出应用**：下次启动时检测临时文件→若文件完整（hash 匹配）直接弹出安装确认，否则清理重新下载。
5. **安装目录只读（Linux Snap / Flatpak）**：检测安装路径权限，无权限时降级为「打开浏览器跳转 Release 页面」。
6. **多实例冲突（桌面端）**：更新脚本执行前检查是否有其他 BuSic 实例在运行。
7. **pubspec.yaml 中的 `version` 需保持 single source of truth**：settings_screen.dart 中硬编码的版本号应改为从 `package_info_plus` 动态读取。
