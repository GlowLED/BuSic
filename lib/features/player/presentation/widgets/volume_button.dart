import 'package:flutter/material.dart';

/// 音量按钮，点击弹出垂直滑块调节音量。
///
/// 仅在桌面端显示，移动端应使用系统硬件音量控制。
class VolumeButton extends StatefulWidget {
  /// 当前音量 (0.0 ~ 1.0)。
  final double volume;

  /// 音量变化回调。
  final ValueChanged<double> onChanged;

  const VolumeButton({
    super.key,
    required this.volume,
    required this.onChanged,
  });

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  final _overlayController = OverlayPortalController();
  final _link = LayerLink();

  IconData _volumeIcon(double vol) {
    if (vol <= 0) return Icons.volume_off;
    if (vol < 0.5) return Icons.volume_down;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (ctx) {
          return Stack(
            children: [
              // 点击空白区域关闭弹窗
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _overlayController.hide(),
                ),
              ),
              // 音量滑块弹窗
              CompositedTransformFollower(
                link: _link,
                targetAnchor: Alignment.topCenter,
                followerAnchor: Alignment.bottomCenter,
                offset: const Offset(0, -8),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 8),
                    child: SizedBox(
                      height: 120,
                      width: 36,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            thumbShape:
                                const RoundSliderThumbShape(
                                    enabledThumbRadius: 6),
                            overlayShape:
                                const RoundSliderOverlayShape(
                                    overlayRadius: 12),
                            activeTrackColor: colorScheme.primary,
                            inactiveTrackColor: colorScheme.primary
                                .withValues(alpha: 0.2),
                            thumbColor: colorScheme.primary,
                          ),
                          child: Slider(
                            value: widget.volume,
                            min: 0,
                            max: 1,
                            onChanged: widget.onChanged,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: IconButton(
          icon: Icon(
            _volumeIcon(widget.volume),
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: '音量 ${(widget.volume * 100).round()}%',
          visualDensity: VisualDensity.compact,
          onPressed: () {
            if (_overlayController.isShowing) {
              _overlayController.hide();
            } else {
              _overlayController.show();
            }
          },
        ),
      ),
    );
  }
}
