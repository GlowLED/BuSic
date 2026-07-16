import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/api/bili_dio.dart';

/// Pure HTTP download engine with Range / resume support.
///
/// Handles the Dio stream request, chunked file writing, and progress
/// reporting. Does **not** touch the database or task cache — that stays
/// in [DownloadRepositoryImpl].
class DownloadEngine {
  final BiliDio _dio;

  DownloadEngine({required BiliDio dio}) : _dio = dio;

  /// Downloads [url] into [savePath].
  ///
  /// * [startOffset] > 0 requests a `Range: bytes=<startOffset>-` header
  ///   for resume support (HTTP 206).
  /// * [onProgress] is called for **every** received chunk with
  ///   `(receivedBytes, totalBytes)`.
  /// * Throws [DioException] (type == cancel) when [cancelToken] is
  ///   cancelled.
  Future<void> download({
    required String url,
    required String savePath,
    required CancelToken cancelToken,
    int startOffset = 0,
    required void Function(int receivedBytes, int totalBytes) onProgress,
  }) async {
    final headers = <String, dynamic>{'Referer': 'https://www.bilibili.com'};
    if (startOffset > 0) {
      headers['Range'] = 'bytes=$startOffset-';
    }

    final response = await _dio.get(
      url,
      options: Options(responseType: ResponseType.stream, headers: headers),
      cancelToken: cancelToken,
    );

    // Determine actual offset and total file size
    int actualOffset = startOffset;
    int totalBytes = 0;
    if (startOffset > 0 && response.statusCode == 206) {
      final contentRange = response.headers.value('content-range');
      if (contentRange != null) {
        final match = RegExp(r'/(\d+)$').firstMatch(contentRange);
        if (match != null) totalBytes = int.parse(match.group(1)!);
      }
    } else {
      actualOffset = 0;
      final cl = response.headers.value(Headers.contentLengthHeader);
      totalBytes = int.tryParse(cl ?? '') ?? 0;
    }

    final file = File(savePath);
    final raf = await file.open(
      mode: actualOffset > 0 ? FileMode.append : FileMode.write,
    );

    int receivedBytes = actualOffset;

    try {
      final dynamic responseData = response.data;
      await for (final chunk in responseData.stream) {
        if (cancelToken.isCancelled) break;
        final bytes = chunk as List<int>;
        await raf.writeFrom(bytes);
        receivedBytes += bytes.length;
        onProgress(receivedBytes, totalBytes);
      }
    } finally {
      await raf.close();
    }
  }
}
