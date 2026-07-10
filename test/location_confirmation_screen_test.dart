import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/select_city_screen.dart';

void main() {
  testWidgets('Milano Continua opens Italian Location Confirmation',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Italy'),
      ),
    );

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continua'));
    await tester.pumpAndSettle();

    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Conferma la tua posizione'), findsOneWidget);
    expect(
      find.text(
        'Per mantenere TOWN una comunità reale e locale, dobbiamo verificare che ti trovi a Milano.',
      ),
      findsOneWidget,
    );
    expect(find.text('Perché è richiesta la posizione?'), findsOneWidget);
    expect(
      find.text('Ci aiuta a mantenere TOWN locale, sicuro e affidabile.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Utilizziamo la tua posizione solo durante la registrazione.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Non monitoriamo la tua posizione in background.'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(FilledButton, 'Conferma posizione'),
      findsOneWidget,
    );
    expect(find.text('Non ora'), findsOneWidget);
  });

  testWidgets('Munich Weiter opens German Location Confirmation',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Germany'),
      ),
    );

    await tester.ensureVisible(find.text('Munich'));
    await tester.tap(find.text('Munich'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Weiter'));
    await tester.pumpAndSettle();

    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Bestätige deinen Standort'), findsOneWidget);
    expect(
      find.text(
        'Damit TOWN eine echte lokale Gemeinschaft bleibt, müssen wir bestätigen, dass du dich in München befindest.',
      ),
      findsOneWidget,
    );
    expect(find.text('Warum wird dein Standort benötigt?'), findsOneWidget);
    expect(
      find.text('Damit TOWN lokal, sicher und vertrauenswürdig bleibt.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Wir verwenden deinen Standort nur während der Registrierung.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Wir verfolgen deinen Standort nicht im Hintergrund.',
      ),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(FilledButton, 'Standort bestätigen'),
      findsOneWidget,
    );
    expect(find.text('Nicht jetzt'), findsOneWidget);
  });

  testWidgets('Back returns to localized Select City preserving Milano',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Italy'),
      ),
    );

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continua'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Seleziona la tua città'), findsOneWidget);
    expect(find.text('Italia'), findsOneWidget);
    expect(find.text('Milano'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Continua'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('Primary and secondary actions stay local',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
        ),
      ),
    );

    final Finder primary =
        find.widgetWithText(FilledButton, 'Conferma posizione');
    expect(tester.widget<FilledButton>(primary).onPressed, isNotNull);

    await tester.tap(primary);
    await tester.pumpAndSettle();
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Conferma la tua posizione'), findsOneWidget);

    await tester.tap(find.text('Non ora'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Conferma la tua posizione'), findsOneWidget);
  });

  testWidgets('German primary and secondary actions stay local',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(find.text('Bestätige deinen Standort'), findsOneWidget);

    await tester.tap(find.text('Nicht jetzt'));
    await tester.pumpAndSettle();
    expect(find.text('Bestätige deinen Standort'), findsOneWidget);
  });

  test('No location package or native permission config was added', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec.contains('geolocator'), isFalse);
    expect(pubspec.contains('permission_handler'), isFalse);
    expect(RegExp(r'^\s*location:', multiLine: true).hasMatch(pubspec), isFalse);

    final String androidManifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(androidManifest.contains('ACCESS_FINE_LOCATION'), isFalse);
    expect(androidManifest.contains('ACCESS_COARSE_LOCATION'), isFalse);

    final String iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    expect(iosInfo.contains('NSLocationWhenInUseUsageDescription'), isFalse);
    expect(
      iosInfo.contains('NSLocationAlwaysAndWhenInUseUsageDescription'),
      isFalse,
    );
  });
}
