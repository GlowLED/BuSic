import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../search_and_parse/domain/models/audio_stream_info.dart';

/// Dialog to select audio quality before downloading.
///
/// Shows available qualities returned by the API.
/// Qualities requiring login (>=30280) are filtered out when not logged in.
/// Dolby/Hi-Res show a "大会员" badge for info.
class QualitySelectDialog extends StatelessWidget {
  final List<AudioStreamInfo> qualities;
  final bool isLoggedIn;
  final void Function(AudioStreamInfo selected) onSelect;

  const QualitySelectDialog({
    super.key,
    required this.qualities,
    required this.isLoggedIn,
    required this.onSelect,
  });

  /// Filter qualities based on login status.
  /// Non-logged-in users can only see free qualities (64kbps, 132kbps).
  List<AudioStreamInfo> get _filteredQualities {
    if (isLoggedIn) return qualities;
    const freeQualities = {30216, 30232};
    return qualities.where((q) => freeQualities.contains(q.quality)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return AlertDialog(
      title: Text(l10n.selectQuality),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLoggedIn)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: colorScheme.tertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.loginForHighQuality,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.tertiary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            if (_filteredQualities.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: Text(l10n.noQualities)),
              )
            else
              ..._filteredQualities.map((q) {
                final label = _qualityLabel(q.quality);
                final badge = _qualityBadge(q.quality);
                final bitrateStr = q.bandwidth != null
                    ? '${(q.bandwidth! / 1000).round()} kbps'
                    : '';

                return ListTile(
                  leading: Icon(
                    _qualityIcon(q.quality),
                    color: colorScheme.primary,
                  ),
                  title: Text(label),
                  subtitle: bitrateStr.isNotEmpty ? Text(bitrateStr) : null,
                  trailing: badge != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(badge,
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onTertiaryContainer,
                              )),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onSelect(q);
                  },
                );
              }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }

  String _qualityLabel(int quality) {
    switch (quality) {
      case 30216:
        return '64 kbps';
      case 30232:
        return '132 kbps';
      case 30280:
        return '192 kbps';
      case 30250:
        return 'Dolby Atmos';
      case 30251:
        return 'Hi-Res';
      default:
        return 'Quality $quality';
    }
  }

  /// Informational badge for premium qualities.
  String? _qualityBadge(int quality) {
    switch (quality) {
      case 30250:
      case 30251:
        return '大会员';
      default:
        return null;
    }
  }

  IconData _qualityIcon(int quality) {
    switch (quality) {
      case 30251:
        return Icons.hd;
      case 30250:
        return Icons.surround_sound;
      case 30280:
        return Icons.high_quality;
      default:
        return Icons.audiotrack;
    }
  }
}
