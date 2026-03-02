import 'dart:convert';
import 'package:crypto/crypto.dart';

/// WBI signature algorithm for Bilibili API v3 requests.
///
/// Bilibili uses a time-varying key pair (imgKey + subKey) fetched from
/// the nav API to sign request parameters. This module implements the
/// character reordering and MD5 signing process.
class WbiSign {
  /// The fixed mixin key character order table used for WBI signing.
  static const List<int> _mixinKeyEncTab = [
    46, 47, 18, 2, 53, 8, 23, 32, 15, 50, 10, 31, 58, 3, 45, 35,
    27, 43, 5, 49, 33, 9, 42, 19, 29, 28, 14, 39, 12, 38, 41, 13,
    37, 48, 7, 16, 24, 55, 40, 61, 26, 17, 0, 1, 60, 51, 30, 4,
    22, 25, 54, 21, 56, 59, 6, 63, 57, 62, 11, 36, 20, 34, 44, 52,
  ];

  /// Generate a mixin key from [imgKey] and [subKey].
  ///
  /// Concatenates both keys and reorders characters according to
  /// [_mixinKeyEncTab], taking the first 32 characters.
  static String getMixinKey(String imgKey, String subKey) {
    final raw = imgKey + subKey;
    final buffer = StringBuffer();
    for (final idx in _mixinKeyEncTab) {
      if (idx < raw.length) {
        buffer.write(raw[idx]);
      }
    }
    return buffer.toString().substring(0, 32);
  }

  /// Encode request [params] with WBI signature.
  ///
  /// 1. Add `wts` (current timestamp) to params.
  /// 2. Sort params by key alphabetically.
  /// 3. URL-encode values, filtering special characters.
  /// 4. Concatenate as query string + mixin key.
  /// 5. Calculate MD5 hash and append as `w_rid`.
  ///
  /// Returns a new Map with all original params plus `wts` and `w_rid`.
  static Map<String, dynamic> encodeWbi(
    Map<String, dynamic> params, {
    required String imgKey,
    required String subKey,
  }) {
    final mixinKey = getMixinKey(imgKey, subKey);
    final wts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    // Copy params and add wts
    final signedParams = Map<String, dynamic>.from(params);
    signedParams['wts'] = wts;

    // Sort by key
    final sortedKeys = signedParams.keys.toList()..sort();

    // Build query string, filtering special chars from values
    final queryParts = <String>[];
    final filterRegex = RegExp(r"[!'()*]");
    for (final key in sortedKeys) {
      final value = signedParams[key].toString();
      final encodedValue =
          Uri.encodeComponent(value).replaceAll(filterRegex, '');
      queryParts.add('$key=$encodedValue');
    }
    final queryString = queryParts.join('&');

    // Calculate MD5 hash
    final hash = md5.convert(utf8.encode(queryString + mixinKey)).toString();

    signedParams['w_rid'] = hash;
    return signedParams;
  }

  /// Extract imgKey and subKey from the nav API response's wbi_img URLs.
  ///
  /// The keys are the filename stems (without extension) from:
  /// - `data.wbi_img.img_url` → imgKey
  /// - `data.wbi_img.sub_url` → subKey
  static ({String imgKey, String subKey}) extractKeys({
    required String imgUrl,
    required String subUrl,
  }) {
    // Extract filename stem from URL path
    String extractStem(String url) {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) return '';
      final filename = pathSegments.last;
      final dotIndex = filename.lastIndexOf('.');
      return dotIndex > 0 ? filename.substring(0, dotIndex) : filename;
    }

    return (
      imgKey: extractStem(imgUrl),
      subKey: extractStem(subUrl),
    );
  }
}
