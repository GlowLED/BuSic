import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/logger.dart';

const _kTag = 'LanzouResolver';

/// 蓝奏云分享链接解析器，将分享页链接转换为文件直链。
///
/// 蓝奏云页面结构可能变化，解析失败时 fallback 到打开浏览器。
class LanzouResolver {
  final Dio _dio;

  LanzouResolver({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              headers: {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                        '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
              },
            ));

  /// 解析蓝奏云分享链接，返回文件直链。
  ///
  /// 解析失败时抛出异常。调用方应 catch 后 fallback 到浏览器打开。
  Future<String> resolve(String shareUrl, {String? password}) async {
    AppLogger.info('Resolving Lanzou URL: $shareUrl', tag: _kTag);

    // 规范化域名（蓝奏云多域名）
    final normalizedUrl = _normalizeDomain(shareUrl);

    // 1. 获取分享页 HTML
    final pageResponse = await _dio.get<String>(
      normalizedUrl,
      options: Options(
        followRedirects: true,
        validateStatus: (s) => s != null && s < 400,
      ),
    );
    final html = pageResponse.data ?? '';

    // 2. 检查是否需要密码
    if (html.contains('id="pwd"') || html.contains('输入密码')) {
      if (password == null || password.isEmpty) {
        throw Exception('蓝奏云链接需要提取码');
      }
      return _resolveWithPassword(normalizedUrl, html, password);
    }

    // 3. 无密码链接 — 提取 iframe src
    return _resolveWithoutPassword(normalizedUrl, html);
  }

  /// 解析失败时打开浏览器作为 fallback
  static Future<void> openInBrowser(String shareUrl) async {
    final uri = Uri.parse(shareUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _normalizeDomain(String url) {
    // 蓝奏云有多个域名变体
    return url
        .replaceFirst(RegExp(r'lanzou[a-z]\.com'), 'lanzoup.com')
        .replaceFirst(RegExp(r'lanzoui\.com'), 'lanzoup.com')
        .replaceFirst(RegExp(r'lanzoux\.com'), 'lanzoup.com');
  }

  Future<String> _resolveWithoutPassword(String pageUrl, String html) async {
    // 提取 iframe src
    final iframeMatch =
        RegExp(r'<iframe[^>]+src="([^"]+)"').firstMatch(html);
    if (iframeMatch == null) {
      throw Exception('无法解析蓝奏云页面：未找到 iframe');
    }

    final iframeSrc = iframeMatch.group(1)!;
    final baseUri = Uri.parse(pageUrl);
    final iframeUrl = iframeSrc.startsWith('http')
        ? iframeSrc
        : '${baseUri.scheme}://${baseUri.host}$iframeSrc';

    // 请求 iframe 页面获取下载参数
    final iframeResponse = await _dio.get<String>(iframeUrl);
    final iframeHtml = iframeResponse.data ?? '';

    return _extractAndRequestDownload(baseUri, iframeHtml);
  }

  Future<String> _resolveWithPassword(
    String pageUrl,
    String html,
    String password,
  ) async {
    // 提取 action 参数
    final signMatch = RegExp(r"'sign'\s*:\s*'([^']+)'").firstMatch(html);
    final sign = signMatch?.group(1) ?? '';

    final baseUri = Uri.parse(pageUrl);
    final ajaxUrl = '${baseUri.scheme}://${baseUri.host}/ajaxm.php';

    final response = await _dio.post<String>(
      ajaxUrl,
      data: 'action=downprocess&sign=$sign&p=$password',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {'Referer': pageUrl},
      ),
    );

    final data = json.decode(response.data ?? '{}') as Map<String, dynamic>;
    final zt = data['zt'] as int? ?? 0;
    if (zt != 1) {
      final info = data['inf'] as String? ?? '密码错误或链接无效';
      throw Exception('蓝奏云解析失败: $info');
    }

    final dom = data['dom'] as String? ?? '';
    final downloadUrl = data['url'] as String? ?? '';
    final directUrl = '$dom/file/$downloadUrl';

    return _followRedirect(directUrl);
  }

  Future<String> _extractAndRequestDownload(
    Uri baseUri,
    String iframeHtml,
  ) async {
    // 从 iframe HTML 中提取 ajaxm.php 请求参数
    final signMatch =
        RegExp(r"'sign'\s*:\s*'([^']+)'").firstMatch(iframeHtml);
    final sign = signMatch?.group(1) ?? '';

    final ajaxUrl = '${baseUri.scheme}://${baseUri.host}/ajaxm.php';

    final response = await _dio.post<String>(
      ajaxUrl,
      data: 'action=downprocess&sign=$sign&p=',
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {'Referer': baseUri.toString()},
      ),
    );

    final data = json.decode(response.data ?? '{}') as Map<String, dynamic>;
    final zt = data['zt'] as int? ?? 0;
    if (zt != 1) {
      throw Exception('蓝奏云解析失败: ${data['inf'] ?? '未知错误'}');
    }

    final dom = data['dom'] as String? ?? '';
    final downloadUrl = data['url'] as String? ?? '';
    final directUrl = '$dom/file/$downloadUrl';

    return _followRedirect(directUrl);
  }

  /// 跟踪重定向获取最终直链
  Future<String> _followRedirect(String url) async {
    final response = await _dio.head<dynamic>(
      url,
      options: Options(
        followRedirects: false,
        validateStatus: (s) => s != null && s < 400 || s == 302,
      ),
    );

    final location = response.headers.value('location');
    if (location != null && location.isNotEmpty) {
      AppLogger.info('Lanzou direct URL resolved: $location', tag: _kTag);
      return location;
    }

    // 如果没有重定向，原 URL 可能就是直链
    AppLogger.info('Lanzou direct URL: $url', tag: _kTag);
    return url;
  }
}
