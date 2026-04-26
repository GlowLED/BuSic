import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/page_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_interaction_state.dart';
import 'package:busic/features/search_and_parse/domain/models/video_rights.dart';
import 'package:busic/features/search_and_parse/domain/models/video_stats.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';

void main() {
  group('BvidInfo detail fields', () {
    test('keeps old minimal construction compatible', () {
      const info = BvidInfo(
        bvid: 'BV1xx411c7mD',
        title: 'Night Drive',
        owner: 'BuSic',
      );

      expect(info.aid, isNull);
      expect(info.description, isEmpty);
      expect(info.pubdate, isNull);
      expect(info.tname, isNull);
      expect(info.ownerFace, isNull);
      expect(info.stats, const VideoStats());
      expect(info.rights, const VideoRights());
      expect(info.tags, isEmpty);
    });

    test('serializes and deserializes extended video detail data', () {
      const info = BvidInfo(
        bvid: 'BV1xx411c7mD',
        aid: 123456,
        title: 'Night Drive',
        description: 'City pop mix',
        pubdate: 1710000000,
        tname: 'Music',
        owner: 'BuSic',
        ownerUid: 42,
        ownerFace: 'https://example.com/avatar.jpg',
        coverUrl: 'https://example.com/cover.jpg',
        pages: [
          PageInfo(cid: 1001, page: 1, partTitle: 'P1', duration: 245),
        ],
        duration: 245,
        stats: VideoStats(
          view: 10,
          danmaku: 2,
          reply: 3,
          favorite: 4,
          coin: 5,
          share: 6,
          like: 7,
        ),
        rights: VideoRights(noReprint: true),
        tags: [
          VideoTag(id: 1, name: 'music'),
        ],
      );

      final json = info.toJson();
      final restored = BvidInfo.fromJson(json);

      expect(restored, info);
      expect((json['stats'] as Map<String, dynamic>)['like'], 7);
      expect((json['rights'] as Map<String, dynamic>)['noReprint'], isTrue);
      expect(
        ((json['tags'] as List).single as Map<String, dynamic>)['name'],
        'music',
      );
    });
  });

  group('VideoInteractionState', () {
    test('defaults to idle inactive state', () {
      const state = VideoInteractionState();

      expect(state.isLiked, isFalse);
      expect(state.isFavorited, isFalse);
      expect(state.coinsGiven, 0);
      expect(state.isBusy, isFalse);
      expect(state.lastError, isNull);
    });
  });
}
