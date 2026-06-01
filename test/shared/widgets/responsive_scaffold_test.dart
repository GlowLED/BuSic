import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:busic/core/database/app_database.dart';
import 'package:busic/core/router/app_router.dart';
import 'package:busic/core/services/audio_handler.dart';
import 'package:busic/core/theme/app_theme.dart';
import 'package:busic/core/theme/app_theme_tokens.dart';
import 'package:busic/features/auth/application/auth_notifier.dart';
import 'package:busic/features/player/application/player_notifier.dart';
import 'package:busic/features/player/data/player_repository.dart';
import 'package:busic/features/player/domain/models/audio_track.dart';
import 'package:busic/features/player/presentation/player_bar.dart';
import 'package:busic/features/search_and_parse/data/parse_repository.dart';
import 'package:busic/features/search_and_parse/domain/models/audio_stream_info.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_folder.dart';
import 'package:busic/features/search_and_parse/domain/models/bili_fav_item.dart';
import 'package:busic/features/search_and_parse/domain/models/bvid_info.dart';
import 'package:busic/features/search_and_parse/domain/models/video_tag.dart';
import 'package:busic/features/search_and_parse/presentation/search_screen.dart';
import 'package:busic/l10n/generated/app_localizations.dart';
import 'package:busic/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('keeps desktop sidebar compact on extra-wide layouts',
      (tester) async {
    await _pumpShell(tester, const Size(1600, 900));

    expect(find.byIcon(Icons.search_outlined), findsOneWidget);
    expect(find.byIcon(Icons.download_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.text('Search'), findsNothing);
    expect(find.text('Downloads'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('uses label-only bottom navigation in mobile portrait',
      (tester) async {
    await _pumpShell(tester, const Size(390, 844));

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Downloads'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(Icons.search_outlined), findsNothing);
    expect(find.byIcon(Icons.download_outlined), findsNothing);
    expect(find.byIcon(Icons.settings_outlined), findsNothing);
  });

  testWidgets('uses static text-only selection in mobile portrait',
      (tester) async {
    await _pumpShell(tester, const Size(390, 844));

    final playlistLabel = _navLabel('Playlists');
    final searchLabel = _navLabel('Search');
    final palette =
        Theme.of(tester.element(searchLabel)).extension<AppThemePalette>()!;

    expect(
        tester.widget<Text>(playlistLabel).style?.color, palette.textPrimary);
    expect(tester.widget<Text>(searchLabel).style?.color, palette.textMuted);
    expect(tester.widget<Text>(searchLabel).style?.fontSize, 13);
    expect(tester.widget<Text>(searchLabel).style?.fontWeight, FontWeight.w600);
    expect(tester.widget<Text>(searchLabel).style?.letterSpacing, 0);
    expect(
      find.ancestor(of: searchLabel, matching: find.byType(InkWell)),
      findsNothing,
    );
    expect(
      find.ancestor(of: searchLabel, matching: find.byType(AnimatedContainer)),
      findsNothing,
    );

    await tester.tap(searchLabel);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.widget<Text>(searchLabel).style?.color, palette.textPrimary);
    expect(tester.widget<Text>(playlistLabel).style?.color, palette.textMuted);
  });

  testWidgets('uses icon-only side navigation in mobile landscape',
      (tester) async {
    await _pumpShell(tester, const Size(700, 390));

    expect(find.byIcon(Icons.search_outlined), findsOneWidget);
    expect(find.byIcon(Icons.download_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.text('Search'), findsNothing);
    expect(find.text('Downloads'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('places mobile portrait content directly above the player bar',
      (tester) async {
    await _pumpShell(tester, const Size(390, 844));

    await tester.tap(_navLabel('Search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final searchRect = tester.getRect(find.byType(SearchScreen));
    final playerRect = tester.getRect(find.byType(PlayerBar));

    expect(searchRect.bottom, closeTo(playerRect.top, 0.1));
  });

  testWidgets('places mobile landscape content directly above the player bar',
      (tester) async {
    await _pumpShell(tester, const Size(700, 390));

    await tester.tap(find.ancestor(
      of: find.byIcon(Icons.search_outlined),
      matching: find.byType(InkWell),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final searchRect = tester.getRect(find.byType(SearchScreen));
    final playerRect = tester.getRect(find.byType(PlayerBar));

    expect(searchRect.bottom, closeTo(playerRect.top, 0.1));
  });
}

Future<void> _pumpShell(WidgetTester tester, Size size) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        audioHandlerProvider.overrideWithValue(_FakeAudioHandler()),
        playerRepositoryProvider.overrideWithValue(_FakePlayerRepository()),
        playerParseRepositoryProvider.overrideWithValue(
          _FakeParseRepository(),
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          return MaterialApp.router(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme(seedColor: AppTheme.greenSeed),
            routerConfig: ref.watch(appRouterProvider),
          );
        },
      ),
    ),
  );

  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Finder _navLabel(String label) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text && widget.data == label && widget.style?.fontSize == 13,
  );
}

class _FakeAudioHandler extends BusicAudioHandler {}

class _FakePlayerRepository implements PlayerRepository {
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _playingController = StreamController<bool>.broadcast();
  final _completedController = StreamController<void>.broadcast();

  @override
  Stream<void> get completedStream => _completedController.stream;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Future<void> dispose() async {
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _completedController.close();
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> play(AudioTrack track) async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> stop() async {}
}

class _FakeParseRepository implements ParseRepository {
  @override
  Future<BvidInfo> getVideoInfo(String bvid) {
    throw UnimplementedError();
  }

  @override
  Future<({List<BvidInfo> results, int numPages})> searchVideos(
    String keyword, {
    int page = 1,
    int pageSize = 20,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<({String imgKey, String subKey})> fetchWbiKeys() {
    throw UnimplementedError();
  }

  @override
  Future<List<AudioStreamInfo>> getAvailableQualities(
    String bvid,
    int cid,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<AudioStreamInfo> getAudioStream(
    String bvid,
    int cid, {
    int? quality,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoTag>> getVideoTags(String bvid) {
    throw UnimplementedError();
  }

  @override
  Future<List<BiliFavFolder>> getFavoriteFolders(int mid) {
    throw UnimplementedError();
  }

  @override
  Future<List<BiliFavItem>> getFavoriteFolderItems(
    int mediaId, {
    void Function(int fetched, int total)? onProgress,
  }) {
    throw UnimplementedError();
  }
}
