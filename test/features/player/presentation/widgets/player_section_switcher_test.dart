import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busic/features/player/presentation/widgets/player_section_switcher.dart';

import '../../../../test_helpers/test_app.dart';

void main() {
  const items = [
    PlayerSectionSwitcherItem(
      label: 'Info',
      icon: Icons.info_outline_rounded,
    ),
    PlayerSectionSwitcherItem(
      label: 'Lyrics',
      icon: Icons.format_align_center_rounded,
    ),
    PlayerSectionSwitcherItem(
      label: 'Comments',
      icon: Icons.comment_outlined,
    ),
  ];

  testWidgets('renders all sections and forwards taps', (tester) async {
    int? selected;

    await tester.pumpWidget(
      buildTestApp(
        Center(
          child: PlayerSectionSwitcher(
            items: items,
            selectedIndex: 0,
            onSelected: (index) => selected = index,
          ),
        ),
      ),
    );

    expect(find.text('Info'), findsOneWidget);
    expect(find.text('Lyrics'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);

    await tester.tap(find.text('Lyrics'));
    await tester.pump();

    expect(selected, 1);
  });

  testWidgets('updates selected text styling when parent state changes',
      (tester) async {
    var selectedIndex = 0;

    await tester.pumpWidget(
      buildTestApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: PlayerSectionSwitcher(
                items: items,
                selectedIndex: selectedIndex,
                onSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Comments'));
    await tester.pumpAndSettle();

    final commentsText = tester.widget<Text>(find.text('Comments'));
    expect(
      commentsText.style?.color,
      Colors.black.withValues(alpha: 0.88),
    );
  });
}
