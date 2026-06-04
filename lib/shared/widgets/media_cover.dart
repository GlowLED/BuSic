import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

const _mediaCoverCacheOversample = 2.0;
const _mediaCoverMinCacheDimension = 128.0;
const _mediaCoverMaxCacheDimension = 1024.0;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cacheSize = _resolveCacheSize(context, constraints);
        Widget child = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          child: _buildImage(context, cacheSize),
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
      },
    );
  }

  Widget _buildImage(
    BuildContext context,
    ({int width, int height})? cacheSize,
  ) {
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
        filterQuality: FilterQuality.high,
        cacheWidth: cacheSize?.width,
        cacheHeight: cacheSize?.height,
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
      );
    }

    return CachedNetworkImage(
      imageUrl: cover,
      fit: fit,
      filterQuality: FilterQuality.high,
      memCacheWidth: cacheSize?.width,
      memCacheHeight: cacheSize?.height,
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

  ({int width, int height})? _resolveCacheSize(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    var displayWidth = _finiteDimension(width) ??
        (constraints.hasBoundedWidth
            ? _finiteDimension(constraints.maxWidth)
            : null);
    var displayHeight = _finiteDimension(height) ??
        (constraints.hasBoundedHeight
            ? _finiteDimension(constraints.maxHeight)
            : null);

    final ratio = aspectRatio;
    if (ratio != null && ratio > 0) {
      if (displayWidth != null && displayHeight == null) {
        displayHeight = displayWidth / ratio;
      } else if (displayHeight != null && displayWidth == null) {
        displayWidth = displayHeight * ratio;
      }
    }

    if (displayWidth == null && displayHeight == null) {
      return null;
    }

    displayWidth ??= displayHeight;
    displayHeight ??= displayWidth;
    if (displayWidth == null ||
        displayHeight == null ||
        displayWidth <= 0 ||
        displayHeight <= 0) {
      return null;
    }

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final rawWidth = displayWidth * pixelRatio * _mediaCoverCacheOversample;
    final rawHeight = displayHeight * pixelRatio * _mediaCoverCacheOversample;
    final rawMax = math.max(rawWidth, rawHeight);
    if (!rawMax.isFinite || rawMax <= 0) return null;

    final scale = rawMax < _mediaCoverMinCacheDimension
        ? _mediaCoverMinCacheDimension / rawMax
        : rawMax > _mediaCoverMaxCacheDimension
            ? _mediaCoverMaxCacheDimension / rawMax
            : 1.0;

    return (
      width: math.max(1, (rawWidth * scale).ceil()),
      height: math.max(1, (rawHeight * scale).ceil()),
    );
  }

  double? _finiteDimension(double? value) {
    if (value == null || !value.isFinite || value <= 0) return null;
    return value;
  }
}
