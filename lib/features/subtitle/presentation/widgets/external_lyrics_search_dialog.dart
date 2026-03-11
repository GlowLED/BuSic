import 'package:flutter/material.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../data/external_lyrics_repository.dart';

class ExternalLyricsSearchDialog extends StatefulWidget {
  const ExternalLyricsSearchDialog({
    required this.initialQuery,
    super.key,
  });

  final String initialQuery;

  static Future<ExternalLyricSong?> show(
    BuildContext context, {
    required String initialQuery,
  }) {
    return showDialog<ExternalLyricSong>(
      context: context,
      builder: (_) => ExternalLyricsSearchDialog(initialQuery: initialQuery),
    );
  }

  @override
  State<ExternalLyricsSearchDialog> createState() =>
      _ExternalLyricsSearchDialogState();
}

class _ExternalLyricsSearchDialogState
    extends State<ExternalLyricsSearchDialog> {
  final ExternalLyricsRepository _repository = ExternalLyricsRepository();
  late final TextEditingController _controller;

  bool _isLoading = false;
  String? _errorMessage;
  List<ExternalLyricSong> _results = const [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _search();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.externalLyricsDialogTitle),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: context.l10n.externalLyricsKeywordHint,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _isLoading ? null : _search,
                  child: Text(context.l10n.searchAction),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 360),
                child: _buildBody(context),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancelAction),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: context.colorScheme.error),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          context.l10n.externalLyricsNoResults,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final song = _results[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(song.name),
          subtitle: Text(
            [song.artistText, song.albumName]
                .where((part) => part.isNotEmpty)
                .join(' • '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).pop(song),
        );
      },
    );
  }

  Future<void> _search() async {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) {
      setState(() {
        _results = const [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _repository.searchSongs(keyword);
      if (!mounted) return;
      setState(() {
        _results = results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = context.l10n.externalLyricsSearchError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
