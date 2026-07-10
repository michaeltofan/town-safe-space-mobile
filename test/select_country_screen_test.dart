import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/main.dart';
import 'package:town_safe_space_mobile/screens/select_country_screen.dart';

void main() {
  testWidgets('Welcome navigates to Select Country', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);

    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCountryScreen), findsOneWidget);
    expect(find.text('Where is your TOWN?'), findsOneWidget);
    expect(find.text('Select your country to continue.'), findsOneWidget);
    expect(
      find.text(
        'TOWN is available only in the official language of the selected country and city.',
      ),
      findsOneWidget,
    );
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Italy'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Continue stays disabled until a country is selected',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SelectCountryScreen()),
    );

    final Finder continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.tap(find.text('Italy'));
    await tester.pump();

    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);

    await tester.tap(find.text('Germany'));
    await tester.pump();

    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);
    expect(find.text('Germany'), findsOneWidget);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // Select City is not built — Continue must not navigate away.
    expect(find.byType(SelectCountryScreen), findsOneWidget);
  });

  testWidgets('Back returns to Welcome', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();
    expect(find.byType(SelectCountryScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.byType(SelectCountryScreen), findsNothing);
  });
}
