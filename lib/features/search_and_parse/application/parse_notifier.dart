import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/parse_repository.dart';
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
  late final ParseRepository _repository;

  @override
  ParseState build() {
    // TODO: inject repository
    return const ParseState.idle();
  }

  /// Parse a BV number or Bilibili URL.
  ///
  /// Extracts the BV number, fetches video info, and transitions to
  /// either [ParseState.success] (single page) or
  /// [ParseState.selectingPages] (multi-page).
  Future<void> parseInput(String input) async {
    // TODO: extract bvid, call repository.getVideoInfo
    // If pages.length > 1 → selectingPages
    // If pages.length == 1 → success
    throw UnimplementedError();
  }

  /// Update page selection during multi-page selection state.
  void togglePageSelection(PageInfo page) {
    // TODO: add/remove page from selectedPages list
    throw UnimplementedError();
  }

  /// Select all pages.
  void selectAllPages() {
    // TODO: set selectedPages to all pages from BvidInfo
    throw UnimplementedError();
  }

  /// Confirm the selected pages and create song entries.
  ///
  /// Returns the list of created song database IDs.
  Future<List<int>> confirmSelection() async {
    // TODO: create song entries via playlist repository for each selected page
    throw UnimplementedError();
  }

  /// Reset to idle state.
  void reset() {
    state = const ParseState.idle();
  }
}
