import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../search_and_parse/domain/models/bili_fav_folder.dart';
import 'bili_fav_error_view.dart';

/// 收藏夹列表视图（Phase 1）。
///
/// 纯展示组件，通过回调与父级通信。
class BiliFavFolderListView extends StatelessWidget {
  const BiliFavFolderListView({
    super.key,
    required this.folders,
    required this.isLoading,
    this.errorMessage,
    required this.onFolderTapped,
    required this.onRetry,
  });

  final List<BiliFavFolder>? folders;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<BiliFavFolder> onFolderTapped;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return BiliFavErrorView(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    final list = folders;
    if (list == null || list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            context.l10n.favFolderEmpty,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final folder = list[index];
        return ListTile(
          leading: const Icon(Icons.folder_outlined),
          title: Text(
            folder.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            context.l10n.biliFavSongCount(folder.mediaCount),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: () => onFolderTapped(folder),
        );
      },
    );
  }
}
