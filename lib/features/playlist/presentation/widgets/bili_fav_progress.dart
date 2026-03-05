import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';

/// 导入进度 / 完成结果视图（Phase 3 & 4）。
///
/// [isCompleted] 为 `false` 时显示进度条，为 `true` 时显示导入结果。
class BiliFavProgressView extends StatelessWidget {
  const BiliFavProgressView.importing({
    super.key,
    required this.importCurrent,
    required this.importTotal,
  })  : isCompleted = false,
        resultImported = 0,
        resultReused = 0,
        resultFailed = 0,
        onConfirm = null;

  const BiliFavProgressView.completed({
    super.key,
    required this.resultImported,
    required this.resultReused,
    required this.resultFailed,
    required this.onConfirm,
  })  : isCompleted = true,
        importCurrent = 0,
        importTotal = 0;

  final bool isCompleted;

  // 导入中
  final int importCurrent;
  final int importTotal;

  // 完成
  final int resultImported;
  final int resultReused;
  final int resultFailed;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return _buildCompleted(context);
    }
    return _buildImporting(context);
  }

  Widget _buildImporting(BuildContext context) {
    final l10n = context.l10n;
    final progress = importTotal > 0 ? importCurrent / importTotal : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(value: progress > 0 ? progress : null),
            const SizedBox(height: 16),
            Text(
              l10n.importingProgress(importCurrent, importTotal),
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress > 0 ? progress : null),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleted(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.importResult(resultImported, resultReused, resultFailed),
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onConfirm,
              child: Text(l10n.confirmImport),
            ),
          ],
        ),
      ),
    );
  }
}
