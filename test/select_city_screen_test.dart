import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/main.dart';
import 'package:town_safe_space_mobile/screens/select_city_screen.dart';
import 'package:town_safe_space_mobile/screens/select_country_screen.dart';

bool _hasAssetImage(WidgetTester tester, String assetName) {
  return tester.widgetList<Image>(find.byType(Image)).any((Image image) {
    final ImageProvider<Object> provider = image.image;
    return provider is AssetImage && provider.assetName == assetName;
  });
}

void main() {
  testWidgets('Italy Continue opens Select City with Milano only in English',
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
    expect(
      find.text(
        'TOWN is available only in the official language of the selected country and city.',
      ),
      findsOneWidget,
    );
    expect(find.text('Country'), findsOneWidget);
    expect(find.text('Select city'), findsOneWidget);
    expect(find.text('Italy'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
    expect(find.text('Milano'), findsOneWidget);
    expect(find.text('Munich'), findsNothing);
    expect(find.text('Other cities coming soon'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);
    expect(find.bySemanticsLabel('Flag of Italy'), findsOneWidget);
    expect(find.bySemanticsLabel('Milano landmark'), findsOneWidget);
    // No manual language selector.
    expect(find.textContaining('Language'), findsNothing);
    expect(find.text('Italiano'), findsNothing);
    expect(find.text('Deutsch'), findsNothing);
  });

  testWidgets('Germany Continue opens Select City with Munich only in English',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SelectCountryScreen()),
    );

    await tester.tap(find.text('Germany'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Select your city'), findsOneWidget);
    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Munich'), findsOneWidget);
    expect(find.text('Milano'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);
    expect(find.bySemanticsLabel('Flag of Germany'), findsOneWidget);
    expect(find.bySemanticsLabel('Munich landmark'), findsOneWidget);
  });

  testWidgets('Selecting Milano switches Screen 02B to Italian copy',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Italy'),
      ),
    );

    expect(find.text('Select your city'), findsOneWidget);

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();

    expect(find.text('Seleziona la tua città'), findsOneWidget);
    expect(find.text('Scegli la tua città per continuare.'), findsOneWidget);
    expect(
      find.text(
        'TOWN è disponibile solo nella lingua ufficiale del paese e della città selezionati.',
      ),
      findsOneWidget,
    );
    expect(find.text('Paese'), findsOneWidget);
    expect(find.text('Italia'), findsOneWidget);
    expect(find.text('Cambia'), findsOneWidget);
    expect(find.text('Seleziona città'), findsOneWidget);
    expect(find.text('Milano'), findsOneWidget);
    expect(find.text('Altre città in arrivo'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Continua'), findsOneWidget);

    // English chrome is gone; selection chrome remains.
    expect(find.text('Select your city'), findsNothing);
    expect(find.text('Italy'), findsNothing);
    expect(find.text('Change'), findsNothing);
    expect(find.text('Continue'), findsNothing);
    expect(find.bySemanticsLabel('Flag of Italy'), findsOneWidget);
    expect(find.bySemanticsLabel('Milano landmark'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.textContaining('Language'), findsNothing);
    expect(
      _hasAssetImage(tester, 'assets/flags/italy.png'),
      isTrue,
      reason: 'Italian flag must remain visible after language switch',
    );
    expect(
      _hasAssetImage(tester, 'assets/cities/milano.png'),
      isTrue,
      reason: 'Milano thumbnail must remain visible after language switch',
    );
  });

  testWidgets('Selecting Munich switches Screen 02B to German copy',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Germany'),
      ),
    );

    expect(find.text('Select your city'), findsOneWidget);
    expect(find.text('Munich'), findsOneWidget);

    await tester.ensureVisible(find.text('Munich'));
    await tester.tap(find.text('Munich'));
    await tester.pump();

    expect(find.text('Wähle deine Stadt'), findsOneWidget);
    expect(find.text('Wähle deine Stadt, um fortzufahren.'), findsOneWidget);
    expect(
      find.text(
        'TOWN ist nur in der Amtssprache des ausgewählten Landes und der ausgewählten Stadt verfügbar.',
      ),
      findsOneWidget,
    );
    expect(find.text('Land'), findsOneWidget);
    expect(find.text('Deutschland'), findsOneWidget);
    expect(find.text('Ändern'), findsOneWidget);
    expect(find.text('Stadt auswählen'), findsOneWidget);
    expect(find.text('München'), findsOneWidget);
    expect(find.text('Weitere Städte folgen'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Weiter'), findsOneWidget);

    expect(find.text('Select your city'), findsNothing);
    expect(find.text('Germany'), findsNothing);
    expect(find.text('Munich'), findsNothing);
    expect(find.text('Continue'), findsNothing);
    expect(find.bySemanticsLabel('Flag of Germany'), findsOneWidget);
    expect(find.bySemanticsLabel('Munich landmark'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.textContaining('Language'), findsNothing);
    expect(
      _hasAssetImage(tester, 'assets/flags/germany.png'),
      isTrue,
      reason: 'German flag must remain visible after language switch',
    );
    expect(
      _hasAssetImage(tester, 'assets/cities/munich.png'),
      isTrue,
      reason: 'Munich thumbnail must remain visible after language switch',
    );
  });

  testWidgets('Continue enabled after city selection and does not navigate',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Italy'),
      ),
    );

    final Finder continueBefore =
        find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueBefore).onPressed, isNull);

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();

    final Finder continuaButton =
        find.widgetWithText(FilledButton, 'Continua');
    expect(tester.widget<FilledButton>(continuaButton).onPressed, isNotNull);

    await tester.tap(continuaButton);
    await tester.pumpAndSettle();

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Seleziona la tua città'), findsOneWidget);
  });

  testWidgets('Back and Change return to Select Country preserving Italy',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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

    // Change works in English before city selection.
    await tester.tap(find.text('Change'));
    await tester.pumpAndSettle();
    expect(find.byType(SelectCountryScreen), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(SelectCityScreen), findsOneWidget);

    // After Milano selection, localized Cambia still returns to Select Country.
    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();
    expect(find.text('Cambia'), findsOneWidget);

    await tester.tap(find.text('Cambia'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCountryScreen), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continue'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('German Change returns to Select Country',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: SelectCountryScreen()),
    );

    await tester.tap(find.text('Germany'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Munich'));
    await tester.tap(find.text('Munich'));
    await tester.pump();
    expect(find.text('Ändern'), findsOneWidget);

    await tester.tap(find.text('Ändern'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCountryScreen), findsOneWidget);
    expect(find.text('Where is your TOWN?'), findsOneWidget);
  });
}
