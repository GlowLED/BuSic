#!/usr/bin/env python3
"""
BuSic 发布 CLI — 引导开发者完成完整发布流程。

用法：
  python3 scripts/release.py

流程：
  1. 前置检查（Git 状态、分支）
  2. 输入新版本号，自动更新 pubspec.yaml
  3. 静态分析
  4. 本地构建 Android APK + Windows ZIP
  5. （可选）上传蓝奏云并录入链接
  6. 更新 versions-manifest.json
  7. Git commit + tag + push，触发 CI/CD
"""

import json
import os
import re
import shutil
import subprocess
import sys
from datetime import date
from pathlib import Path

# ── 常量 ──────────────────────────────────────────────────────────────

OWNER = 'GlowLED'
REPO = 'BuSic'
PUBSPEC = 'pubspec.yaml'
MANIFEST = 'versions-manifest.json'

GITHUB_ASSETS = {
    'android': 'busic-android.apk',
    'windows': 'busic-windows-x64.zip',
    'linux': 'busic-linux-x64.tar.gz',
    'macos': 'busic-macos.zip',
}


# ── 工具函数 ──────────────────────────────────────────────────────────

def run(cmd: str, capture=False, check=True) -> subprocess.CompletedProcess:
    """执行 shell 命令。"""
    print(f'  $ {cmd}')
    return subprocess.run(
        cmd, shell=True, capture_output=capture, text=True, check=check,
    )


def ask(prompt: str, default: str = '') -> str:
    """交互式输入，支持默认值。"""
    suffix = f' [{default}]' if default else ''
    value = input(f'{prompt}{suffix}: ').strip()
    return value or default


def confirm(prompt: str, default=True) -> bool:
    """Yes/No 确认。"""
    hint = 'Y/n' if default else 'y/N'
    value = input(f'{prompt} ({hint}): ').strip().lower()
    if not value:
        return default
    return value in ('y', 'yes')


def header(title: str):
    """打印步骤标题。"""
    print(f'\n{"═" * 60}')
    print(f'  {title}')
    print(f'{"═" * 60}\n')


def success(msg: str):
    print(f'  ✓ {msg}')


def error(msg: str):
    print(f'  ✗ {msg}', file=sys.stderr)


# ── 版本解析 ──────────────────────────────────────────────────────────

def parse_pubspec_version() -> tuple[str, int]:
    """从 pubspec.yaml 读取当前版本，返回 (semver, build)。"""
    content = Path(PUBSPEC).read_text(encoding='utf-8')
    match = re.search(r'^version:\s*(\S+)', content, re.MULTILINE)
    if not match:
        error('pubspec.yaml 中未找到 version 字段')
        sys.exit(1)
    version_str = match.group(1)
    if '+' in version_str:
        semver, build = version_str.split('+', 1)
        return semver, int(build)
    return version_str, 0


def update_pubspec_version(new_semver: str, new_build: int):
    """更新 pubspec.yaml 中的 version 字段。"""
    path = Path(PUBSPEC)
    content = path.read_text(encoding='utf-8')
    new_version = f'{new_semver}+{new_build}'
    content = re.sub(
        r'^(version:\s*)\S+',
        rf'\g<1>{new_version}',
        content,
        count=1,
        flags=re.MULTILINE,
    )
    path.write_text(content, encoding='utf-8')
    success(f'pubspec.yaml version → {new_version}')


def suggest_next_version(current: str) -> str:
    """根据当前版本建议下一个 patch 版本。"""
    parts = current.split('.')
    if len(parts) == 3:
        parts[2] = str(int(parts[2]) + 1)
    return '.'.join(parts)


# ── 步骤实现 ──────────────────────────────────────────────────────────

def step_prechecks():
    """步骤 1：前置检查。"""
    header('步骤 1/7  前置检查')

    # 检查 Git
    result = run('git rev-parse --abbrev-ref HEAD', capture=True)
    branch = result.stdout.strip()
    if branch != 'main':
        error(f'当前分支为 {branch}，请切换到 main 分支')
        sys.exit(1)
    success(f'当前分支: {branch}')

    # 检查工作区
    result = run('git status --porcelain', capture=True)
    if result.stdout.strip():
        print(f'\n  工作区有未提交的变更:')
        print(result.stdout)
        if not confirm('  是否继续？（变更将包含在发布 commit 中）'):
            sys.exit(0)
    else:
        success('工作区干净')


def step_version() -> tuple[str, int]:
    """步骤 2：确定新版本号。"""
    header('步骤 2/7  设置版本号')

    current_semver, current_build = parse_pubspec_version()
    print(f'  当前版本: {current_semver}+{current_build}')

    suggested = suggest_next_version(current_semver)
    new_semver = ask('  输入新版本号 (x.y.z)', suggested)

    # 验证格式
    if not re.match(r'^\d+\.\d+\.\d+$', new_semver):
        error(f'版本号格式无效: {new_semver}，应为 x.y.z')
        sys.exit(1)

    new_build = current_build + 1
    print(f'  新版本: {new_semver}+{new_build}')

    if not confirm('  确认？'):
        sys.exit(0)

    update_pubspec_version(new_semver, new_build)
    return new_semver, new_build


def step_analyze():
    """步骤 3：静态分析。"""
    header('步骤 3/7  静态分析')

    result = run('flutter analyze', capture=True, check=False)

    # 明确要求 0 issue：分析命令成功且输出包含 No issues found。
    analyze_output = f'{result.stdout}\n{result.stderr}'
    if result.returncode != 0 or 'No issues found' not in analyze_output:
        error('静态分析未通过（要求 0 issue），请先修复问题')
        if analyze_output.strip():
            print(analyze_output)
        sys.exit(1)
    success('静态分析通过')


def step_build() -> dict[str, Path]:
    """步骤 4：本地构建 Android + Windows。"""
    header('步骤 4/7  本地构建')

    artifacts: dict[str, Path] = {}

    # ── Android APK ──
    print('\n  [Android] 构建 APK ...')
    result = run('flutter build apk --release', check=False)
    apk_path = Path('build/app/outputs/flutter-apk/app-release.apk')
    if result.returncode == 0 and apk_path.exists():
        success(f'APK: {apk_path}')
        artifacts['android'] = apk_path
    else:
        error('Android 构建失败')
        if not confirm('  是否跳过 Android 构建继续？'):
            sys.exit(1)

    # ── Windows ZIP ──
    print('\n  [Windows] 构建 ...')
    result = run('flutter build windows --release', check=False)
    win_dir = Path('build/windows/x64/runner/Release')
    win_zip = Path('build/busic-windows-x64.zip')
    if result.returncode == 0 and win_dir.exists():
        # 打包为 zip
        if win_zip.exists():
            win_zip.unlink()
        shutil.make_archive(
            str(win_zip.with_suffix('')),
            'zip',
            root_dir=str(win_dir),
        )
        success(f'ZIP: {win_zip}')
        artifacts['windows'] = win_zip
    else:
        error('Windows 构建失败')
        if not confirm('  是否跳过 Windows 构建继续？'):
            sys.exit(1)

    if artifacts:
        print('\n  构建产物:')
        for platform, path in artifacts.items():
            size_mb = path.stat().st_size / (1024 * 1024)
            print(f'    {platform}: {path}  ({size_mb:.1f} MB)')

    return artifacts


def step_lanzou(version: str) -> dict:
    """步骤 5：（可选）上传蓝奏云。"""
    header('步骤 5/7  蓝奏云发布（可选）')

    if not confirm('  是否上传蓝奏云？', default=False):
        success('跳过蓝奏云')
        return {}

    print('\n  请手动上传构建产物到蓝奏云，然后填入分享信息。')
    print('  提示: 构建产物位于:')
    print('    Android APK: build/app/outputs/flutter-apk/app-release.apk')
    print('    Windows ZIP: build/busic-windows-x64.zip')
    print()

    lanzou: dict = {}

    # Android
    android_url = ask('  Android 蓝奏云链接（留空跳过）')
    if android_url:
        android_pwd = ask('  Android 提取码（留空表示无密码）')
        lanzou['android'] = {'url': android_url}
        if android_pwd:
            lanzou['android']['password'] = android_pwd

    # Windows
    windows_url = ask('  Windows 蓝奏云链接（留空跳过）')
    if windows_url:
        windows_pwd = ask('  Windows 提取码（留空表示无密码）')
        lanzou['windows'] = {'url': windows_url}
        if windows_pwd:
            lanzou['windows']['password'] = windows_pwd

    if lanzou:
        success(f'已录入 {len(lanzou)} 个蓝奏云链接')
    else:
        success('未录入蓝奏云链接')

    return lanzou


def step_manifest(version: str, build: int, lanzou: dict):
    """步骤 6：更新 versions-manifest.json。"""
    header('步骤 6/7  更新 versions-manifest.json')

    manifest_path = Path(MANIFEST)
    if manifest_path.exists():
        manifest = json.loads(manifest_path.read_text(encoding='utf-8'))
    else:
        manifest = {'latest': '', 'min_supported': '0.2.0', 'versions': []}

    # 检查是否已存在
    existing = [v for v in manifest['versions'] if v['version'] == version]
    if existing:
        print(f'  版本 {version} 已存在于 manifest，将覆盖更新。')
        manifest['versions'] = [
            v for v in manifest['versions'] if v['version'] != version
        ]

    # 输入 changelog
    changelog = ask('  版本更新说明（一行，留空跳过）')

    # 构建 assets
    assets: dict = {}
    for platform, filename in GITHUB_ASSETS.items():
        assets[platform] = {
            'github': f'https://github.com/{OWNER}/{REPO}/releases/download/v{version}/{filename}'
        }

    # 合并蓝奏云链接
    for platform, lanzou_info in lanzou.items():
        if platform in assets:
            assets[platform]['lanzou'] = lanzou_info

    entry = {
        'version': version,
        'build': build,
        'date': date.today().isoformat(),
        'changelog': changelog,
        'force_update_below': manifest.get('min_supported', '0.2.0'),
        'assets': assets,
    }

    manifest['versions'].insert(0, entry)
    manifest['latest'] = version

    manifest_path.write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + '\n',
        encoding='utf-8',
    )
    success(f'manifest 已更新: latest = {version}')


def step_git_push(version: str):
    """步骤 7：Git 提交 + 打 Tag + 推送。"""
    header('步骤 7/7  Git 提交与推送')

    commit_msg = ask(f'  提交信息', f'v{version}')

    print('\n  即将执行:')
    print(f'    git add -A')
    print(f'    git commit -m "{commit_msg}"')
    print(f'    git tag v{version}')
    print(f'    git push origin main --tags')
    print()

    if not confirm('  确认推送？'):
        print('\n  已取消推送。你可以手动执行上述命令完成发布。')
        return

    run('git add -A')
    run(f'git commit -m "{commit_msg}"')
    run(f'git tag v{version}')
    run('git push origin main --tags')

    success(f'已推送 v{version}，CI/CD 已触发')
    print()
    print(f'  GitHub Actions: https://github.com/{OWNER}/{REPO}/actions')
    print(f'  Releases:       https://github.com/{OWNER}/{REPO}/releases')


# ── 主流程 ────────────────────────────────────────────────────────────

def main():
    print()
    print('  ╔══════════════════════════════════════╗')
    print('  ║       BuSic 发布助手 v1.0            ║')
    print('  ╚══════════════════════════════════════╝')

    # 确保在项目根目录
    if not Path(PUBSPEC).exists():
        error('请在项目根目录运行此脚本')
        sys.exit(1)

    step_prechecks()
    version, build = step_version()
    step_analyze()
    artifacts = step_build()
    lanzou = step_lanzou(version)
    step_manifest(version, build, lanzou)
    step_git_push(version)

    print()
    print('  ════════════════════════════════════════')
    print('  发布流程完成！')
    print('  ════════════════════════════════════════')
    print()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\n\n  已取消。')
        sys.exit(130)
