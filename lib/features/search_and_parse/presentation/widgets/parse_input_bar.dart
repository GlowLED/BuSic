import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';

import '../../application/parse_notifier.dart';

/// Input bar widget for entering BV numbers or Bilibili URLs.
class ParseInputBar extends ConsumerStatefulWidget {
  const ParseInputBar({super.key});

  @override
  ConsumerState<ParseInputBar> createState() => _ParseInputBarState();
}

class _ParseInputBarState extends ConsumerState<ParseInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onParse() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(parseNotifierProvider.notifier).parseInput(text);
  }

  Future<void> _onPaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _controller.text = data.text!;
      _onParse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parseState = ref.watch(parseNotifierProvider);
    final isParsing = parseState is AsyncLoading ||
        parseState.whenOrNull(parsing: () => true) == true;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: l10n.parseInput,
                prefixIcon: const Icon(Icons.link),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.content_paste),
                  tooltip: '粘贴',
                  onPressed: _onPaste,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _onParse(),
              enabled: !isParsing,
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: isParsing ? null : _onParse,
            icon: isParsing
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.search),
            label: Text(isParsing ? l10n.parsing : l10n.search),
          ),
        ],
      ),
    );
  }
}
