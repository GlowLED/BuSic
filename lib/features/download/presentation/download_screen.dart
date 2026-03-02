import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Download management screen showing all download tasks.
///
/// Features:
/// - List of download tasks with progress bars
/// - Status filtering (all / active / completed / failed)
/// - "Clear completed" action
/// - Tap on failed tasks to retry
class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement download management screen
    // - Watch downloadNotifierProvider
    // - Handle loading/error/data states
    // - ListView of DownloadTaskTile widgets
    return const Scaffold(
      body: Center(
        child: Text('TODO: DownloadScreen'),
      ),
    );
  }
}
