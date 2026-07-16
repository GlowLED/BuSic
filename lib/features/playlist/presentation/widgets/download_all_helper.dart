import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../../download/application/download_notifier.dart';
import '../../../download/presentation/widgets/quality_select_dialog.dart';
import '../../domain/models/song_item.dart';

/// Download all uncached songs in a playlist with a user-selected quality.
Future<void> downloadAllUncached({
  required BuildContext context,
  required WidgetRef ref,
  required List<SongItem> songs,
}) async {
  final l10n = context.l10n;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final uncached = songs.where((s) => !s.isCached).toList();
  if (uncached.isEmpty) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(l10n.allSongsCached),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
    return;
  }

  try {
    final qualities = await ref
        .read(downloadNotifierProvider.notifier)
        .getAvailableQualities(
          bvid: uncached.first.bvid,
          cid: uncached.first.cid,
        );

    if (qualities.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.noQualities),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        ),
      );
      return;
    }

    if (!context.mounted) return;

    final isLoggedIn = ref.read(authNotifierProvider).value != null;

    showDialog(
      context: context,
      builder: (_) => QualitySelectDialog(
        qualities: qualities,
        isLoggedIn: isLoggedIn,
        onSelect: (selected) async {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.downloadAllStarted(uncached.length)),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
            ),
          );
          final songData = uncached
              .map(
                (s) => (
                  id: s.id,
                  bvid: s.bvid,
                  cid: s.cid,
                  title: s.displayTitle,
                  isCached: s.isCached,
                ),
              )
              .toList();
          await ref
              .read(downloadNotifierProvider.notifier)
              .downloadAllUncached(songs: songData, quality: selected.quality);
        },
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('获取音质列表失败: $e\n$stackTrace');
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(l10n.downloadAllFailed(e.toString())),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
      ),
    );
  }
}
