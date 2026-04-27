import 'package:dio/dio.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/video_interaction_state.dart';
import 'video_interaction_exception.dart';
import 'video_interaction_repository.dart';

/// Concrete implementation of [VideoInteractionRepository] using BiliDio.
class VideoInteractionRepositoryImpl implements VideoInteractionRepository {
  final BiliDio _biliDio;

  VideoInteractionRepositoryImpl({required BiliDio biliDio})
      : _biliDio = biliDio;

  @override
  Future<VideoInteractionState> getInteractionState({
    required int aid,
    required String bvid,
  }) async {
    final liked = await _readSafely(
      'read like state',
      () => _isLiked(aid: aid, bvid: bvid),
      false,
    );
    final coinsGiven = await _readSafely(
      'read coin state',
      () => _coinsGiven(aid: aid, bvid: bvid),
      0,
    );
    final favorited = await _readSafely(
      'read favorite state',
      () => _isFavorited(aid: aid),
      false,
    );

    return VideoInteractionState(
      isLiked: liked,
      isFavorited: favorited,
      coinsGiven: coinsGiven,
    );
  }

  @override
  Future<void> setLike({
    required int aid,
    required bool like,
    required String csrf,
  }) async {
    await _postInteraction(
      label: 'set video like',
      path: '/x/web-interface/archive/like',
      data: {
        'aid': aid,
        'like': like ? 1 : 2,
        'csrf': csrf,
      },
      fallbackMessage: '点赞操作失败',
    );
  }

  @override
  Future<void> addCoin({
    required int aid,
    required int multiply,
    required bool alsoLike,
    required String csrf,
  }) async {
    if (multiply < 1 || multiply > 2) {
      throw ArgumentError.value(multiply, 'multiply', 'must be 1 or 2');
    }

    await _postInteraction(
      label: 'add video coin',
      path: '/x/web-interface/coin/add',
      data: {
        'aid': aid,
        'multiply': multiply,
        'select_like': alsoLike ? 1 : 0,
        'cross_domain': 'true',
        'csrf': csrf,
      },
      fallbackMessage: '投币失败',
    );
  }

  @override
  Future<void> addToFavoriteFolder({
    required int aid,
    required int mediaId,
    required String csrf,
  }) async {
    await _postInteraction(
      label: 'add video to favorite folder',
      path: '/x/v3/fav/resource/deal',
      data: {
        'rid': aid,
        'type': 2,
        'add_media_ids': mediaId,
        'csrf': csrf,
        'platform': 'web',
      },
      fallbackMessage: '收藏失败',
    );
  }

  @override
  Future<void> recordShare({
    required int aid,
    required String bvid,
    required String csrf,
  }) async {
    await _postInteraction(
      label: 'record video share',
      path: '/x/web-interface/share/add',
      data: {
        'aid': aid,
        'bvid': bvid,
        'csrf': csrf,
        'source': 'web_normal',
      },
      fallbackMessage: '分享记录失败',
    );
  }

  Future<bool> _isLiked({
    required int aid,
    required String bvid,
  }) async {
    final response = await _biliDio.get(
      '/x/web-interface/archive/has/like',
      queryParameters: {
        'aid': aid,
        'bvid': bvid,
      },
    );
    _ensureSuccess(response.data, fallbackMessage: '获取点赞状态失败');
    return _asInt(response.data['data']) == 1;
  }

  Future<int> _coinsGiven({
    required int aid,
    required String bvid,
  }) async {
    final response = await _biliDio.get(
      '/x/web-interface/archive/coins',
      queryParameters: {
        'aid': aid,
        'bvid': bvid,
      },
    );
    _ensureSuccess(response.data, fallbackMessage: '获取投币状态失败');

    final data = _asStringMap(response.data['data']);
    return _asInt(data?['multiply']) ?? 0;
  }

  Future<bool> _isFavorited({required int aid}) async {
    final response = await _biliDio.get(
      '/x/v2/fav/video/favoured',
      queryParameters: {'aid': aid},
    );
    _ensureSuccess(response.data, fallbackMessage: '获取收藏状态失败');

    final data = _asStringMap(response.data['data']);
    return data?['favoured'] as bool? ?? false;
  }

  Future<T> _readSafely<T>(
    String label,
    Future<T> Function() read,
    T fallback,
  ) async {
    try {
      return await read();
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Failed to $label: $error',
        tag: 'VideoInteraction',
      );
      AppLogger.error(
        'Interaction state read failed',
        tag: 'VideoInteraction',
        error: error,
        stackTrace: stackTrace,
      );
      return fallback;
    }
  }

  Future<void> _postInteraction({
    required String label,
    required String path,
    required Map<String, dynamic> data,
    required String fallbackMessage,
  }) async {
    try {
      final response = await _biliDio.post(
        path,
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      _ensureSuccess(response.data, fallbackMessage: fallbackMessage);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to $label',
        tag: 'VideoInteraction',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void _ensureSuccess(
    dynamic responseData, {
    required String fallbackMessage,
  }) {
    final data = _asStringMap(responseData);
    final code = _asInt(data?['code']) ?? -1;
    if (code == 0) return;

    final message = data?['message'] as String? ??
        data?['msg'] as String? ??
        fallbackMessage;
    throw VideoInteractionException(code, message);
  }

  Map<String, dynamic>? _asStringMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry('$key', value));
    }
    return null;
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
