import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/app_update/domain/models/app_version.dart';

void main() {
  // ──── SECTION 1: 解析版本字符串 ────

  group('AppVersion.parse', () {
    test('解析标准版本号 major.minor.patch+build', () {
      final v = AppVersion.parse('0.2.1+3');
      expect(v.major, 0);
      expect(v.minor, 2);
      expect(v.patch, 1);
      expect(v.build, 3);
    });

    test('解析无 build 号的版本', () {
      final v = AppVersion.parse('1.0.0');
      expect(v.major, 1);
      expect(v.minor, 0);
      expect(v.patch, 0);
      expect(v.build, 0);
    });

    test('解析带前导空格的版本号', () {
      final v = AppVersion.parse('  2.3.4+10  ');
      expect(v.major, 2);
      expect(v.minor, 3);
      expect(v.patch, 4);
      expect(v.build, 10);
    });

    test('解析大版本号', () {
      final v = AppVersion.parse('99.88.77+666');
      expect(v.major, 99);
      expect(v.minor, 88);
      expect(v.patch, 77);
      expect(v.build, 666);
    });

    test('格式错误时抛出 FormatException', () {
      expect(
        () => AppVersion.parse('1.2'),
        throwsA(isA<FormatException>()),
      );
    });

    test('空字符串抛出异常', () {
      expect(
        () => AppVersion.parse(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('解析不含数字的字符串抛出异常', () {
      expect(
        () => AppVersion.parse('abc.def.ghi'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // ──── SECTION 2: 版本号字符串输出 ────

  group('AppVersion 字符串输出', () {
    test('semver 返回不含 build 的版本号', () {
      final v = AppVersion.parse('1.2.3+10');
      expect(v.semver, '1.2.3');
    });

    test('full 返回完整版本号', () {
      final v = AppVersion.parse('1.2.3+10');
      expect(v.full, '1.2.3+10');
    });

    test('toString 返回 semver', () {
      final v = AppVersion.parse('1.2.3+10');
      expect(v.toString(), '1.2.3');
    });

    test('build 为 0 时 full 包含 +0', () {
      final v = AppVersion.parse('1.0.0');
      expect(v.full, '1.0.0+0');
    });
  });

  // ──── SECTION 3: 版本比较 ────

  group('AppVersion 比较', () {
    test('major 不同 → 大的胜出', () {
      final v1 = AppVersion.parse('2.0.0');
      final v2 = AppVersion.parse('1.9.9');
      expect(v1 > v2, true);
      expect(v2 < v1, true);
    });

    test('minor 不同 → 大的胜出', () {
      final v1 = AppVersion.parse('1.2.0');
      final v2 = AppVersion.parse('1.1.9');
      expect(v1 > v2, true);
    });

    test('patch 不同 → 大的胜出', () {
      final v1 = AppVersion.parse('1.1.2');
      final v2 = AppVersion.parse('1.1.1');
      expect(v1 > v2, true);
    });

    test('build 不同 → 大的胜出', () {
      final v1 = AppVersion.parse('1.0.0+5');
      final v2 = AppVersion.parse('1.0.0+3');
      expect(v1 > v2, true);
    });

    test('完全相同 → 相等', () {
      final v1 = AppVersion.parse('1.2.3+4');
      final v2 = AppVersion.parse('1.2.3+4');
      expect(v1 == v2, true);
      expect(v1 >= v2, true);
      expect(v1 <= v2, true);
      expect(v1.compareTo(v2), 0);
    });

    test('operator <= 和 >=', () {
      final v1 = AppVersion.parse('1.0.0');
      final v2 = AppVersion.parse('1.0.1');
      expect(v1 <= v2, true);
      expect(v2 >= v1, true);
    });

    test('compareTo 返回正确的排序顺序', () {
      final versions = [
        AppVersion.parse('2.0.0'),
        AppVersion.parse('0.1.0'),
        AppVersion.parse('1.0.0'),
        AppVersion.parse('1.0.0+1'),
        AppVersion.parse('0.0.1'),
      ];
      versions.sort();
      expect(versions.map((v) => v.full).toList(), [
        '0.0.1+0',
        '0.1.0+0',
        '1.0.0+0',
        '1.0.0+1',
        '2.0.0+0',
      ]);
    });
  });

  // ──── SECTION 4: hashCode 和相等性 ────

  group('AppVersion hashCode 和相等性', () {
    test('相等的版本号有相同的 hashCode', () {
      final v1 = AppVersion.parse('1.2.3+4');
      final v2 = AppVersion.parse('1.2.3+4');
      expect(v1.hashCode, v2.hashCode);
    });

    test('不同版本号 hashCode 通常不同', () {
      final v1 = AppVersion.parse('1.2.3+4');
      final v2 = AppVersion.parse('1.2.4+4');
      // hashCode 不保证对不同对象一定不同，但对于简单值通常不同
      expect(v1 == v2, false);
    });

    test('与非 AppVersion 对象不相等', () {
      final v = AppVersion.parse('1.0.0');
      // ignore: unrelated_type_equality_checks
      expect(v == '1.0.0', false);
    });

    test('可在 Set 中去重', () {
      final set = {
        AppVersion.parse('1.0.0+1'),
        AppVersion.parse('1.0.0+1'),
        AppVersion.parse('2.0.0'),
      };
      expect(set.length, 2);
    });
  });

  // ──── SECTION 5: 构造函数 ────

  group('AppVersion 构造函数', () {
    test('const 构造函数创建实例', () {
      const v = AppVersion(major: 1, minor: 2, patch: 3, build: 4);
      expect(v.semver, '1.2.3');
      expect(v.build, 4);
    });

    test('build 默认为 0', () {
      const v = AppVersion(major: 0, minor: 0, patch: 1);
      expect(v.build, 0);
    });
  });
}
