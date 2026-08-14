import 'package:flutter/material.dart';

import '../../core/utils/platform_utils.dart';

/// 桌面端提供文本选择（复制）能力，移动端退化为普通 child。
///
/// `SelectionArea` 会包一层文本选择处理，移动端逐字词选择开销较高且
/// 很少使用，这里仅在桌面端启用，避免拖慢评论/回复/视频详情等长列表。
class DesktopSelectionArea extends StatelessWidget {
  const DesktopSelectionArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!PlatformUtils.isDesktop) return child;
    return SelectionArea(child: child);
  }
}
