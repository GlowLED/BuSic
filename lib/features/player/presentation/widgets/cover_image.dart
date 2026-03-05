import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';

/// 构建封面图片 Widget。
///
/// 支持本地文件路径（`/` 或 `file://` 开头）、网络 URL 和空值占位。
///
/// 可选参数 [colorOverlay] 和 [blendMode] 用于在图片上叠加颜色
/// （例如模糊背景使用 `Colors.black54` + `BlendMode.darken`）。
Widget buildCoverImage(
  BuildContext context,
  String? coverUrl, {
  Color? colorOverlay,
  BlendMode? blendMode,
}) {
  if (coverUrl == null || coverUrl.isEmpty) {
    return Container(
      color: context.colorScheme.primaryContainer,
      child: const Icon(Icons.music_note, size: 24),
    );
  }

  final isLocal = coverUrl.startsWith('/') || coverUrl.startsWith('file://');
  if (isLocal) {
    final path = coverUrl.startsWith('file://')
        ? Uri.parse(coverUrl).toFilePath()
        : coverUrl;
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      color: colorOverlay,
      colorBlendMode: blendMode,
      errorBuilder: (_, __, ___) => Container(
        color: context.colorScheme.primaryContainer,
        child: const Icon(Icons.music_note, size: 24),
      ),
    );
  }

  return CachedNetworkImage(
    imageUrl: coverUrl,
    fit: BoxFit.cover,
    color: colorOverlay,
    colorBlendMode: blendMode,
    errorWidget: (_, __, ___) => Container(
      color: context.colorScheme.primaryContainer,
      child: const Icon(Icons.music_note, size: 24),
    ),
  );
}
