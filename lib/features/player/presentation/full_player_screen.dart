import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/context_extensions.dart';
import '../../comment/presentation/comment_section.dart';
import '../application/player_notifier.dart';
import 'widgets/cover_image.dart';
import 'widgets/player_app_bar.dart';
import 'widgets/player_controls.dart';
import 'widgets/player_seek_bar.dart';

/// Full-screen player view with large cover art, comments, and controls.
///
/// Swipe left/right to switch between cover art and the comment section.
class FullPlayerScreen extends ConsumerStatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  ConsumerState<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends ConsumerState<FullPlayerScreen> {
  /// Page controller for cover ↔ comments switching.
  final _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;
    final screenSize = MediaQuery.sizeOf(context);
    final isWide = screenSize.width > screenSize.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background
          if (track?.coverUrl != null)
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: _buildBackground(track!.coverUrl!),
            ),

          // Content
          SafeArea(
            child: isWide ? _buildWideLayout() : _buildPortraitLayout(),
          ),
        ],
      ),
    );
  }

  // ── Portrait layout ──────────────────────────────────────────────

  Widget _buildPortraitLayout() {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;

    return Column(
      children: [
        PlayerAppBar(track: track),

        // PageView: Cover Art ↔ Comments
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPageIndex = i),
            children: [
              _buildCoverPage(context, track),
              _buildCommentPage(context, track?.bvid),
            ],
          ),
        ),

        // Page indicator
        _buildPageIndicator(),

        // Seek bar & controls
        const PlayerSeekBar(),
        const SizedBox(height: 8),
        const PlayerControls(),
        const SizedBox(height: 32),
      ],
    );
  }

  // ── Wide (landscape) layout ──────────────────────────────────────

  Widget _buildWideLayout() {
    final playerState = ref.watch(playerNotifierProvider);
    final track = playerState.currentTrack;
    final l10n = context.l10n;

    return Column(
      children: [
        PlayerAppBar(track: track),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Cover art
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: buildCoverImage(context, track?.coverUrl),
                      ),
                    ),
                  ),
                ),
              ),
              // Right: Info + controls
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            track?.title ?? l10n.unknownTitle,
                            style: context.textTheme.headlineSmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            track?.artist ?? l10n.unknownArtist,
                            style: context.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white70),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 24),
                          const PlayerSeekBar(),
                          const SizedBox(height: 16),
                          const PlayerControls(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Shared helpers ──────────────────────────────────────────────

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildDot(0), const SizedBox(width: 8), _buildDot(1)],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _currentPageIndex == index ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            _currentPageIndex == index ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildCoverPage(BuildContext context, dynamic track) {
    final l10n = context.l10n;
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: buildCoverImage(context, track?.coverUrl),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                track?.title ?? l10n.unknownTitle,
                style: context.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                track?.artist ?? l10n.unknownArtist,
                style: context.textTheme.bodyLarge
                    ?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildCommentPage(BuildContext context, String? bvid) {
    if (bvid == null) {
      return Center(
        child: Text(
          context.l10n.noPlayingMusic,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: CommentSection(bvid: bvid),
      ),
    );
  }

  Widget _buildBackground(String coverUrl) {
    return buildCoverImage(
      context,
      coverUrl,
      colorOverlay: Colors.black54,
      blendMode: BlendMode.darken,
    );
  }
}
