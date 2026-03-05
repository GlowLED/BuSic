import 'package:dio/dio.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/comment.dart';
import '../domain/models/comment_page.dart';
import 'comment_repository.dart';

/// Concrete implementation of [CommentRepository] using BiliDio.
class CommentRepositoryImpl implements CommentRepository {
  final BiliDio _biliDio;

  CommentRepositoryImpl({required BiliDio biliDio}) : _biliDio = biliDio;

  @override
  Future<CommentPage> getComments({
    required int oid,
    int mode = 2,
    int next = 0,
    int ps = 20,
  }) async {
    final response = await _biliDio.get(
      '/x/v2/reply/main',
      queryParameters: {
        'type': 1,
        'oid': oid,
        'mode': mode,
        'next': next,
        'ps': ps,
      },
    );

    final data = response.data['data'];
    if (data == null) {
      AppLogger.warning('getComments returned null data', tag: 'Comment');
      return const CommentPage(
        totalCount: 0,
        next: 0,
        isEnd: true,
        replies: [],
      );
    }

    final cursor = data['cursor'] as Map<String, dynamic>? ?? {};
    final repliesRaw = data['replies'] as List? ?? [];

    final replies = repliesRaw.map((r) => _parseComment(r)).toList();

    return CommentPage(
      totalCount: cursor['all_count'] as int? ?? 0,
      next: cursor['next'] as int? ?? 0,
      isEnd: cursor['is_end'] as bool? ?? true,
      replies: replies,
    );
  }

  @override
  Future<CommentPage> getReplies({
    required int oid,
    required int rootRpid,
    int page = 1,
    int ps = 20,
  }) async {
    final response = await _biliDio.get(
      '/x/v2/reply/reply',
      queryParameters: {
        'type': 1,
        'oid': oid,
        'root': rootRpid,
        'pn': page,
        'ps': ps,
      },
    );

    final data = response.data['data'];
    if (data == null) {
      return const CommentPage(
        totalCount: 0,
        next: 0,
        isEnd: true,
        replies: [],
      );
    }

    final page_ = data['page'] as Map<String, dynamic>? ?? {};
    final repliesRaw = data['replies'] as List? ?? [];
    final totalCount = page_['count'] as int? ?? 0;
    final currentPage = page_['num'] as int? ?? 1;
    final pageSize = page_['size'] as int? ?? ps;

    final replies = repliesRaw.map((r) => _parseComment(r)).toList();

    return CommentPage(
      totalCount: totalCount,
      next: currentPage + 1,
      isEnd: currentPage * pageSize >= totalCount,
      replies: replies,
    );
  }

  @override
  Future<Comment> addComment({
    required int oid,
    required String message,
    required String csrf,
    int? root,
    int? parent,
  }) async {
    final formData = <String, dynamic>{
      'type': 1,
      'oid': oid,
      'message': message,
      'csrf': csrf,
    };
    if (root != null) formData['root'] = root;
    if (parent != null) formData['parent'] = parent;

    final response = await _biliDio.post(
      '/x/v2/reply/add',
      data: formData,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final code = response.data['code'] as int? ?? -1;
    if (code != 0) {
      final msg = response.data['message'] as String? ?? '发送失败';
      throw Exception(msg);
    }

    final replyData = response.data['data']['reply'];
    return _parseComment(replyData);
  }

  @override
  Future<void> likeComment({
    required int oid,
    required int rpid,
    required bool like,
    required String csrf,
  }) async {
    final response = await _biliDio.post(
      '/x/v2/reply/action',
      data: {
        'type': 1,
        'oid': oid,
        'rpid': rpid,
        'action': like ? 1 : 0,
        'csrf': csrf,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final code = response.data['code'] as int? ?? -1;
    if (code != 0) {
      final msg = response.data['message'] as String? ?? '操作失败';
      throw Exception(msg);
    }
  }

  @override
  Future<int> getAidByBvid(String bvid) async {
    final response = await _biliDio.get(
      '/x/web-interface/view',
      queryParameters: {'bvid': bvid},
    );

    final data = response.data['data'];
    if (data == null) {
      throw Exception('Failed to resolve aid for $bvid');
    }
    return data['aid'] as int;
  }

  /// Parse a raw JSON comment object into a [Comment] model.
  Comment _parseComment(Map<String, dynamic> raw) {
    final member = raw['member'] as Map<String, dynamic>? ?? {};
    final content = raw['content'] as Map<String, dynamic>? ?? {};
    final childReplies = raw['replies'] as List? ?? [];

    return Comment(
      rpid: raw['rpid'] as int,
      mid: raw['mid'] as int,
      username: member['uname'] as String? ?? '',
      avatarUrl: member['avatar'] as String? ?? '',
      content: content['message'] as String? ?? '',
      ctime: raw['ctime'] as int? ?? 0,
      likeCount: raw['like'] as int? ?? 0,
      replyCount: raw['rcount'] as int? ?? 0,
      isLiked: (raw['action'] as int? ?? 0) == 1,
      replies: childReplies.map((r) => _parseComment(r as Map<String, dynamic>)).toList(),
    );
  }
}
