import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import 'package:busic/core/window/tray_service.dart';

void main() {
  group('Windows 托盘图标路径解析', () {
    late Directory tempDirectory;
    late String executablePath;

    setUp(() async {
      tempDirectory = await Directory.systemTemp.createTemp(
        'busic_tray_service_test_',
      );
      executablePath = p.join(tempDirectory.path, 'build', 'busic.exe');
    });

    tearDown(() async {
      if (await tempDirectory.exists()) {
        await tempDirectory.delete(recursive: true);
      }
    });

    test('构建产物包含 ICO 时返回 Flutter asset 相对路径', () async {
      // Arrange
      final bundledIcon = File(
        p.join(
          p.dirname(executablePath),
          'data',
          'flutter_assets',
          'assets',
          'images',
          'app_icon.ico',
        ),
      );
      await bundledIcon.parent.create(recursive: true);
      await bundledIcon.writeAsBytes(const [0]);

      // Act
      final result = await resolveTrayIconPath(
        isWindows: true,
        resolvedExecutable: executablePath,
        currentDirectory: tempDirectory.path,
      );

      // Assert
      expect(result, 'assets/images/app_icon.ico');
    });

    test('构建产物缺少 ICO 时返回仓库资源绝对路径', () async {
      // Arrange
      final sourceIcon = File(
        p.join(
          tempDirectory.path,
          'windows',
          'runner',
          'resources',
          'app_icon.ico',
        ),
      );
      await sourceIcon.parent.create(recursive: true);
      await sourceIcon.writeAsBytes(const [0]);

      // Act
      final result = await resolveTrayIconPath(
        isWindows: true,
        resolvedExecutable: executablePath,
        currentDirectory: tempDirectory.path,
      );

      // Assert
      expect(result, sourceIcon.path);
    });

    test('构建产物和仓库资源都缺少 ICO 时返回 null', () async {
      final result = await resolveTrayIconPath(
        isWindows: true,
        resolvedExecutable: executablePath,
        currentDirectory: tempDirectory.path,
      );

      expect(result, isNull);
    });

    test('非 Windows 平台继续解析 PNG', () async {
      // Arrange
      final bundledIcon = File(
        p.join(
          p.dirname(executablePath),
          'data',
          'flutter_assets',
          'assets',
          'images',
          'app_icon.png',
        ),
      );
      await bundledIcon.parent.create(recursive: true);
      await bundledIcon.writeAsBytes(const [0]);

      // Act
      final result = await resolveTrayIconPath(
        isWindows: false,
        resolvedExecutable: executablePath,
        currentDirectory: tempDirectory.path,
      );

      // Assert
      expect(result, bundledIcon.path);
    });
  });
}
