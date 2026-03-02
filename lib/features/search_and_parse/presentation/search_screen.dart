import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Main search screen with BV number input and search results.
///
/// Features:
/// - Top search/input bar for BV numbers or URLs
/// - Parse status indicator
/// - Recent parse history (optional)
/// - Search results from Bilibili (optional extension)
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement search screen UI
    // - ParseInputBar at top
    // - Watch parseNotifierProvider for state changes
    // - Show results or multi-page dialog when ready
    return const Scaffold(
      body: Center(
        child: Text('TODO: SearchScreen'),
      ),
    );
  }
}
