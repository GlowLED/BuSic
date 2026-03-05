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

    // 1. 获取分享页 HTML（处理 acw_sc__v2 反爬挑战）
    final html = await _fetchWithChallenge(normalizedUrl);

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

  // ─── acw_sc__v2 反爬处理 ───

  /// 获取页面 HTML，自动处理 acw_sc__v2 反爬挑战。
  ///
  /// 蓝奏云首次请求可能返回含混淆 JS 的挑战页面，需要计算 cookie
  /// 后重新请求才能获得真实页面内容。
  Future<String> _fetchWithChallenge(String url) async {
    final resp = await _dio.get<String>(
      url,
      options: Options(
        followRedirects: true,
        validateStatus: (s) => s != null && s < 400,
      ),
    );
    final html = resp.data ?? '';

    // 检测是否为 acw_sc__v2 挑战页面
    if (!html.contains('arg1') || !html.contains('acw_sc__v2')) {
      return html;
    }

    AppLogger.info('Detected acw_sc__v2 challenge', tag: _kTag);

    final arg1Match = RegExp(r"var\s+arg1\s*=\s*'([0-9A-Fa-f]+)'")
        .firstMatch(html);
    if (arg1Match == null) {
      throw Exception('无法提取 acw_sc__v2 挑战参数 arg1');
    }

    final cookieVal = _calcAcwScV2(arg1Match.group(1)!);
    final host = Uri.parse(url).host;

    // 设置 cookie 并重新请求
    _dio.options.headers['Cookie'] =
        'acw_sc__v2=$cookieVal; domain=$host';

    final resp2 = await _dio.get<String>(
      url,
      options: Options(
        followRedirects: true,
        validateStatus: (s) => s != null && s < 400,
      ),
    );
    return resp2.data ?? '';
  }

  /// 从蓝奏云反爬 JS 逆向出的 cookie 计算算法
  static String _calcAcwScV2(String arg1) {
    const m = [
      15, 35, 29, 24, 33, 16, 1, 38, 10, 9, 19, 31, 40, 27, 22, 23,
      25, 13, 6, 11, 39, 18, 20, 8, 14, 21, 32, 26, 2, 30, 7, 4,
      17, 5, 3, 28, 34, 37, 12, 36,
    ];
    const p = '3000176000856006061501533003690027800375';

    final q = List<String>.filled(m.length, '');
    for (var x = 0; x < arg1.length; x++) {
      for (var z = 0; z < m.length; z++) {
        if (m[z] == x + 1) {
          q[z] = arg1[x];
        }
      }
    }
    final u = q.join();

    final buf = StringBuffer();
    final len = u.length < p.length ? u.length : p.length;
    for (var x = 0; x < len; x += 2) {
      final aVal =
          int.parse(u.substring(x, x + 2), radix: 16) ^
          int.parse(p.substring(x, x + 2), radix: 16);
      buf.write(aVal.toRadixString(16).padLeft(2, '0'));
    }
    return buf.toString();
  }

  // ─── 辅助方法 ───

  String _normalizeDomain(String url) {
    // 蓝奏云有多个域名变体
    return url
        .replaceFirst(RegExp(r'lanzou[a-z]\.com'), 'lanzoup.com')
        .replaceFirst(RegExp(r'lanzoui\.com'), 'lanzoup.com')
        .replaceFirst(RegExp(r'lanzoux\.com'), 'lanzoup.com');
  }

  /// 去除 JS 行注释（// ...）和块注释（/* ... */）
  static String _stripJsComments(String js) {
    // 先去除块注释
    var result = js.replaceAll(RegExp(r'/\*.*?\*/', dotAll: true), '');
    // 再去除行注释
    result = result.replaceAll(RegExp(r'//[^\n]*'), '');
    return result;
  }

  /// 从 HTML/JS 中提取 ajax URL 路径（/ajaxm.php?file=xxx）
  static String? _extractAjaxPath(String cleanJs) {
    final m = RegExp(r"url\s*:\s*'(/ajaxm\.php\?file=\d+)'")
        .firstMatch(cleanJs);
    return m?.group(1);
  }

  // ─── 无密码流程 ───

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
    final iframeResponse = await _dio.get<String>(
      iframeUrl,
      options: Options(headers: {'Referer': pageUrl}),
    );
    final iframeHtml = iframeResponse.data ?? '';

    return _extractAndRequestDownload(baseUri, iframeUrl, iframeHtml);
  }

  Future<String> _extractAndRequestDownload(
    Uri baseUri,
    String iframeUrl,
    String iframeHtml,
  ) async {
    // 去除注释后提取参数，避免匹配到注释中的旧值
    final cleanHtml = _stripJsComments(iframeHtml);

    // 提取 wp_sign（无密码页面使用的 sign 变量）
    final wpSignMatch =
        RegExp(r"var\s+wp_sign\s*=\s*'([^']+)'").firstMatch(iframeHtml);
    final wpSign = wpSignMatch?.group(1) ?? '';

    // 提取 ajaxdata
    final ajaxdataMatch =
        RegExp(r"var\s+ajaxdata\s*=\s*'([^']+)'").firstMatch(iframeHtml);
    final ajaxdata = ajaxdataMatch?.group(1) ?? '';

    // 提取 ajax URL 路径（/ajaxm.php?file=xxx）
    final ajaxPath = _extractAjaxPath(cleanHtml) ?? '/ajaxm.php';
    final ajaxUrl = '${baseUri.scheme}://${baseUri.host}$ajaxPath';

    AppLogger.info(
      'No-pwd params: wp_sign=${wpSign.length > 10 ? '${wpSign.substring(0, 10)}...' : wpSign}, '
      'ajaxdata=$ajaxdata, ajaxPath=$ajaxPath',
      tag: _kTag,
    );

    final response = await _dio.post<String>(
      ajaxUrl,
      data: {
        'action': 'downprocess',
        'websignkey': ajaxdata,
        'signs': ajaxdata,
        'sign': wpSign,
        'websign': '',
        'kd': '1',
        'ves': '1',
      },
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {'Referer': iframeUrl},
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

  // ─── 有密码流程 ───

  Future<String> _resolveWithPassword(
    String pageUrl,
    String html,
    String password,
  ) async {
    // 去除 JS 注释后提取 sign，避免匹配到注释中的旧值
    final cleanHtml = _stripJsComments(html);

    final signMatch =
        RegExp(r"'sign'\s*:\s*'([^']+)'").firstMatch(cleanHtml);
    final sign = signMatch?.group(1) ?? '';

    // 提取 ajax URL 路径（/ajaxm.php?file=xxx）
    final ajaxPath = _extractAjaxPath(cleanHtml) ?? '/ajaxm.php';
    final baseUri = Uri.parse(pageUrl);
    final ajaxUrl = '${baseUri.scheme}://${baseUri.host}$ajaxPath';

    AppLogger.info(
      'Pwd params: sign=${sign.length > 10 ? '${sign.substring(0, 10)}...' : sign}, '
      'ajaxPath=$ajaxPath',
      tag: _kTag,
    );

    final response = await _dio.post<String>(
      ajaxUrl,
      data: {
        'action': 'downprocess',
        'sign': sign,
        'p': password,
        'kd': '1',
      },
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
