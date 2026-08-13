import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/media_cover.dart';
import '../../domain/models/playlist.dart';

const _playlistTileStateDuration = Duration(milliseconds: 160);
const _playlistCoverHoverDuration = Duration(milliseconds: 240);
const _playlistPaletteTransitionDuration = Duration(milliseconds: 220);
const _playlistCoverHoverScale = 1.04;
const _playlistPaletteCacheLimit = 64;
const _playlistGradientStops = <double>[0.18, 0.38, 0.56, 0.72, 0.86, 1.0];
const _playlistGradientOpacities = <double>[0, 0.08, 0.28, 0.58, 0.86, 1];

final LinkedHashMap<_PlaylistPaletteCacheKey, Future<ColorScheme?>>
_playlistPaletteCache =
    LinkedHashMap<_PlaylistPaletteCacheKey, Future<ColorScheme?>>();

@immutable
class _PlaylistPaletteCacheKey {
  const _PlaylistPaletteCacheKey(this.coverUrl, this.brightness);

  final String coverUrl;
  final Brightness brightness;

  @override
  bool operator ==(Object other) {
    return other is _PlaylistPaletteCacheKey &&
        other.coverUrl == coverUrl &&
        other.brightness == brightness;
  }

  @override
  int get hashCode => Object.hash(coverUrl, brightness);
}

Future<ColorScheme?> _loadPlaylistColorScheme(
  ImageProvider<Object> provider,
  Brightness brightness,
) async {
  try {
    return await ColorScheme.fromImageProvider(
      provider: provider,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.content,
    );
  } catch (_) {
    return null;
  }
}

Future<ColorScheme?> _resolvePlaylistColorScheme(
  String coverUrl,
  Brightness brightness,
  ImageProvider<Object> provider,
) {
  final key = _PlaylistPaletteCacheKey(coverUrl, brightness);
  final cached = _playlistPaletteCache[key];
  if (cached != null) return cached;

  if (_playlistPaletteCache.length >= _playlistPaletteCacheLimit) {
    _playlistPaletteCache.remove(_playlistPaletteCache.keys.first);
  }

  final request = _loadPlaylistColorScheme(provider, brightness);
  _playlistPaletteCache[key] = request;
  request.then((scheme) {
    if (scheme == null && identical(_playlistPaletteCache[key], request)) {
      _playlistPaletteCache.remove(key);
    }
  });
  return request;
}

Color _mutedForegroundFor(Color foreground, Color background) {
  for (var step = 0; step <= 7; step++) {
    final alpha = (0.72 + (step * 0.04)).clamp(0.0, 1.0);
    final candidate = Color.alphaBlend(
      foreground.withValues(alpha: alpha),
      background,
    );
    if (_contrastRatio(candidate, background) >= 3) {
      return candidate;
    }
  }
  return foreground;
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

/// A full-bleed, cover-first playlist tile used by the playlist library.
class PlaylistTile extends StatefulWidget {
  const PlaylistTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onLongPress,
    this.onMorePressed,
  });

  final Playlist playlist;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onMorePressed;

  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;
  ColorScheme? _coverColorScheme;
  String? _requestedCoverUrl;
  Brightness? _requestedBrightness;
  int _paletteRequestSerial = 0;

  void _setHovered(bool value) {
    if (_isHovered == value) return;
    setState(() {
      _isHovered = value;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCoverColorScheme();
  }

  @override
  void didUpdateWidget(covariant PlaylistTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playlist.coverUrl != widget.playlist.coverUrl) {
      _updateCoverColorScheme();
    }
  }

  void _updateCoverColorScheme() {
    final coverUrl = widget.playlist.coverUrl;
    final brightness = Theme.of(context).brightness;
    if (_requestedCoverUrl == coverUrl && _requestedBrightness == brightness) {
      return;
    }

    _requestedCoverUrl = coverUrl;
    _requestedBrightness = brightness;
    _coverColorScheme = null;
    final requestSerial = ++_paletteRequestSerial;
    final provider = MediaCover.imageProviderFor(coverUrl);
    if (coverUrl == null || coverUrl.isEmpty || provider == null) return;

    _resolvePlaylistColorScheme(coverUrl, brightness, provider).then((scheme) {
      if (!mounted || requestSerial != _paletteRequestSerial) return;
      setState(() {
        _coverColorScheme = scheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final spacing = context.appSpacing;
    final radii = context.appRadii;
    final depth = context.appDepth;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final hasPrimaryInteraction =
        widget.onTap != null || widget.onLongPress != null;
    final hasMoreAction =
        !widget.playlist.isFavorite && widget.onMorePressed != null;

    final bottomColor =
        _coverColorScheme?.primaryContainer ?? palette.surfacePrimary;
    final titleColor =
        _coverColorScheme?.onPrimaryContainer ?? palette.textPrimary;
    final mutedColor = _coverColorScheme == null
        ? palette.textSecondary
        : _mutedForegroundFor(titleColor, bottomColor);
    final borderColor = _isFocused
        ? palette.accentStrong
        : _isHovered
        ? palette.borderStrong
        : palette.borderSubtle;
    final borderWidth = _isFocused ? depth.outlineStrong : depth.outline;
    final stateLayerColor = _isPressed
        ? palette.overlayStrong
        : Colors.transparent;
    final stateDuration = disableAnimations
        ? Duration.zero
        : _playlistTileStateDuration;
    final paletteDuration = disableAnimations
        ? Duration.zero
        : _playlistPaletteTransitionDuration;

    return MouseRegion(
      key: const ValueKey<String>('playlist-tile-mouse-region'),
      cursor: hasPrimaryInteraction
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: hasPrimaryInteraction ? (_) => _setHovered(true) : null,
      onHover: hasPrimaryInteraction ? (_) => _setHovered(true) : null,
      onExit: hasPrimaryInteraction ? (_) => _setHovered(false) : null,
      opaque: true,
      hitTestBehavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        key: const ValueKey<String>('playlist-tile-surface'),
        duration: stateDuration,
        curve: Curves.easeOut,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: palette.surfacePrimary.withValues(
            alpha: palette.surfaceOpacity,
          ),
          borderRadius: radii.largeRadius,
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: radii.largeRadius,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const ValueKey<String>('playlist-tile-ink-well'),
            borderRadius: radii.largeRadius,
            mouseCursor: hasPrimaryInteraction
                ? SystemMouseCursors.click
                : MouseCursor.defer,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            onHover: hasPrimaryInteraction ? _setHovered : null,
            onHighlightChanged: (value) {
              if (_isPressed == value) return;
              setState(() {
                _isPressed = value;
              });
            },
            onFocusChange: (value) {
              if (_isFocused == value) return;
              setState(() {
                _isFocused = value;
              });
            },
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  key: const ValueKey<String>('playlist-tile-cover-scale'),
                  scale: !disableAnimations && _isHovered
                      ? _playlistCoverHoverScale
                      : 1,
                  duration: disableAnimations
                      ? Duration.zero
                      : _playlistCoverHoverDuration,
                  curve: Curves.easeOutCubic,
                  child: MediaCover(
                    coverUrl: widget.playlist.coverUrl,
                    borderRadius: BorderRadius.zero,
                    placeholderIcon: widget.playlist.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.library_music_rounded,
                    placeholderBackgroundColor: Color.alphaBlend(
                      palette.overlayMedium,
                      palette.surfaceSecondary,
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedContainer(
                    key: const ValueKey<String>('playlist-tile-gradient'),
                    duration: paletteDuration,
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: _playlistGradientStops,
                        colors: _playlistGradientOpacities
                            .map(
                              (opacity) =>
                                  bottomColor.withValues(alpha: opacity),
                            )
                            .toList(growable: false),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedContainer(
                    key: const ValueKey<String>('playlist-tile-state-layer'),
                    duration: stateDuration,
                    curve: Curves.easeOut,
                    color: stateLayerColor,
                  ),
                ),
                Positioned(
                  left: spacing.sm,
                  right: hasMoreAction
                      ? spacing.xs + 48 + spacing.xxs
                      : spacing.sm,
                  bottom: spacing.sm,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        key: const ValueKey<String>(
                          'playlist-tile-title-style',
                        ),
                        duration: paletteDuration,
                        curve: Curves.easeOutCubic,
                        style:
                            (context.textTheme.titleSmall ?? const TextStyle())
                                .copyWith(color: titleColor),
                        child: Text(
                          widget.playlist.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: spacing.xxs),
                      AnimatedDefaultTextStyle(
                        key: const ValueKey<String>(
                          'playlist-tile-metadata-style',
                        ),
                        duration: paletteDuration,
                        curve: Curves.easeOutCubic,
                        style:
                            (context.textTheme.bodySmall ?? const TextStyle())
                                .copyWith(color: mutedColor),
                        child: Text(
                          context.l10n.songsTotal(widget.playlist.songCount),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasMoreAction)
                  Positioned(
                    right: spacing.xs,
                    bottom: spacing.xs,
                    child: IconButton(
                      tooltip: context.l10n.moreActions,
                      onPressed: widget.onMorePressed,
                      icon: TweenAnimationBuilder<Color?>(
                        duration: paletteDuration,
                        curve: Curves.easeOutCubic,
                        tween: ColorTween(end: mutedColor),
                        builder: (context, color, _) {
                          return Icon(
                            Icons.more_horiz_rounded,
                            size: 20,
                            color: color ?? mutedColor,
                          );
                        },
                      ),
                      style: IconButton.styleFrom(
                        foregroundColor: mutedColor,
                        backgroundColor: Colors.transparent,
                        minimumSize: const Size.square(48),
                        maximumSize: const Size.square(48),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: radii.mediumRadius,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
