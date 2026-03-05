import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../application/player_notifier.dart';

/// Shows a modal bottom sheet with a volume slider.
void showVolumeSheet(BuildContext context, WidgetRef ref) {
  final l10n = context.l10n;
  showModalBottomSheet(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.volume, style: Theme.of(ctx).textTheme.titleMedium),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, _) {
              final volume = ref.watch(
                  playerNotifierProvider.select((s) => s.volume));
              return Slider(
                value: volume,
                onChanged: (v) {
                  ref.read(playerNotifierProvider.notifier).setVolume(v);
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
