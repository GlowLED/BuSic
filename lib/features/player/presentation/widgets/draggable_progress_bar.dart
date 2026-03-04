import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';

/// 可拖动进度条组件。
///
/// 支持：
/// - 点击跳转进度
/// - 水平拖动预览（虚线显示目标进度）
/// - 松手确认跳转（虚线变实线）
/// - 上滑取消跳转（虚线变灰色表示取消）
class DraggableProgressBar extends StatefulWidget {
  /// 当前播放进度 (0.0 ~ 1.0)。
  final double progress;

  /// 当前曲目总时长。
  final Duration duration;

  /// 跳转到指定位置的回调。
  final ValueChanged<Duration> onSeek;

  const DraggableProgressBar({
    super.key,
    required this.progress,
    required this.duration,
    required this.onSeek,
  });

  @override
  State<DraggableProgressBar> createState() => _DraggableProgressBarState();
}

class _DraggableProgressBarState extends State<DraggableProgressBar> {
  /// 是否正在拖动（已超过移动阈值）。
  bool _isDragging = false;

  /// 拖动目标进度 (0.0 ~ 1.0)。
  double _dragValue = 0.0;

  /// 上滑超过阈值时标记为取消。
  bool _isCancelled = false;

  /// 指针按下时的全局位置，用于计算上滑偏移。
  Offset? _pointerStartGlobal;

  /// 视为"仅点击"的最大移动量（像素）。
  static const double _tapThreshold = 8.0;

  /// 上滑取消的垂直阈值（像素）。
  static const double _cancelThreshold = 30.0;

  double _clampProgress(double dx, double width) {
    if (width <= 0) return 0.0;
    return (dx / width).clamp(0.0, 1.0);
  }

  Offset _toLocal(PointerEvent event) {
    final box = context.findRenderObject() as RenderBox;
    return box.globalToLocal(event.position);
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerStartGlobal = event.position;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointerStartGlobal == null) return;
    final local = _toLocal(event);
    final width = context.size?.width ?? 0;
    // 正值 = 向上拖动
    final verticalDelta = _pointerStartGlobal!.dy - event.position.dy;

    if (!_isDragging) {
      final totalMove = (event.position - _pointerStartGlobal!).distance;
      if (totalMove > _tapThreshold) {
        setState(() {
          _isDragging = true;
          _dragValue = _clampProgress(local.dx, width);
          _isCancelled = verticalDelta > _cancelThreshold;
        });
      }
      return;
    }

    setState(() {
      _dragValue = _clampProgress(local.dx, width);
      _isCancelled = verticalDelta > _cancelThreshold;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_pointerStartGlobal == null) return;

    final local = _toLocal(event);
    final width = context.size?.width ?? 0;

    if (!_isDragging) {
      // 未超过移动阈值 → 视为点击跳转
      if (widget.duration.inMilliseconds > 0 && width > 0) {
        final value = _clampProgress(local.dx, width);
        widget.onSeek(Duration(
          milliseconds: (value * widget.duration.inMilliseconds).toInt(),
        ));
      }
    } else if (!_isCancelled) {
      // 拖动结束且未取消 → 跳转到拖动位置
      if (widget.duration.inMilliseconds > 0) {
        widget.onSeek(Duration(
          milliseconds: (_dragValue * widget.duration.inMilliseconds).toInt(),
        ));
      }
    }
    // 取消状态 → 不跳转
    _reset();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _reset();
  }

  void _reset() {
    setState(() {
      _isDragging = false;
      _isCancelled = false;
      _dragValue = 0.0;
      _pointerStartGlobal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: CustomPaint(
        painter: _ProgressBarPainter(
          progress: widget.progress,
          isDragging: _isDragging,
          dragValue: _dragValue,
          isCancelled: _isCancelled,
          activeColor: context.colorScheme.primary,
          inactiveColor:
              context.colorScheme.primary.withValues(alpha: 0.2),
          cancelledColor:
              context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

/// 进度条渲染器，支持实线与虚线两种模式。
///
/// 三种视觉状态：
/// - **未拖动**：实线显示当前进度
/// - **拖动中（未取消）**：虚线预览到拖动位置 + 圆点指示
/// - **拖动中（已取消）**：灰色虚线显示拖动位置（表示取消）
class _ProgressBarPainter extends CustomPainter {
  final double progress;
  final bool isDragging;
  final double dragValue;
  final bool isCancelled;
  final Color activeColor;
  final Color inactiveColor;
  final Color cancelledColor;

  const _ProgressBarPainter({
    required this.progress,
    required this.isDragging,
    required this.dragValue,
    required this.isCancelled,
    required this.activeColor,
    required this.inactiveColor,
    required this.cancelledColor,
  });

  static const double _trackHeight = 2.0;
  static const double _dashWidth = 4.0;
  static const double _dashGap = 3.0;
  static const double _thumbRadius = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    const y = 0.0;
    final trackRect = Rect.fromLTWH(0, y, size.width, _trackHeight);
    const radius = Radius.circular(1);

    // 1. 背景轨道（不活跃）
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, radius),
      Paint()..color = inactiveColor,
    );

    if (!isDragging) {
      // 2a. 未拖动：实线活跃轨道
      final activeWidth = size.width * progress.clamp(0.0, 1.0);
      if (activeWidth > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, y, activeWidth, _trackHeight),
            radius,
          ),
          Paint()..color = activeColor,
        );
      }
    } else if (isCancelled) {
      // 2b. 拖动中 + 已取消：灰色虚线 + 灰色圆点
      final dragWidth = size.width * dragValue.clamp(0.0, 1.0);
      _drawDashed(canvas, y, dragWidth, cancelledColor);
      _drawThumb(canvas, dragWidth, y, cancelledColor);
    } else {
      // 2c. 拖动中 + 未取消：活跃虚线预览 + 活跃圆点
      final dragWidth = size.width * dragValue.clamp(0.0, 1.0);
      _drawDashed(canvas, y, dragWidth, activeColor);
      _drawThumb(canvas, dragWidth, y, activeColor);
    }
  }

  /// 绘制虚线轨道。
  void _drawDashed(Canvas canvas, double y, double width, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    double x = 0;
    while (x < width) {
      final segmentWidth =
          (x + _dashWidth > width) ? width - x : _dashWidth;
      canvas.drawRect(
        Rect.fromLTWH(x, y, segmentWidth, _trackHeight),
        paint,
      );
      x += _dashWidth + _dashGap;
    }
  }

  /// 绘制圆形拖动指示点。
  void _drawThumb(Canvas canvas, double x, double y, Color color) {
    final cx = x.clamp(_thumbRadius, double.infinity);
    canvas.drawCircle(
      Offset(cx, y + _trackHeight / 2),
      _thumbRadius,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        isDragging != oldDelegate.isDragging ||
        dragValue != oldDelegate.dragValue ||
        isCancelled != oldDelegate.isCancelled ||
        activeColor != oldDelegate.activeColor;
  }
}
