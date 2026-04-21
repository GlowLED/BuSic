import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Shared media cover widget that handles local files, remote images,
/// and consistent placeholder fallbacks.
class MediaCover extends StatelessWidget {
  const MediaCover({
    super.key,
    this.coverUrl,
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.music_note_rounded,
  });

  final String? coverUrl;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    Widget child = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
      ),
      child: _buildImage(context),
    );

    if (aspectRatio != null) {
      child = AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }

    if (width != null || height != null) {
      child = SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? context.appRadii.mediumRadius,
      child: child,
    );
  }

  Widget _buildImage(BuildContext context) {
    final cover = coverUrl;
    if (cover == null || cover.isEmpty) {
      return _buildPlaceholder(context);
    }

    if (_isLocalPath(cover)) {
      final path =
          cover.startsWith('file://') ? Uri.parse(cover).toFilePath() : cover;
      return Image.file(
        File(path),
        fit: fit,
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
      );
    }

    return CachedNetworkImage(
      imageUrl: cover,
      fit: fit,
      placeholder: (_, __) => _buildPlaceholder(context),
      errorWidget: (_, __, ___) => _buildPlaceholder(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final palette = context.appPalette;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.accentSoft,
            palette.surfaceSecondary,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          placeholderIcon,
          color: palette.textSecondary,
        ),
      ),
    );
  }

  bool _isLocalPath(String path) {
    return path.startsWith('/') ||
        path.startsWith('file://') ||
        RegExp(r'^[A-Za-z]:[/\\]').hasMatch(path);
  }
}
