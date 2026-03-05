import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../player/application/player_notifier.dart';
import '../../application/subtitle_notifier.dart';
import '../../domain/models/subtitle_data.dart';

/// Lyrics display panel with auto-scrolling and tap-to-seek.
///
/// Shows subtitle lines synchronized with the current playback position.
/// The current line is highlighted and auto-scrolled to center.
/// Tapping a line seeks playback to that line's start time.
class LyricsPanel extends ConsumerStatefulWidget {
  final String bvid;
  final int cid;

  const LyricsPanel({
    required this.bvid,
    required this.cid,
    super.key,
  });

  @override
  ConsumerState<LyricsPanel> createState() => _LyricsPanelState();
}

class _LyricsPanelState extends ConsumerState<LyricsPanel> {
  final ScrollController _scrollController = ScrollController();

  /// Whether the user is manually scrolling (pause auto-scroll).
  bool _userScrolling = false;

  /// Timer to resume auto-scroll after user stops scrolling.
  Timer? _resumeTimer;

  /// Estimated height per lyrics line for scroll offset calculation.
  static const double _itemHeight = 54.0;

  @override
  void dispose() {
    _scrollController.dispose();
    _resumeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtitleState = ref.watch(
      subtitleNotifierProvider(widget.bvid, widget.cid),
    );
    final position = ref.watch(
      playerNotifierProvider.select((s) => s.position),
    );

    // Update current line based on playback position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(
            subtitleNotifierProvider(widget.bvid, widget.cid).notifier,
          )
          .updatePosition(position);
    });

    return switch (subtitleState.status) {
      SubtitleLoadStatus.loading => _buildLoading(context),
      SubtitleLoadStatus.notFound => _buildNoLyrics(context),
      SubtitleLoadStatus.error =>
        _buildError(context, subtitleState.errorMessage),
      SubtitleLoadStatus.loaded => _buildLyrics(context, subtitleState),
      SubtitleLoadStatus.idle => const SizedBox.shrink(),
    };
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.lyricsLoading,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNoLyrics(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.noLyrics,
        style: const TextStyle(color: Colors.white38, fontSize: 16),
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    final errorText =
        message == SubtitleNotifier.loginRequiredErrorCode
            ? context.l10n.pleaseLoginFirst
            : context.l10n.lyricsError;

    return Center(
      child: Text(
        errorText,
        style: const TextStyle(color: Colors.white38, fontSize: 16),
      ),
    );
  }

  Widget _buildLyrics(
    BuildContext context,
    ({
      SubtitleData? subtitleData,
      int currentLineIndex,
      SubtitleLoadStatus status,
      String? errorMessage,
    }) state,
  ) {
    final lines = state.subtitleData!.lines;
    final currentIndex = state.currentLineIndex;

    // Auto-scroll to current line
    if (!_userScrolling && currentIndex >= 0 && _scrollController.hasClients) {
      _scrollToIndex(currentIndex);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification) {
          if (notification.direction != ScrollDirection.idle) {
            _userScrolling = true;
            _resumeTimer?.cancel();
          } else {
            // Resume auto-scroll 3 seconds after user stops
            _resumeTimer?.cancel();
            _resumeTimer = Timer(const Duration(seconds: 3), () {
              if (mounted) {
                setState(() => _userScrolling = false);
              }
            });
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 120),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          final isCurrent = index == currentIndex;
          return GestureDetector(
            onTap: () => _seekToLine(line.startTime),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              child: Text(
                line.content,
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.white38,
                  fontSize: isCurrent ? 20 : 16,
                  fontWeight:
                      isCurrent ? FontWeight.bold : FontWeight.normal,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  void _seekToLine(double startTime) {
    ref.read(playerNotifierProvider.notifier).seekTo(
          Duration(milliseconds: (startTime * 1000).round()),
        );
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final targetOffset = index * _itemHeight;
    final viewportHeight = _scrollController.position.viewportDimension;
    final centeredOffset = targetOffset - viewportHeight / 2 + _itemHeight / 2;

    _scrollController.animateTo(
      centeredOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
