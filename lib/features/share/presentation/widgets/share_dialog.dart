import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';

/// 分享方式选择弹窗
///
/// 提供「复制到剪贴板」和「生成分享链接」两种方式（在线分享暂不可用）。
class ShareDialog extends StatelessWidget {
  /// 选择分享方式后的回调
  final void Function(ShareMethod method) onSelected;

  const ShareDialog({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.sharePlaylist),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.content_copy),
            title: Text(l10n.copyToClipboard),
            subtitle: Text(l10n.offlineShare),
            onTap: () {
              Navigator.of(context).pop();
              onSelected(ShareMethod.clipboard);
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: Text(l10n.generateShareLink),
            subtitle: Text(l10n.onlineShareComingSoon),
            enabled: false, // 在线分享暂不可用
            onTap: null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}

/// 分享方式枚举
enum ShareMethod {
  /// 复制到剪贴板（离线分享）
  clipboard,

  /// 生成分享链接（在线分享）
  link,
}
