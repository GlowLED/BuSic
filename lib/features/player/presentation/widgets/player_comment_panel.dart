import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_panel.dart';
import '../../../comment/presentation/comment_section.dart';
import '../../../comment/presentation/comment_section_appearance.dart';

class PlayerCommentPanel extends StatelessWidget {
  const PlayerCommentPanel({super.key, required this.bvid});

  final String bvid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appSpacing.md,
        vertical: context.appSpacing.xxs,
      ),
      child: AppPanel(
        key: const ValueKey('player-comment-panel'),
        borderRadius: context.appRadii.xLargeRadius,
        backgroundColors: [
          Colors.black.withValues(alpha: 0.42),
          Colors.black.withValues(alpha: 0.30),
        ],
        borderColor: Colors.white.withValues(alpha: 0.14),
        borderWidth: context.appDepth.outline,
        boxShadow: const [],
        blurSigma: 24,
        child: CommentSection(
          bvid: bvid,
          appearance: CommentSectionAppearance.playerOverlay,
        ),
      ),
    );
  }
}
