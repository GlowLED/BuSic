import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/bvid_info.dart';
import '../../domain/models/page_info.dart';

/// Dialog for selecting specific pages from a multi-page Bilibili video.
///
/// Displays:
/// - Video title and cover
/// - Checkbox list of all pages with title and duration
/// - "Select All" toggle
/// - Confirm / Cancel buttons
class MultiPageDialog extends ConsumerWidget {
  /// The parsed video info containing the page list.
  final BvidInfo videoInfo;

  /// Currently selected pages.
  final List<PageInfo> selectedPages;

  const MultiPageDialog({
    super.key,
    required this.videoInfo,
    required this.selectedPages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement multi-page selection dialog
    // - ScrollableList of CheckboxListTile for each page
    // - Header with video info
    // - Footer with select all + confirm/cancel
    return const AlertDialog(
      title: Text('TODO: MultiPageDialog'),
    );
  }
}
