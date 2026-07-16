import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../../../core/utils/platform_utils.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/audio_track.dart';
import 'player_favorite_button.dart';
import 'play_queue_sheet.dart';

/// Top app bar for the full player screen.
///
/// Contains back (chevron-down), favourite toggle, and queue button.
class PlayerAppBar extends ConsumerWidget {
  /// The currently playing track (nullable when nothing is playing).
  final AudioTrack? track;
  final bool? isDesktopOverride;
  final VoidCallback? onStartDragging;
  final Future<void> Function()? onMinimize;
  final Future<void> Function()? onToggleMaximize;
  final Future<void> Function()? onHideToTray;

  const PlayerAppBar({
    super.key,
    this.track,
    this.isDesktopOverride,
    this.onStartDragging,
    this.onMinimize,
    this.onToggleMaximize,
    this.onHideToTray,
  });

  bool get _showWindowControls => isDesktopOverride ?? PlatformUtils.isDesktop;

  void _handleStartDragging() {
    final callback = onStartDragging;
    if (callback != null) {
      callback();
      return;
    }
    windowManager.startDragging();
  }

  Future<void> _handleMinimize() async {
    final callback = onMinimize;
    if (callback != null) {
      await callback();
      return;
    }
    await windowManager.minimize();
  }

  Future<void> _handleToggleMaximize() async {
    final callback = onToggleMaximize;
    if (callback != null) {
      await callback();
      return;
    }
    if (await windowManager.isMaximized()) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  Future<void> _handleHideToTray() async {
    final callback = onHideToTray;
    if (callback != null) {
      await callback();
      return;
    }
    await windowManager.hide();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final showWindowControls = _showWindowControls;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: showWindowControls
                ? GestureDetector(
                    key: const ValueKey('player-window-drag-region'),
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (_) => _handleStartDragging(),
                    child: const SizedBox(height: 48),
                  )
                : const SizedBox(),
          ),
          // ❤️ Favourite button
          if (track != null)
            PlayerFavoriteButton(track: track!, inactiveColor: Colors.white),
          IconButton(
            icon: const Icon(Icons.queue_music, color: Colors.white),
            tooltip: l10n.queue,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const PlayQueueSheet(),
              );
            },
          ),
          if (showWindowControls) ...[
            _PlayerWindowButton(
              icon: Icons.horizontal_rule_rounded,
              tooltip: l10n.windowMinimize,
              onPressed: _handleMinimize,
            ),
            _PlayerWindowButton(
              icon: Icons.crop_square_rounded,
              tooltip: l10n.windowMaximizeRestore,
              onPressed: _handleToggleMaximize,
            ),
            _PlayerWindowButton(
              icon: Icons.close_rounded,
              tooltip: l10n.windowHideToTray,
              onPressed: _handleHideToTray,
              isClose: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayerWindowButton extends StatelessWidget {
  const _PlayerWindowButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isClose = false,
  });

  final IconData icon;
  final String tooltip;
  final Future<void> Function() onPressed;
  final bool isClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white, size: 19),
        hoverColor: isClose
            ? Colors.red.withValues(alpha: 0.82)
            : Colors.white.withValues(alpha: 0.14),
        splashRadius: 20,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
