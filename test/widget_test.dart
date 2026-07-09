import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:town_safe_space/app.dart';

void main() {
  testWidgets('Welcome screen shows TOWN brand in phone frame', (
    WidgetTester tester,
  ) async {
    // Simulate a wide Chrome preview so the phone shell activates.
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const TownApp());
    await tester.pumpAndSettle();

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.textContaining('Real communities.'), findsOneWidget);
    expect(find.text('Learn more'), findsOneWidget);
  });

  testWidgets('Welcome screen fills narrow mobile width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const TownApp());
    await tester.pumpAndSettle();

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
  });
}
