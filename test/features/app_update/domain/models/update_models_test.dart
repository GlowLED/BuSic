import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/app_update/domain/models/app_version.dart';
import 'package:busic/features/app_update/domain/models/download_channel.dart';
import 'package:busic/features/app_update/domain/models/update_info.dart';
import 'package:busic/features/app_update/domain/models/update_state.dart';

void main() {
  // ──── SECTION 1: UpdateInfo Freezed 模型 ────

  group('UpdateInfo', () {
    test('创建实例', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('1.0.0+1'),
        currentVersion: AppVersion.parse('0.9.0+1'),
        changelog: '修复若干 bug',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'https://example.com/busic.apk'},
        assetName: 'busic-android.apk',
      );

      expect(info.latestVersion.semver, '1.0.0');
      expect(info.currentVersion.semver, '0.9.0');
      expect(info.changelog, '修复若干 bug');
      expect(info.isForceUpdate, false);
      expect(info.releaseNotesUrl, isNull);
    });

    test('copyWith 替换字段', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('1.0.0'),
        currentVersion: AppVersion.parse('0.9.0'),
        changelog: 'old',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
      );

      final updated = info.copyWith(
        changelog: 'new changelog',
        isForceUpdate: true,
      );

      expect(updated.changelog, 'new changelog');
      expect(updated.isForceUpdate, true);
      // 其他字段不变
      expect(updated.latestVersion, info.latestVersion);
      expect(updated.downloadUrls[DownloadChannel.github], 'url');
    });

    test('releaseNotesUrl 可选', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('1.0.0'),
        currentVersion: AppVersion.parse('0.9.0'),
        changelog: '',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
        releaseNotesUrl: 'https://example.com/notes',
      );

      expect(info.releaseNotesUrl, 'https://example.com/notes');
    });
  });

  // ──── SECTION 2: UpdateState Freezed 状态机 ────

  group('UpdateState', () {
    test('idle 状态', () {
      const state = UpdateState.idle();
      expect(state, isA<UpdateStateIdle>());
    });

    test('checking 状态', () {
      const state = UpdateState.checking();
      expect(state, isA<UpdateStateChecking>());
    });

    test('available 状态携带 UpdateInfo', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('2.0.0'),
        currentVersion: AppVersion.parse('1.0.0'),
        changelog: 'New features',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
      );

      final state = UpdateState.available(info);
      expect(state, isA<UpdateStateAvailable>());
      expect((state as UpdateStateAvailable).info, info);
    });

    test('downloading 状态携带进度和速度', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('2.0.0'),
        currentVersion: AppVersion.parse('1.0.0'),
        changelog: '',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
      );

      final state = UpdateState.downloading(
        info: info,
        progress: 0.5,
        speed: 1024 * 1024,
        channel: DownloadChannel.github,
      );

      expect(state, isA<UpdateStateDownloading>());
      final dl = state as UpdateStateDownloading;
      expect(dl.progress, 0.5);
      expect(dl.speed, 1024 * 1024);
    });

    test('paused 状态', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('2.0.0'),
        currentVersion: AppVersion.parse('1.0.0'),
        changelog: '',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
      );

      final state = UpdateState.paused(
        info: info,
        progress: 0.5,
        channel: DownloadChannel.github,
        downloadedBytes: 500,
        totalBytes: 1000,
        localPath: '/tmp/busic.apk',
      );

      expect(state, isA<UpdateStatePaused>());
      final p = state as UpdateStatePaused;
      expect(p.progress, 0.5);
      expect(p.downloadedBytes, 500);
    });

    test('readyToInstall 状态携带本地路径', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('2.0.0'),
        currentVersion: AppVersion.parse('1.0.0'),
        changelog: '',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
      );

      final state = UpdateState.readyToInstall(
        info: info,
        localPath: '/tmp/busic.apk',
      );

      expect(state, isA<UpdateStateReadyToInstall>());
      expect((state as UpdateStateReadyToInstall).localPath, '/tmp/busic.apk');
    });

    test('error 状态携带错误信息', () {
      const state = UpdateState.error('网络超时');
      expect(state, isA<UpdateStateError>());
      expect((state as UpdateStateError).message, '网络超时');
    });

    test('when 模式匹配所有状态', () {
      final info = UpdateInfo(
        latestVersion: AppVersion.parse('2.0.0'),
        currentVersion: AppVersion.parse('1.0.0'),
        changelog: '',
        isForceUpdate: false,
        downloadUrls: {DownloadChannel.github: 'url'},
        assetName: 'asset',
      );

      final states = <UpdateState>[
        const UpdateState.idle(),
        const UpdateState.checking(),
        UpdateState.available(info),
        UpdateState.downloading(
          info: info,
          progress: 0.3,
          speed: 100,
          channel: DownloadChannel.github,
        ),
        UpdateState.paused(
          info: info,
          progress: 0.3,
          channel: DownloadChannel.github,
          downloadedBytes: 300,
          totalBytes: 1000,
          localPath: '/tmp/f',
        ),
        UpdateState.readyToInstall(info: info, localPath: '/tmp/f'),
        const UpdateState.error('err'),
      ];

      final results = states.map((s) => s.when(
            idle: () => 'idle',
            checking: () => 'checking',
            available: (_) => 'available',
            downloading: (_, __, ___, ____, _____, ______) => 'downloading',
            paused: (_, __, ___, ____, _____, ______) => 'paused',
            readyToInstall: (_, __) => 'readyToInstall',
            error: (_) => 'error',
          ));

      expect(results.toList(), [
        'idle',
        'checking',
        'available',
        'downloading',
        'paused',
        'readyToInstall',
        'error',
      ]);
    });
  });

  // ──── SECTION 3: UpdateState 相等性 ────

  group('UpdateState 相等性', () {
    test('相同 idle 状态相等', () {
      expect(
        const UpdateState.idle(),
        const UpdateState.idle(),
      );
    });

    test('相同 error 消息相等', () {
      expect(
        const UpdateState.error('fail'),
        const UpdateState.error('fail'),
      );
    });

    test('不同 error 消息不相等', () {
      expect(
        const UpdateState.error('fail') == const UpdateState.error('other'),
        false,
      );
    });

    test('不同状态类型不相等', () {
      expect(
        const UpdateState.idle() == const UpdateState.checking(),
        false,
      );
    });
  });
}
