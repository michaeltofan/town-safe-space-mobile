import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/select_city_screen.dart';
import 'package:town_safe_space_mobile/services/foreground_position_reader.dart';
import 'package:town_safe_space_mobile/services/location_permission_service.dart';

class _FakeLocationPermissionService extends LocationPermissionService {
  _FakeLocationPermissionService({
    required this.state,
  });

  ForegroundLocationState state;

  int ensureCalls = 0;
  int openAppSettingsCalls = 0;
  int openLocationSettingsCalls = 0;

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

class _FakeForegroundPositionReader extends ForegroundPositionReader {
  _FakeForegroundPositionReader({
    required this.result,
  });

  ForegroundPositionReadResult result;
  int readCalls = 0;

  @override
  Future<ForegroundPositionReadResult> readOnce() async {
    readCalls += 1;
    return result;
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
    expect(find.text('Milano'), findsOneWidget);
  });

  testWidgets(
      'getCurrentPosition runs only after granted and once per action',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 25,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(permission.ensureCalls, 1);
    expect(reader.readCalls, 1);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(
      find.text('Posizione rilevata con una precisione di circa 25 m.'),
      findsOneWidget,
    );
    expect(find.text('La città non è ancora stata verificata.'), findsOneWidget);
    expect(find.textContaining('lat'), findsNothing);
    expect(find.textContaining('lon'), findsNothing);
    expect(find.textContaining('Lat'), findsNothing);
    expect(find.textContaining('Lon'), findsNothing);
  });

  testWidgets('Position is not read when permission is denied',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.denied);
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 10,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(permission.ensureCalls, 1);
    expect(reader.readCalls, 0);
    expect(find.text('Autorizzazione alla posizione negata.'), findsOneWidget);
    expect(find.byKey(const Key('location_try_again')), findsOneWidget);
  });

  testWidgets('Position is not read when permanently denied',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(
      state: ForegroundLocationState.permanentlyDenied,
    );
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 10,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(reader.readCalls, 0);
    expect(find.byKey(const Key('location_open_settings')), findsOneWidget);
  });

  testWidgets('Position is not read when services are disabled',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(
      state: ForegroundLocationState.serviceDisabled,
    );
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 10,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();

    expect(reader.readCalls, 0);
    expect(
      find.text('Servizi di localizzazione disattivati.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('location_open_location_settings')),
      findsOneWidget,
    );
  });

  testWidgets('Italian timeout and error states render with retry',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.timeout,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();
    expect(
      find.text('Impossibile rilevare la posizione in tempo. Riprova.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('location_try_again')), findsOneWidget);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);

    reader.result = const ForegroundPositionReadResult(
      state: ForegroundPositionReadState.error,
    );
    await tester.tap(find.byKey(const Key('location_try_again')));
    await tester.pumpAndSettle();
    expect(reader.readCalls, 2);
    expect(
      find.text('Non è stato possibile rilevare la posizione. Riprova.'),
      findsOneWidget,
    );
  });

  testWidgets('Italian accuracy classifications render correctly',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 40,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();
    expect(
      find.text('Posizione rilevata con una precisione di circa 40 m.'),
      findsOneWidget,
    );
    expect(find.text('La città non è ancora stata verificata.'), findsOneWidget);

    reader.result = const ForegroundPositionReadResult(
      state: ForegroundPositionReadState.successLimited,
      accuracyMeters: 120,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Posizione rilevata, ma la precisione è limitata: circa 120 m.',
      ),
      findsOneWidget,
    );

    reader.result = const ForegroundPositionReadResult(
      state: ForegroundPositionReadState.insufficientAccuracy,
      accuracyMeters: 200,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Conferma posizione'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'La posizione è stata rilevata con una precisione insufficiente: circa 200 m. Riprova in uno spazio aperto.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('location_try_again')), findsOneWidget);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
  });

  testWidgets('German reading result messages render correctly',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 30,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Standort mit einer Genauigkeit von ungefähr 30 m ermittelt.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Die Stadt wurde noch nicht verifiziert.'),
      findsOneWidget,
    );

    reader.result = const ForegroundPositionReadResult(
      state: ForegroundPositionReadState.timeout,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Der Standort konnte nicht rechtzeitig ermittelt werden. Versuche es erneut.',
      ),
      findsOneWidget,
    );
    expect(find.text('Erneut versuchen'), findsOneWidget);
  });

  testWidgets('German permission denial still blocks position reading',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.denied);
    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 10,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Standort bestätigen'));
    await tester.pumpAndSettle();
    expect(reader.readCalls, 0);
    expect(find.text('Standortberechtigung wurde verweigert.'), findsOneWidget);
  });

  testWidgets('Secondary Not now stays local without reading',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeForegroundPositionReader reader = _FakeForegroundPositionReader(
      result: const ForegroundPositionReadResult(
        state: ForegroundPositionReadState.successGood,
        accuracyMeters: 10,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: _FakeLocationPermissionService(
            state: ForegroundLocationState.granted,
          ),
          positionReader: reader,
        ),
      ),
    );

    await tester.tap(find.text('Non ora'));
    await tester.pumpAndSettle();
    expect(reader.readCalls, 0);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
  });

  test('Accuracy thresholds classify good, limited, and insufficient', () {
    expect(
      ForegroundPositionReader.classifyAccuracyMeters(50).state,
      ForegroundPositionReadState.successGood,
    );
    expect(
      ForegroundPositionReader.classifyAccuracyMeters(51).state,
      ForegroundPositionReadState.successLimited,
    );
    expect(
      ForegroundPositionReader.classifyAccuracyMeters(150).state,
      ForegroundPositionReadState.successLimited,
    );
    expect(
      ForegroundPositionReader.classifyAccuracyMeters(151).state,
      ForegroundPositionReadState.insufficientAccuracy,
    );
    expect(kForegroundPositionTimeout, const Duration(seconds: 15));
    expect(ForegroundAccuracyThresholds.goodMaxMeters, 50);
    expect(ForegroundAccuracyThresholds.limitedMaxMeters, 150);
  });

  test('Permission service maps granted and denial outcomes', () {
    const LocationPermissionService service = LocationPermissionService();

    expect(
      service.mapPermissionAfterRequest(LocationPermission.whileInUse),
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

  test('Lib sources use only one-shot getCurrentPosition API', () {
    final List<File> dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File f) => f.path.endsWith('.dart'))
        .toList();

    int getCurrentPositionFiles = 0;
    for (final File file in dartFiles) {
      final String source = file.readAsStringSync();
      expect(
        source.contains('getPositionStream'),
        isFalse,
        reason: '${file.path} must not use getPositionStream',
      );
      expect(
        source.contains('getLastKnownPosition'),
        isFalse,
        reason: '${file.path} must not use getLastKnownPosition',
      );
      expect(
        RegExp(r'\bprint\s*\(').hasMatch(source),
        isFalse,
        reason: '${file.path} must not print',
      );
      expect(
        source.contains('debugPrint('),
        isFalse,
        reason: '${file.path} must not debugPrint',
      );
      if (source.contains('Geolocator.getCurrentPosition')) {
        getCurrentPositionFiles += 1;
        expect(
          file.path.endsWith('foreground_position_reader.dart'),
          isTrue,
          reason: 'getCurrentPosition only allowed in position reader',
        );
      }
    }
    expect(getCurrentPositionFiles, 1);

    final String reader =
        File('lib/services/foreground_position_reader.dart').readAsStringSync();
    expect(reader.contains('Geolocator.getCurrentPosition'), isTrue);
    // Coordinates may be received transiently via Position and passed into a
    // one-shot callback. They must not be retained on the result model.
    expect(reader.contains('accuracyMeters'), isTrue);
    expect(reader.contains('position.latitude'), isTrue);
    expect(reader.contains('position.longitude'), isTrue);

    final RegExp resultClass = RegExp(
      r'class ForegroundPositionReadResult \{[\s\S]*?\n\}',
    );
    final String resultBody = resultClass.firstMatch(reader)!.group(0)!;
    expect(resultBody.contains('latitude'), isFalse);
    expect(resultBody.contains('longitude'), isFalse);
    expect(resultBody.contains('final Position'), isFalse);
    expect(resultBody.contains('Position?'), isFalse);
    expect(resultBody.contains('GeoPoint'), isFalse);

    final String screen =
        File('lib/screens/location_confirmation_screen.dart').readAsStringSync();
    expect(screen.contains('latitude'), isFalse);
    expect(screen.contains('longitude'), isFalse);
    expect(screen.contains('SharedPreferences'), isFalse);
    expect(screen.contains('http'), isFalse);
  });

  test('Foreground permission config remains without background keys', () {
    final String androidManifest =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(androidManifest.contains('ACCESS_BACKGROUND_LOCATION'), isFalse);
    expect(
      androidManifest.contains('FOREGROUND_SERVICE_LOCATION'),
      isFalse,
    );

    final String iosInfo = File('ios/Runner/Info.plist').readAsStringSync();
    expect(
      RegExp(r'<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>')
          .hasMatch(iosInfo),
      isFalse,
    );
    expect(
      RegExp(r'<key>UIBackgroundModes</key>').hasMatch(iosInfo),
      isFalse,
    );
  });
}
