import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Scales the complete Flutter interface while exposing a matching logical
/// viewport to responsive descendants.
class AppUiScaler extends StatelessWidget {
  const AppUiScaler({super.key, required this.scale, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if ((scale - 1).abs() < 0.0001) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          return child;
        }

        final outerSize = constraints.biggest;
        if (outerSize.isEmpty) return child;

        final logicalSize = Size(
          outerSize.width / scale,
          outerSize.height / scale,
        );
        final mediaQuery = MediaQuery.of(context);
        final scaledMediaQuery = mediaQuery.copyWith(
          size: logicalSize,
          devicePixelRatio: mediaQuery.devicePixelRatio * scale,
          padding: _scaleInsets(mediaQuery.padding),
          viewPadding: _scaleInsets(mediaQuery.viewPadding),
          viewInsets: _scaleInsets(mediaQuery.viewInsets),
          systemGestureInsets: _scaleInsets(mediaQuery.systemGestureInsets),
          displayFeatures: mediaQuery.displayFeatures
              .map(_scaleDisplayFeature)
              .toList(growable: false),
        );

        return ClipRect(
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              alignment: Alignment.topLeft,
              child: SizedBox.fromSize(
                size: logicalSize,
                child: MediaQuery(data: scaledMediaQuery, child: child),
              ),
            ),
          ),
        );
      },
    );
  }

  EdgeInsets _scaleInsets(EdgeInsets insets) => EdgeInsets.fromLTRB(
    insets.left / scale,
    insets.top / scale,
    insets.right / scale,
    insets.bottom / scale,
  );

  ui.DisplayFeature _scaleDisplayFeature(ui.DisplayFeature feature) {
    final bounds = feature.bounds;
    return ui.DisplayFeature(
      bounds: Rect.fromLTRB(
        bounds.left / scale,
        bounds.top / scale,
        bounds.right / scale,
        bounds.bottom / scale,
      ),
      type: feature.type,
      state: feature.state,
    );
  }
}
