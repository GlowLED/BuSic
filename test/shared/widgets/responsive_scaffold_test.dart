import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
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

  testWidgets('keeps desktop sidebar compact on extra-wide layouts', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(1600, 900));

    expect(find.byIcon(Icons.search_outlined), findsOneWidget);
    expect(find.byIcon(Icons.download_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.text('Search'), findsNothing);
    expect(find.text('Downloads'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('uses click cursor for desktop sidebar destinations', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(1600, 900));

    final searchItem = find.ancestor(
      of: find.byIcon(Icons.search_outlined),
      matching: find.byType(InkWell),
    );
    final inkWell = tester.widget<InkWell>(searchItem);

    expect(inkWell.mouseCursor, SystemMouseCursors.click);
  });

  testWidgets('uses label-only bottom navigation in mobile portrait', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(390, 844));

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Downloads'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.byIcon(Icons.search_outlined), findsNothing);
    expect(find.byIcon(Icons.download_outlined), findsNothing);
    expect(find.byIcon(Icons.settings_outlined), findsNothing);
  });

  testWidgets('uses static text-only selection in mobile portrait', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(390, 844));

    final playlistLabel = _navLabel('Playlists');
    final searchLabel = _navLabel('Search');
    final palette = Theme.of(
      tester.element(searchLabel),
    ).extension<AppThemePalette>()!;

    expect(
      tester.widget<Text>(playlistLabel).style?.color,
      palette.textPrimary,
    );
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

  testWidgets('uses icon-only side navigation in mobile landscape', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(700, 390));

    expect(find.byIcon(Icons.search_outlined), findsOneWidget);
    expect(find.byIcon(Icons.download_outlined), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.text('Search'), findsNothing);
    expect(find.text('Downloads'), findsNothing);
    expect(find.text('Settings'), findsNothing);
  });

  testWidgets('keeps desktop content close to the compact player bar', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(1000, 800));

    await tester.tap(
      find.ancestor(
        of: find.byIcon(Icons.search_outlined),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final searchRect = tester.getRect(find.byType(SearchScreen));
    final playerRect = tester.getRect(find.byType(PlayerBar));

    expect(playerRect.height, closeTo(64, 0.1));
    expect(playerRect.top - searchRect.bottom, closeTo(8, 0.1));
  });

  testWidgets('places mobile portrait content directly above the player bar', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(390, 844));

    await tester.tap(_navLabel('Search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final searchRect = tester.getRect(find.byType(SearchScreen));
    final playerRect = tester.getRect(find.byType(PlayerBar));

    expect(playerRect.height, closeTo(48, 0.1));
    expect(searchRect.bottom, closeTo(playerRect.top, 0.1));
  });

  testWidgets('keeps mobile portrait bottom chrome fixed above keyboard', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(390, 844));

    await tester.tap(_navLabel('Search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final playerBefore = tester.getRect(find.byType(PlayerBar));
    final navBefore = tester.getRect(_navLabel('Search'));

    await tester.tap(find.byType(TextField));
    await tester.pump();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pump();

    final playerAfter = tester.getRect(find.byType(PlayerBar));
    final navAfter = tester.getRect(_navLabel('Search'));

    expect(playerAfter.top, closeTo(playerBefore.top, 0.1));
    expect(playerAfter.bottom, closeTo(playerBefore.bottom, 0.1));
    expect(navAfter.top, closeTo(navBefore.top, 0.1));
    expect(navAfter.bottom, closeTo(navBefore.bottom, 0.1));
  });

  testWidgets('places mobile landscape content directly above the player bar', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(700, 390));

    await tester.tap(
      find.ancestor(
        of: find.byIcon(Icons.search_outlined),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final searchRect = tester.getRect(find.byType(SearchScreen));
    final playerRect = tester.getRect(find.byType(PlayerBar));

    expect(playerRect.height, closeTo(64, 0.1));
    expect(searchRect.bottom, closeTo(playerRect.top, 0.1));
  });

  testWidgets('renders background image layer with blur when path is set', (
    tester,
  ) async {
    final imagePath = _writeTempPng();
    await _pumpShell(
      tester,
      const Size(1000, 800),
      prefs: {
        'background_image_path': imagePath,
        'background_image_opacity': 0.5,
        'background_image_blur': 12.0,
      },
    );

    expect(find.byType(ImageFiltered), findsOneWidget);
    expect(find.byType(Image), findsWidgets);

    // opacity 0.5 -> surfaceOpacity 0.9 - 0.35*0.5 = 0.725, applied to
    // the shell player bar surface.
    final palette = Theme.of(
      tester.element(find.byType(PlayerBar)),
    ).extension<AppThemePalette>()!;
    expect(palette.surfaceOpacity, closeTo(0.725, 0.001));
  });

  testWidgets('skips blur pipeline when background blur is zero', (
    tester,
  ) async {
    final imagePath = _writeTempPng();
    await _pumpShell(
      tester,
      const Size(1000, 800),
      prefs: {
        'background_image_path': imagePath,
        'background_image_opacity': 0.8,
        'background_image_blur': 0.0,
      },
    );

    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('keeps background decode key stable while the window resizes', (
    tester,
  ) async {
    final imagePath = _writeTempPng();
    await _pumpShell(
      tester,
      const Size(1000, 800),
      prefs: {
        'background_image_path': imagePath,
        'background_image_opacity': 0.5,
        'background_image_blur': 0.0,
      },
    );

    ResizeImage backgroundProvider() => tester
        .widgetList<Image>(find.byType(Image))
        .map((widget) => widget.image)
        .whereType<ResizeImage>()
        .first;
    Image backgroundImage() => tester
        .widgetList<Image>(find.byType(Image))
        .firstWhere((widget) => widget.image is ResizeImage);

    // The background layer must decode with ResizeImagePolicy.fit so the
    // source keeps its intrinsic aspect ratio instead of being stretched to
    // the window's aspect ratio (default exact policy).
    final firstProvider = backgroundProvider();
    final firstKey = await firstProvider.obtainKey(ImageConfiguration.empty);

    expect(firstProvider.policy, ResizeImagePolicy.fit);
    expect(firstProvider.width, 1024);
    expect(firstProvider.height, 1024);
    expect(backgroundImage().gaplessPlayback, isTrue);

    tester.view.physicalSize = const Size(1200, 760);
    await tester.pump();

    final resizedProvider = backgroundProvider();
    final resizedKey = await resizedProvider.obtainKey(
      ImageConfiguration.empty,
    );

    expect(resizedKey, firstKey);
    expect(resizedProvider.width, firstProvider.width);
    expect(resizedProvider.height, firstProvider.height);
    expect(backgroundImage().gaplessPlayback, isTrue);
  });

  testWidgets('shows only the theme gradient without a background image', (
    tester,
  ) async {
    await _pumpShell(tester, const Size(1000, 800));

    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.byType(Image), findsNothing);

    // Without a background image surfaces stay fully opaque.
    final palette = Theme.of(
      tester.element(find.byType(PlayerBar)),
    ).extension<AppThemePalette>()!;
    expect(palette.surfaceOpacity, 1.0);
  });
}

/// Writes a 1x1 transparent PNG to a temp file and returns its path.
String _writeTempPng() {
  final dir = Directory.systemTemp.createTempSync('busic_bg_test_');
  addTearDown(() {
    try {
      dir.deleteSync(recursive: true);
    } catch (_) {}
  });
  final file = File(p.join(dir.path, 'bg.png'));
  file.writeAsBytesSync(_kTransparentPngBytes);
  return file.path;
}

/// Minimal valid 1x1 transparent PNG.
const _kTransparentPngBytes = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, //
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, //
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62, 0x00, 0x01, 0x00, 0x00, //
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, //
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

Future<void> _pumpShell(
  WidgetTester tester,
  Size size, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(db.close);

  // Mirror the surfaceOpacity mapping used by app.dart: a background image
  // makes component surfaces translucent, floored for readability.
  final backgroundPath = prefs['background_image_path'] as String?;
  final backgroundOpacity =
      (prefs['background_image_opacity'] as num?)?.toDouble() ?? 0;
  final hasBackground =
      backgroundPath != null &&
      backgroundPath.isNotEmpty &&
      backgroundOpacity > 0;
  final surfaceOpacity = hasBackground
      ? (0.9 - 0.35 * backgroundOpacity).clamp(0.55, 0.9)
      : 1.0;

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        audioHandlerProvider.overrideWithValue(_FakeAudioHandler()),
        playerRepositoryProvider.overrideWithValue(_FakePlayerRepository()),
        playerParseRepositoryProvider.overrideWithValue(_FakeParseRepository()),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          return MaterialApp.router(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme(
              seedColor: AppTheme.greenSeed,
              surfaceOpacity: surfaceOpacity,
            ),
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
  Future<List<AudioStreamInfo>> getAvailableQualities(String bvid, int cid) {
    throw UnimplementedError();
  }

  @override
  Future<AudioStreamInfo> getAudioStream(String bvid, int cid, {int? quality}) {
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
  Future<List<BiliFavFolder>> getCollectedFavoriteFolders(
    int mid, {
    int page = 1,
    int pageSize = 20,
  }) {
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
