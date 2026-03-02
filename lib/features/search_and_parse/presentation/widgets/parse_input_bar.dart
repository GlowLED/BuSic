import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Input bar widget for entering BV numbers or Bilibili URLs.
///
/// Provides:
/// - A text field with paste support
/// - A "Parse" action button
/// - Loading indicator during parsing
/// - Error display for invalid input
class ParseInputBar extends ConsumerStatefulWidget {
  const ParseInputBar({super.key});

  @override
  ConsumerState<ParseInputBar> createState() => _ParseInputBarState();
}

class _ParseInputBarState extends ConsumerState<ParseInputBar> {
  // TODO: TextEditingController for input

  @override
  Widget build(BuildContext context) {
    // TODO: implement parse input bar
    // - TextField with BV/URL hint
    // - IconButton for paste from clipboard
    // - ElevatedButton / icon to trigger parse
    return const SizedBox.shrink();
  }
}
