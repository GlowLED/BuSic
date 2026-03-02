import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../application/parse_notifier.dart';
import '../domain/models/bvid_info.dart';
import 'widgets/parse_input_bar.dart';
import 'widgets/multi_page_dialog.dart';
import '../../../core/utils/formatters.dart';

/// Main search screen with BV number input and search results.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List<BvidInfo> _searchResults = [];
  bool _isSearching = false;

  Future<void> _onSearch(String keyword) async {
    if (keyword.isEmpty) return;
    setState(() => _isSearching = true);
    final results = await ref.read(parseNotifierProvider.notifier).searchVideos(keyword);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parseState = ref.watch(parseNotifierProvider);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // Show multi-page dialog when in selectingPages state
    ref.listen(parseNotifierProvider, (prev, next) {
      next.whenOrNull(
        selectingPages: (info, selectedPages) {
          showDialog(
            context: context,
            builder: (_) => MultiPageDialog(
              videoInfo: info,
              selectedPages: selectedPages,
            ),
          );
        },
        success: (info) async {
          // Single page - auto confirm
          final ids = await ref.read(parseNotifierProvider.notifier).confirmSelection();
          if (context.mounted && ids.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已添加 ${ids.length} 首歌曲')),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.search),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Parse input bar
          const ParseInputBar(),

          // Parse status
          parseState.when(
            idle: () => const SizedBox.shrink(),
            parsing: () => const LinearProgressIndicator(),
            success: (_) => const SizedBox.shrink(),
            selectingPages: (_, __) => const SizedBox.shrink(),
            error: (msg) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: colorScheme.errorContainer,
              child: Text(msg, style: TextStyle(color: colorScheme.onErrorContainer)),
            ),
          ),

          // Search results
          if (_isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final video = _searchResults[index];
                  return ListTile(
                    leading: video.coverUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              video.coverUrl!,
                              width: 80, height: 50, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80, height: 50,
                                color: colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.video_library),
                              ),
                            ),
                          )
                        : null,
                    title: Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      '${video.owner} · ${Formatters.formatDuration(Duration(seconds: video.duration))}',
                    ),
                    onTap: () => ref.read(parseNotifierProvider.notifier).parseInput(video.bvid),
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, size: 64, color: colorScheme.outlineVariant),
                    const SizedBox(height: 16),
                    Text(l10n.parseInput,
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
