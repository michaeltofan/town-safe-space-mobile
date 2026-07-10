import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/select_city_screen.dart';
import 'package:town_safe_space_mobile/services/location_permission_service.dart';

import 'dart:io';

class _FakeLocationPermissionService extends LocationPermissionService {
  _FakeLocationPermissionService({
    required this.state,
  });

  ForegroundLocationState state;

  int ensureCalls = 0;
  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;
  bool getCurrentPositionCalled = false;
  bool getPositionStreamCalled = false;

  @override
  Future<ForegroundLocationState> ensureForegroundPermission() async {
    ensureCalls += 1;
    return state;
  }

  @override
  Future<bool> openAppSettings() async {
    openAppSettingsCalls += 1;
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    openLocationSettingsCalls += 1;
    return true;
  }
}

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

  testWidgets('Primary CTA checks foreground permission and stays on screen',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService fake =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: fake,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(fake.ensureCalls, 1);
    expect(fake.getCurrentPositionCalled, isFalse);
    expect(fake.getPositionStreamCalled, isFalse);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Autorizzazione alla posizione concessa.'), findsOneWidget);
    expect(find.text('Conferma la tua posizione'), findsOneWidget);
  });

  testWidgets('Italian denied state shows try-again action',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService fake =
        _FakeLocationPermissionService(state: ForegroundLocationState.denied);

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: fake,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Autorizzazione alla posizione negata.'), findsOneWidget);
    expect(find.byKey(const Key('location_try_again')), findsOneWidget);
    expect(find.text('Riprova'), findsOneWidget);

    fake.state = ForegroundLocationState.granted;
    await tester.tap(find.byKey(const Key('location_try_again')));
    await tester.pumpAndSettle();

    expect(fake.ensureCalls, 2);
    expect(find.text('Autorizzazione alla posizione concessa.'), findsOneWidget);
  });

  testWidgets('Italian permanently denied opens settings action',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService fake = _FakeLocationPermissionService(
      state: ForegroundLocationState.permanentlyDenied,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: fake,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Autorizzazione negata in modo permanente. Apri le impostazioni per modificarla.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('location_open_settings')));
    await tester.pumpAndSettle();
    expect(fake.openAppSettingsCalls, 1);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
  });

  testWidgets('Italian service-disabled opens location settings action',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService fake = _FakeLocationPermissionService(
      state: ForegroundLocationState.serviceDisabled,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: fake,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(
      find.text('Servizi di localizzazione disattivati.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('location_open_location_settings')));
    await tester.pumpAndSettle();
    expect(fake.openLocationSettingsCalls, 1);
  });

  testWidgets('German permission state messages render correctly',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService fake = _FakeLocationPermissionService(
      state: ForegroundLocationState.serviceDisabled,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: fake,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(find.text('Ortungsdienste sind deaktiviert.'), findsOneWidget);
    expect(find.text('Ortungseinstellungen öffnen'), findsOneWidget);

    fake.state = ForegroundLocationState.denied;
    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(find.text('Standortberechtigung wurde verweigert.'), findsOneWidget);
    expect(find.text('Erneut versuchen'), findsOneWidget);

    fake.state = ForegroundLocationState.permanentlyDenied;
    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Standortberechtigung wurde dauerhaft verweigert. Öffne die Einstellungen, um sie zu ändern.',
      ),
      findsOneWidget,
    );
    expect(find.text('Einstellungen öffnen'), findsOneWidget);

    fake.state = ForegroundLocationState.granted;
    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(find.text('Standortberechtigung wurde erteilt.'), findsOneWidget);
  });

  testWidgets('Restricted state shows localized message without navigation',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService fake = _FakeLocationPermissionService(
      state: ForegroundLocationState.restricted,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: fake,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Autorizzazione alla posizione limitata.'), findsOneWidget);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
  });

  testWidgets('Secondary action stays local', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: _FakeLocationPermissionService(
            state: ForegroundLocationState.granted,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Non ora'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Conferma la tua posizione'), findsOneWidget);
  });

  test('Permission service maps granted and denial outcomes', () {
    const LocationPermissionService service = LocationPermissionService();

    expect(
      service.mapPermissionAfterRequest(LocationPermission.whileInUse),
      ForegroundLocationState.granted,
    );
    expect(
      service.mapPermissionAfterRequest(LocationPermission.always),
      ForegroundLocationState.granted,
    );
    expect(
      service.mapPermissionAfterRequest(LocationPermission.deniedForever),
      ForegroundLocationState.permanentlyDenied,
    );
    expect(
      service.mapPermissionAfterRequest(LocationPermission.denied),
      ForegroundLocationState.denied,
    );
  });

  test('Foreground permission config is present without background keys', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec.contains('geolocator:'), isTrue);
    expect(pubspec.contains('permission_handler'), isFalse);
    expect(RegExp(r'^\s*location:', multiLine: true).hasMatch(pubspec), isFalse);

    final String androidManifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(androidManifest.contains('ACCESS_FINE_LOCATION'), isTrue);
    expect(androidManifest.contains('ACCESS_COARSE_LOCATION'), isTrue);
    expect(androidManifest.contains('ACCESS_BACKGROUND_LOCATION'), isFalse);
    expect(
      androidManifest.contains('FOREGROUND_SERVICE_LOCATION'),
      isFalse,
    );

    final String iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    expect(iosInfo.contains('NSLocationWhenInUseUsageDescription'), isTrue);
    expect(
      RegExp(r'<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>')
          .hasMatch(iosInfo),
      isFalse,
    );
    expect(
      RegExp(r'<key>NSLocationAlwaysUsageDescription</key>').hasMatch(iosInfo),
      isFalse,
    );
    expect(
      RegExp(r'<key>UIBackgroundModes</key>').hasMatch(iosInfo),
      isFalse,
    );

    final String podfile = File('ios/Podfile').readAsStringSync();
    expect(podfile.contains('BYPASS_PERMISSION_LOCATION_ALWAYS=1'), isTrue);
  });

  test('No coordinate-reading APIs are called from app lib sources', () {
    final List<File> dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File f) => f.path.endsWith('.dart'))
        .toList();

    final RegExp coordinateApis = RegExp(
      r'Geolocator\.(getCurrentPosition|getPositionStream|getLastKnownPosition)\s*\(',
    );

    for (final File file in dartFiles) {
      final String source = file.readAsStringSync();
      expect(
        coordinateApis.hasMatch(source),
        isFalse,
        reason: '${file.path} must not call coordinate-reading Geolocator APIs',
      );
    }
  });
}
