# BuSic — Copilot Instructions

## Project Overview

BuSic is a cross-platform Bilibili music player built with Flutter. It supports online streaming and offline download of audio from Bilibili videos, with quality selection, playlist management, and background playback. Target platforms: Linux, Windows, macOS, Android, iOS.

- **Version**: 0.1.1+2
- **License**: GPLv3
- **Language**: Dart 3.x / Flutter 3.16+
- **Minimum SDK**: Dart >=3.2.0, Flutter >=3.16.0

## Tech Stack

| Category | Technology |
|---|---|
| State Management | **Riverpod** with code generation (`@riverpod`, `@Riverpod(keepAlive: true)`) |
| Routing | **go_router** with `StatefulShellRoute` for tab-based navigation |
| Database | **Drift** (SQLite ORM) with code generation |
| Immutable Models | **Freezed** + **json_serializable** |
| HTTP Client | **Dio** wrapped in singleton `BiliDio` class |
| Media Playback | **media_kit** (mpv backend) |
| Background Playback | **audio_service** for media session / lock screen controls |
| Desktop Window | **window_manager** |
| i18n | Flutter gen_l10n (ARB files: `lib/l10n/app_en.arb`, `lib/l10n/app_zh.arb`) |

## Architecture

The codebase follows **Feature-first + Lite DDD** principles:

```
lib/
├── main.dart              # App entry: init media_kit, DB, audio_service, window
├── app.dart               # MaterialApp.router with theme, locale, go_router
├── l10n/                  # ARB localization files (en, zh)
├── core/                  # Cross-cutting infrastructure
│   ├── api/               # BiliDio singleton (Bilibili API client, cookie management)
│   ├── database/          # Drift AppDatabase, table definitions, migrations
│   ├── router/            # GoRouter config with AppRoutes constants
│   ├── services/          # BusicAudioHandler (audio_service integration)
│   ├── theme/             # AppTheme with Material 3 seed colors
│   ├── utils/             # AppLogger, formatters, platform helpers
│   └── window/            # Desktop window management
├── shared/                # Reusable UI components
│   ├── widgets/           # ResponsiveScaffold, CommonDialogs, SongTile
│   └── extensions/        # ContextExtensions (quick access: colorScheme, l10n, etc.)
└── features/              # Business feature modules
    ├── auth/              # QR code login, cookie/session management
    ├── player/            # Media playback, queue, play modes, player bar/full screen
    ├── playlist/          # Playlist CRUD, song management, reorder
    ├── search_and_parse/  # BV/URL parsing, keyword search, audio stream resolution
    ├── download/          # Download queue, progress, pause/resume, range requests
    └── settings/          # User preferences (theme, locale, quality, cache path)
```

Each feature module has up to 4 layers:
- **`domain/`** — Freezed data models and enums
- **`data/`** — Abstract repository interface + concrete implementation
- **`application/`** — Riverpod notifiers (state management and business logic)
- **`presentation/`** — Screens and widgets

## Key Patterns & Conventions

### Riverpod
- Use `@riverpod` annotation for auto-dispose notifiers (most UI-bound state).
- Use `@Riverpod(keepAlive: true)` for persistent notifiers that must survive screen disposal (e.g., `DownloadNotifier`).
- Use plain `Provider` / `StateProvider` for singletons like `downloadRepositoryProvider`, `databaseProvider`, `downloadChangeSignalProvider`.
- Cross-feature reactivity: use signal providers (e.g., `downloadChangeSignalProvider`) and `ref.watch()` to propagate state changes between features without tight coupling.
- Always `ref.invalidateSelf()` after mutations in notifiers to refresh state.

### Drift Database
- Tables are defined in `lib/core/database/tables/` as Drift `Table` classes.
- Current schema version: **2**. Migrations live in `AppDatabase.migration`.
- When adding columns, bump `schemaVersion` and add migration logic in `onUpgrade`.
- Run `dart run build_runner build --delete-conflicting-outputs` after schema changes.
- The `databaseProvider` is overridden in `main()` via `ProviderScope.overrides`.

### Freezed Models
- Domain models use `@freezed` with `const factory` constructors.
- Always include `part '*.freezed.dart'` and `part '*.g.dart'` if JSON serialization is needed.
- Runtime-only fields (not persisted) use `@Default(...)`.

### Localization (i18n)
- ARB files: `lib/l10n/app_en.arb` (template) and `lib/l10n/app_zh.arb`.
- Access via `context.l10n.keyName` (using `ContextExtensions`).
- All user-facing strings MUST be localized in both ARB files.
- Generated output: `flutter_gen/gen_l10n/app_localizations.dart`.

### HTTP / Bilibili API
- `BiliDio` is a singleton wrapping Dio with Bilibili-specific interceptors (cookies, Referer header).
- Bilibili stream URLs **expire quickly** — always re-resolve before retry/resume.
- All Bilibili API requests require `Referer: https://www.bilibili.com`.
- Cookie handling uses raw string maps (not Dart's `Cookie` class) because Bilibili's `SESSDATA` contains commas.

### Downloads
- Downloads use Dio stream mode (`ResponseType.stream`) with manual `RandomAccessFile` writes for range-based resume support.
- Partial files are preserved on pause; `Range: bytes={offset}-` header enables resume.
- Download tasks store `quality` in the database to resume with the correct audio quality.
- The `DownloadNotifier` is keep-alive to detect completed downloads regardless of which screen is active.

### Navigation
- `go_router` with `StatefulShellRoute.indexedStack` for 4 bottom tabs: Playlists, Search, Downloads, Settings.
- Nested route: playlist detail is `/playlists/:id` inside the home branch.
- Standalone routes (outside shell): `/login`, `/player`.
- Route constants in `AppRoutes` abstract class.

### Theme
- Material 3 with `ColorScheme.fromSeed()`.
- 10 seed color presets in `AppTheme`.
- User-selectable theme seed stored in settings.
- Light/Dark/System theme mode support.

### Logging
- Use `AppLogger.info()`, `.warning()`, `.error()` with a `tag` parameter.
- Logs are debug-only (suppressed in release builds).

### UI Conventions
- Use `context.colorScheme`, `context.textTheme`, `context.l10n` via `ContextExtensions`.
- Use `context.showSnackBar()` for user notifications (pre-configured floating style).
- `ResponsiveScaffold` adapts: desktop shows sidebar, mobile shows bottom navigation.
- Prefer `const` constructors and widgets where possible.

## Code Generation

After modifying any `@riverpod`, `@freezed`, `@DriftDatabase`, or Drift table:

```bash
dart run build_runner build --delete-conflicting-outputs
```

If outputs are stale (e.g., schema changes not detected):

```bash
dart run build_runner clean && dart run build_runner build --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `*.freezed.dart`) are excluded from lint analysis via `analysis_options.yaml`.

## Build Commands

```bash
# Linux release
flutter build linux --release

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## Lint Rules

Key enforced rules (see `analysis_options.yaml`):
- `prefer_const_constructors`
- `prefer_const_declarations`
- `avoid_print` (use `AppLogger` instead)
- `prefer_single_quotes`
- `sort_child_properties_last`
- `use_build_context_synchronously`

## Important Notes for AI Assistants

1. **Always localize** — Never hardcode user-facing strings. Add entries to both `app_en.arb` and `app_zh.arb`.
2. **Regenerate after schema/model changes** — Run `build_runner` after touching Drift tables, Freezed models, or Riverpod notifiers.
3. **B站 URLs expire** — When implementing retry/resume, always re-resolve the audio stream URL via `ParseRepository.getAudioStream()`.
4. **Database migrations** — When adding/removing columns, bump `schemaVersion` and write `onUpgrade` logic. Never break existing user databases.
5. **Keep-alive awareness** — Understand the difference between auto-dispose (default `@riverpod`) and keep-alive (`@Riverpod(keepAlive: true)`) notifiers. Misusing auto-dispose for background tasks causes state loss.
6. **Cross-feature signaling** — Use `downloadChangeSignalProvider` pattern (increment + `ref.watch`) for decoupled reactivity instead of direct invalidation across feature boundaries.
7. **Platform awareness** — Use `PlatformUtils.isDesktop` / `PlatformUtils.isMobile` for platform-specific logic. Desktop uses `window_manager`; mobile uses `audio_service` for background playback.
8. **Single quotes** — The project enforces `prefer_single_quotes`.