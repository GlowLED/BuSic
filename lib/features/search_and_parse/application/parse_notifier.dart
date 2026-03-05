import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/bili_dio.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/logger.dart';
import '../../playlist/data/playlist_repository.dart';
import '../../playlist/data/playlist_repository_impl.dart';
import '../../auth/application/auth_notifier.dart';
import '../data/parse_repository.dart';
import '../data/parse_repository_impl.dart';
import '../domain/models/bvid_info.dart';
import '../domain/models/page_info.dart';

part 'parse_notifier.g.dart';
part 'parse_notifier.freezed.dart';

/// Possible states of the parse/search flow.
@freezed
class ParseState with _$ParseState {
  /// No active parsing operation.
  const factory ParseState.idle() = _Idle;

  /// Currently parsing a BV number.
  const factory ParseState.parsing() = _Parsing;

  /// Parsed successfully, single page — ready to add.
  const factory ParseState.success(BvidInfo info) = _Success;

  /// Parsed a multi-page video — user needs to select pages.
  const factory ParseState.selectingPages(
    BvidInfo info,
    List<PageInfo> selectedPages,
  ) = _SelectingPages;

  /// Parse failed with an error message.
  const factory ParseState.error(String message) = _Error;
}

/// State notifier managing the BV number parsing and page selection flow.
@riverpod
class ParseNotifier extends _$ParseNotifier {
  late ParseRepository _repository;
  late PlaylistRepository _playlistRepository;

  @override
  ParseState build() {
    _repository = ParseRepositoryImpl(biliDio: BiliDio());
    _playlistRepository = PlaylistRepositoryImpl(
      db: ref.read(databaseProvider),
    );
    return const ParseState.idle();
  }

  /// Parse a BV number or Bilibili URL.
  Future<void> parseInput(String input) async {
    state = const ParseState.parsing();
    try {
      final bvid = Formatters.parseBvid(input);
      if (bvid == null) {
        state = const ParseState.error('无效的BV号或链接');
        return;
      }

      final info = await _repository.getVideoInfo(bvid);
      if (info.pages.length > 1) {
        state = ParseState.selectingPages(info, List.from(info.pages));
      } else {
        state = ParseState.success(info);
      }
    } catch (e) {
      AppLogger.error('Parse failed', tag: 'Parse', error: e);
      state = ParseState.error('解析失败: $e');
    }
  }

  /// Update page selection during multi-page selection state.
  void togglePageSelection(PageInfo page) {
    final current = state;
    if (current is! _SelectingPages) return;
    final selected = List<PageInfo>.from(current.selectedPages);
    final index = selected.indexWhere((p) => p.cid == page.cid);
    if (index >= 0) {
      selected.removeAt(index);
    } else {
      selected.add(page);
    }
    state = ParseState.selectingPages(current.info, selected);
  }

  /// Select all pages.
  void selectAllPages() {
    final current = state;
    if (current is! _SelectingPages) return;
    state = ParseState.selectingPages(current.info, List.from(current.info.pages));
  }

  /// Deselect all pages.
  void deselectAllPages() {
    final current = state;
    if (current is! _SelectingPages) return;
    state = ParseState.selectingPages(current.info, []);
  }

  /// Confirm the selected pages, create song entries, and optionally add to a playlist.
  Future<List<int>> confirmSelection({int? playlistId}) async {
    final current = state;
    BvidInfo? info;
    List<PageInfo> pages;

    if (current is _Success) {
      info = current.info;
      pages = info.pages;
    } else if (current is _SelectingPages) {
      info = current.info;
      pages = current.selectedPages;
    } else {
      return [];
    }

    final songIds = <int>[];
    for (final page in pages) {
      final songId = await _playlistRepository.upsertSong(
        bvid: info.bvid,
        cid: page.cid,
        originTitle: pages.length > 1 ? page.partTitle : info.title,
        originArtist: info.owner,
        coverUrl: info.coverUrl,
        duration: page.duration,
      );
      songIds.add(songId);
    }

    if (playlistId != null && songIds.isNotEmpty) {
      await _playlistRepository.addSongsToPlaylist(playlistId, songIds);
    }

    state = const ParseState.idle();
    return songIds;
  }

  /// Search videos on Bilibili with pagination support.
  ///
  /// Returns a record containing the result list and total page count.
  Future<({List<BvidInfo> results, int numPages})> searchVideos(String keyword, {int page = 1, int pageSize = 20}) async {
    try {
      return await _repository.searchVideos(keyword, page: page, pageSize: pageSize);
    } catch (e) {
      AppLogger.error('Search failed', tag: 'Parse', error: e);
      return (results: <BvidInfo>[], numPages: 1);
    }
  }

  /// Reset to idle state.
  void reset() {
    state = const ParseState.idle();
  }
}
