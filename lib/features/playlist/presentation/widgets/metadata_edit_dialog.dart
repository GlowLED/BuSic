import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/song_item.dart';

/// Dialog for editing song metadata (title, artist, cover).
///
/// Shows current values and allows the user to override them.
/// Changes are saved via the playlist notifier.
class MetadataEditDialog extends ConsumerStatefulWidget {
  /// The song whose metadata is being edited.
  final SongItem song;

  const MetadataEditDialog({super.key, required this.song});

  @override
  ConsumerState<MetadataEditDialog> createState() => _MetadataEditDialogState();
}

class _MetadataEditDialogState extends ConsumerState<MetadataEditDialog> {
  // TODO: TextEditingControllers for title, artist, coverUrl

  @override
  Widget build(BuildContext context) {
    // TODO: implement metadata edit form
    // - TextField for custom title (placeholder: originTitle)
    // - TextField for custom artist (placeholder: originArtist)
    // - Optional cover URL input
    // - Save / Cancel / Reset buttons
    return const AlertDialog(
      title: Text('TODO: MetadataEditDialog'),
    );
  }
}
