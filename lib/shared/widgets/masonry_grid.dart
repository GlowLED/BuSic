import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Extent specification for a masonry tile.
typedef MasonryTileExtent = ({int span, double extentRatio});

/// A [SliverGridDelegate] that lays children out as a variable-height masonry
/// grid, optionally letting tiles span multiple columns.
///
/// Tiles are placed into the currently shortest column (or shortest adjacent
/// run of columns when spanning), so rows have uneven heights. The result is a
/// lazy, scrollable masonry that reuses the standard [SliverGrid] machinery.
class MasonryGridDelegate extends SliverGridDelegate {
  const MasonryGridDelegate({
    required this.itemExtentResolver,
    required this.childCount,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.maxCrossAxisExtent = double.infinity,
  });

  /// Resolves the column span and height/width ratio for the tile at [index].
  final MasonryTileExtent Function(int index) itemExtentResolver;

  /// Total number of tiles.
  final int childCount;

  /// Spacing between tiles along the scroll axis.
  final double mainAxisSpacing;

  /// Spacing between tiles across the scroll axis.
  final double crossAxisSpacing;

  /// Maximum width of a single column; the column count is derived from the
  /// available cross-axis extent and this value.
  final double maxCrossAxisExtent;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisExtent = constraints.crossAxisExtent;
    final maxColumns = math.max(1, (crossAxisExtent / maxCrossAxisExtent).ceil());
    final columns = math.min(maxColumns, math.max(1, childCount));
    return MasonryGridLayout(
      crossAxisCount: columns,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      crossAxisExtent: crossAxisExtent,
      childCount: childCount,
      itemExtentResolver: itemExtentResolver,
    );
  }

  @override
  bool shouldRelayout(MasonryGridDelegate oldDelegate) {
    return childCount != oldDelegate.childCount ||
        mainAxisSpacing != oldDelegate.mainAxisSpacing ||
        crossAxisSpacing != oldDelegate.crossAxisSpacing ||
        maxCrossAxisExtent != oldDelegate.maxCrossAxisExtent ||
        itemExtentResolver != oldDelegate.itemExtentResolver;
  }
}

/// A [SliverGridLayout] describing the tile positions of a [MasonryGridDelegate].
class MasonryGridLayout extends SliverGridLayout {
  MasonryGridLayout({
    required int crossAxisCount,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
    required double crossAxisExtent,
    required int childCount,
    required MasonryTileExtent Function(int index) itemExtentResolver,
  })  : _crossAxisCount = crossAxisCount,
        _mainAxisSpacing = mainAxisSpacing,
        _crossAxisSpacing = crossAxisSpacing,
        _crossAxisExtent = crossAxisExtent,
        _childCount = childCount,
        _itemExtentResolver = itemExtentResolver {
    _placements = _computePlacements();
  }

  final int _crossAxisCount;
  final double _mainAxisSpacing;
  final double _crossAxisSpacing;
  final double _crossAxisExtent;
  final int _childCount;
  final MasonryTileExtent Function(int index) _itemExtentResolver;

  late final List<SliverGridGeometry> _placements;

  List<SliverGridGeometry> _computePlacements() {
    final usable = math.max(
      0.0,
      _crossAxisExtent - (_crossAxisCount - 1) * _crossAxisSpacing,
    );
    final columnWidth = usable / _crossAxisCount;
    final columnStride = columnWidth + _crossAxisSpacing;
    final columnHeights = List<double>.filled(_crossAxisCount, 0.0);
    final result = <SliverGridGeometry>[];

    for (var i = 0; i < _childCount; i++) {
      final spec = _itemExtentResolver(i);
      final span = spec.span.clamp(1, _crossAxisCount);
      final width = span * columnWidth + (span - 1) * _crossAxisSpacing;
      final height = math.max(0.0, width * spec.extentRatio);

      final (columnStart, top) = _shortestSlot(columnHeights, span);
      result.add(
        SliverGridGeometry(
          scrollOffset: top,
          crossAxisOffset: columnStart * columnStride,
          mainAxisExtent: height,
          crossAxisExtent: width,
        ),
      );

      final bottom = top + height;
      for (var column = columnStart; column < columnStart + span; column++) {
        columnHeights[column] = bottom + _mainAxisSpacing;
      }
    }

    return result;
  }

  (int, double) _shortestSlot(List<double> columnHeights, int span) {
    var bestStart = 0;
    var bestHeight = double.infinity;
    for (var start = 0; start <= columnHeights.length - span; start++) {
      var slotHeight = 0.0;
      for (var column = start; column < start + span; column++) {
        if (columnHeights[column] > slotHeight) {
          slotHeight = columnHeights[column];
        }
      }
      if (slotHeight < bestHeight) {
        bestHeight = slotHeight;
        bestStart = start;
      }
    }
    return (bestStart, bestHeight);
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    for (var i = 0; i < _placements.length; i++) {
      final geometry = _placements[i];
      if (geometry.scrollOffset + geometry.mainAxisExtent > scrollOffset) {
        return i;
      }
    }
    return math.max(0, _placements.length - 1);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    for (var i = _placements.length - 1; i >= 0; i--) {
      if (_placements[i].scrollOffset <= scrollOffset) {
        return i;
      }
    }
    return 0;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    if (index >= _placements.length) {
      // RenderSliverGrid queries one index past the last child to detect the
      // end of the list; return a degenerate geometry for it.
      final last = _placements.last;
      return SliverGridGeometry(
        scrollOffset: last.scrollOffset + last.mainAxisExtent,
        crossAxisOffset: 0,
        mainAxisExtent: 0,
        crossAxisExtent: 0,
      );
    }
    return _placements[index];
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    if (_placements.isEmpty) return 0;
    var maxBottom = 0.0;
    for (final geometry in _placements) {
      final bottom = geometry.scrollOffset + geometry.mainAxisExtent;
      if (bottom > maxBottom) maxBottom = bottom;
    }
    return maxBottom;
  }
}