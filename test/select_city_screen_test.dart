import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/main.dart';
import 'package:town_safe_space_mobile/screens/select_city_screen.dart';
import 'package:town_safe_space_mobile/screens/select_country_screen.dart';

void main() {
  testWidgets('Italy Continue opens Select City with Milano only',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Italy'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Select your city'), findsOneWidget);
    expect(find.text('Choose your city to continue.'), findsOneWidget);
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Select city'), findsOneWidget);
    expect(find.text('Italy'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
    expect(find.text('Milano'), findsOneWidget);
    expect(find.text('Munich'), findsNothing);
    expect(find.text('Other cities coming soon'), findsOneWidget);
    expect(find.bySemanticsLabel('Flag of Italy'), findsOneWidget);
    expect(find.bySemanticsLabel('Milano landmark'), findsOneWidget);
  });

  testWidgets('Germany Continue opens Select City with Munich only',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SelectCountryScreen()),
    );

    await tester.tap(find.text('Germany'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Munich'), findsOneWidget);
    expect(find.text('Milano'), findsNothing);
    expect(find.bySemanticsLabel('Flag of Germany'), findsOneWidget);
    expect(find.bySemanticsLabel('Munich landmark'), findsOneWidget);
  });

  testWidgets('Continue disabled until city selected and does not navigate',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Italy'),
      ),
    );

    final Finder continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();

    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Select your city'), findsOneWidget);
  });

  testWidgets('Back and Change return to Select Country preserving Italy',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Welcome'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Italy'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(SelectCityScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCountryScreen), findsOneWidget);
    expect(find.text('Where is your TOWN?'), findsOneWidget);
    // Country selection is preserved — Continue remains enabled.
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(SelectCityScreen), findsOneWidget);

    await tester.tap(find.text('Change'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCountryScreen), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
          .onPressed,
      isNotNull,
    );
  });
}
