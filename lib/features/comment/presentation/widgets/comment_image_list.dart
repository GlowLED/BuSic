import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../domain/models/comment.dart';

void showImagePreview(BuildContext context, String url) {
  showDialog(
    context: context,
    useRootNavigator: true,
    barrierColor: Colors.black87,
    builder: (ctx) => Stack(
      children: [
        Positioned.fill(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                placeholder: (_, __) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 48,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ),
      ],
    ),
  );
}

class CommentImageList extends StatefulWidget {
  const CommentImageList({super.key, required this.images});

  final List<CommentImage> images;

  @override
  State<CommentImageList> createState() => _CommentImageListState();
}

class _CommentImageListState extends State<CommentImageList> {
  bool _expanded = false;

  bool get _allPortrait => widget.images.every((img) => img.height > img.width);

  bool get _allLandscape =>
      widget.images.every((img) => img.width >= img.height);

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    if (widget.images.length == 1) return _buildSingle(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (w <= 0) return const SizedBox.shrink();

        if (_allPortrait) return _buildPortraitRow(context, w);
        if (_allLandscape) return _buildLandscapeColumn(context, w);
        return _buildMixedGrid(context, w);
      },
    );
  }

  Widget _buildSingle(BuildContext context) {
    final img = widget.images.first;
    final aspectRatio = img.width > 0 && img.height > 0
        ? img.width / img.height
        : 1.0;

    return GestureDetector(
      onTap: () => showImagePreview(context, img.url),
      child: ClipRRect(
        borderRadius: context.appRadii.mediumRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: _buildImageWidget(img.url),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitRow(BuildContext context, double w) {
    final itemWidth = w / 3;

    double maxH = 0;
    for (final img in widget.images) {
      final h = itemWidth * img.height / img.width;
      if (h > maxH) maxH = h;
    }
    maxH = maxH.clamp(0, 300);

    return SizedBox(
      height: maxH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 4),
        itemBuilder: (_, index) {
          final img = widget.images[index];
          return GestureDetector(
            onTap: () => showImagePreview(context, img.url),
            child: ClipRRect(
              borderRadius: context.appRadii.mediumRadius,
              child: SizedBox(
                width: itemWidth,
                height: maxH,
                child: _buildImageWidget(img.url, fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLandscapeColumn(BuildContext context, double w) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < widget.images.length; i++) ...[
          if (i > 0) const SizedBox(height: 4),
          _buildLandscapeCell(context, widget.images[i], w),
        ],
      ],
    );
  }

  Widget _buildLandscapeCell(BuildContext context, CommentImage img, double w) {
    final imgWidth = img.width > 0 ? img.width : 1;
    final imgHeight = img.height > 0 ? img.height : 1;
    final h = (w * imgHeight / imgWidth).clamp(0, 250);

    return GestureDetector(
      onTap: () => showImagePreview(context, img.url),
      child: ClipRRect(
        borderRadius: context.appRadii.mediumRadius,
        child: SizedBox(
          width: w,
          height: h.toDouble(),
          child: _buildImageWidget(img.url, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildMixedGrid(BuildContext context, double w) {
    final total = widget.images.length;
    final showOverlay = total > 9 && !_expanded;
    final showCount = _expanded ? total : total.clamp(0, 9);
    final overlayRemaining = total - 9;

    final rows = <Widget>[];

    for (var i = 0; i < showCount; i += 3) {
      final rowChildren = <Widget>[];
      for (var j = i; j < i + 3 && j < showCount; j++) {
        final isOverlay = showOverlay && j == 8;
        rowChildren.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: isOverlay
                  ? _buildOverlayCell(
                      context,
                      widget.images[j],
                      overlayRemaining,
                    )
                  : _buildGridCell(context, widget.images[j]),
            ),
          ),
        );
        if (j < i + 2 && j < showCount - 1) {
          rowChildren.add(const SizedBox(width: 4));
        }
      }
      rows.add(Row(children: rowChildren));
      if (i + 3 < showCount) {
        rows.add(const SizedBox(height: 4));
      }
    }

    if (_expanded) {
      rows.add(const SizedBox(height: 4));
      rows.add(
        GestureDetector(
          onTap: () => setState(() => _expanded = false),
          child: Text(
            '收起',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildGridCell(BuildContext context, CommentImage img) {
    return GestureDetector(
      onTap: () => showImagePreview(context, img.url),
      child: ClipRRect(
        borderRadius: context.appRadii.mediumRadius,
        child: _buildImageWidget(img.url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildOverlayCell(
    BuildContext context,
    CommentImage img,
    int remaining,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = true),
      child: ClipRRect(
        borderRadius: context.appRadii.mediumRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageWidget(img.url, fit: BoxFit.cover),
            Container(color: Colors.black54),
            Center(
              child: Text(
                '+$remaining',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String url, {BoxFit fit = BoxFit.contain}) {
    final colorScheme = context.colorScheme;

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      filterQuality: FilterQuality.high,
      placeholder: (_, __) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(Icons.broken_image, color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
