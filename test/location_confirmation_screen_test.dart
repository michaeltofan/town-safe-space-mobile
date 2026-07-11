import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/select_city_screen.dart';
import 'package:town_safe_space_mobile/screens/welcome_screen.dart';
import 'package:town_safe_space_mobile/services/city_boundary_classification_service.dart';
import 'package:town_safe_space_mobile/services/foreground_city_classification_bridge.dart';
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

class _FakeClassificationBridge extends ForegroundCityClassificationBridge {
  _FakeClassificationBridge({
    this.result,
    this.failure,
  });

  CityBoundaryClassificationResult? result;
  ForegroundCityClassificationBridgeFailure? failure;
  int callCount = 0;
  final List<String> cities = <String>[];

  @override
  Future<CityBoundaryClassificationResult> readAndClassifyOnce({
    required String selectedCity,
  }) async {
    callCount += 1;
    cities.add(selectedCity);
    if (failure != null) {
      throw ForegroundCityClassificationBridgeException(failure!);
    }
    return result!;
  }
}

CityBoundaryClassificationResult _result({
  required String city,
  required PointContainment containment,
  required int accuracyMeters,
}) {
  return CityBoundaryClassificationResult(
    city: city,
    containment: containment,
    accuracyMeters: accuracyMeters,
    classifiedAt: DateTime.utc(2026, 1, 1),
  );
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required String country,
  required String city,
  required _FakeLocationPermissionService permission,
  required _FakeClassificationBridge bridge,
  Widget? home,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      home: home ??
          LocationConfirmationScreen(
            key: UniqueKey(),
            selectedCountry: country,
            selectedCity: city,
            permissionService: permission,
            classificationBridge: bridge,
          ),
    ),
  );
  await tester.pump();
}

void _expectNoCoordinates(WidgetTester tester) {
  expect(find.textContaining('latitude'), findsNothing);
  expect(find.textContaining('longitude'), findsNothing);
  expect(find.textContaining('Latitude'), findsNothing);
  expect(find.textContaining('Longitude'), findsNothing);
  expect(find.textContaining('GeoPoint'), findsNothing);
}

void _expectNoDeveloperTerms(WidgetTester tester) {
  expect(find.textContaining('inside'), findsNothing);
  expect(find.textContaining('outside'), findsNothing);
  expect(find.textContaining('boundary'), findsNothing);
  expect(find.textContaining('PointContainment'), findsNothing);
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
    await tester.pump();

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continua'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Conferma la tua posizione'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Verifica posizione'),
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
    await tester.pump();

    await tester.ensureVisible(find.text('Munich'));
    await tester.tap(find.text('Munich'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Weiter'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Bestätige deinen Standort'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Standort prüfen'),
      findsOneWidget,
    );
    expect(find.text('Nicht jetzt'), findsOneWidget);
  });

  testWidgets('1-4. bridge called once after granted; duplicate taps ignored',
      (WidgetTester tester) async {
    final Completer<void> gate = Completer<void>();
    final _FakeClassificationBridge blockingBridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 25,
      ),
    );

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: _BlockingPermissionService(
            state: ForegroundLocationState.granted,
            gate: gate,
          ),
          classificationBridge: blockingBridge,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('location_primary_action')));
    await tester.pump();
    expect(blockingBridge.callCount, 0);
    gate.complete();
    await tester.pumpAndSettle();

    expect(blockingBridge.callCount, 1);
    expect(blockingBridge.cities, <String>['Milano']);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
  });

  testWidgets('5. requesting-permission progress copy appears',
      (WidgetTester tester) async {
    final Completer<void> gate = Completer<void>();
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: _BlockingPermissionService(
            state: ForegroundLocationState.granted,
            gate: gate,
          ),
          classificationBridge: bridge,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pump();
    expect(find.text('Controllo dell’autorizzazione…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('6. reading-and-classifying progress copy appears',
      (WidgetTester tester) async {
    final Completer<void> gate = Completer<void>();
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _GatedBridge(
      gate: gate,
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pump();
    expect(find.text('Verifica della posizione in corso…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('7. inside + good IT copy', (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 25,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Posizione verificata'), findsOneWidget);
    expect(
      find.text(
        'La verifica indica che ti trovi a Milano. Precisione: circa 25 m.',
      ),
      findsOneWidget,
    );
    expect(find.text('Continua'), findsNothing);
    expect(find.text('Weiter'), findsNothing);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Perché è richiesta la posizione?'), findsOneWidget);
    _expectNoCoordinates(tester);
    _expectNoDeveloperTerms(tester);
  });

  testWidgets('8. inside + good DE copy', (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Munich',
        containment: PointContainment.inside,
        accuracyMeters: 30,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Germany',
      city: 'Munich',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();

    expect(find.text('Standort bestätigt'), findsOneWidget);
    expect(
      find.text(
        'Die Prüfung zeigt, dass du dich in München befindest. Ungefähre Genauigkeit: 30 m.',
      ),
      findsOneWidget,
    );
    expect(find.text('Weiter'), findsNothing);
    expect(find.text('Continua'), findsNothing);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Warum wird dein Standort benötigt?'), findsOneWidget);
  });

  testWidgets('9. inside + limited IT/DE copy; retry optional',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 120,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Posizione verificata'), findsOneWidget);
    expect(
      find.text(
        'La verifica indica che ti trovi a Milano. Precisione limitata: circa 120 m.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Puoi riprovare per una misura più precisa.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Riprova'), findsOneWidget);
    expect(find.byKey(const Key('location_change_city')), findsNothing);

    bridge.result = _result(
      city: 'Munich',
      containment: PointContainment.inside,
      accuracyMeters: 90,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          key: UniqueKey(),
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          classificationBridge: bridge,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();
    expect(find.text('Standort bestätigt'), findsOneWidget);
    expect(
      find.text(
        'Die Prüfung zeigt, dass du dich in München befindest. Eingeschränkte Genauigkeit: ungefähr 90 m.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Du kannst es für eine präzisere Messung erneut versuchen.'),
      findsOneWidget,
    );
  });

  testWidgets('10. inside + insufficient IT/DE copy; no Change city',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 200,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Posizione non confermata'), findsOneWidget);
    expect(
      find.text(
        'La precisione non è sufficiente per confermare che ti trovi a Milano. Riprova in uno spazio aperto.',
      ),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Riprova'), findsOneWidget);
    expect(find.byKey(const Key('location_change_city')), findsNothing);

    bridge.result = _result(
      city: 'Munich',
      containment: PointContainment.inside,
      accuracyMeters: 180,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          key: UniqueKey(),
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          classificationBridge: bridge,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();
    expect(find.text('Standort nicht bestätigt'), findsOneWidget);
    expect(
      find.text(
        'Die Genauigkeit reicht nicht aus, um zu bestätigen, dass du dich in München befindest. Versuche es erneut im Freien.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('location_change_city')), findsNothing);
  });

  testWidgets('11. outside + good IT/DE copy with Change city',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.outside,
        accuracyMeters: 20,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Posizione non corrispondente'), findsOneWidget);
    expect(
      find.text(
        'La lettura non corrisponde a Milano. Puoi riprovare o cambiare città.',
      ),
      findsOneWidget,
    );
    expect(find.text('Cambia città'), findsOneWidget);

    bridge.result = _result(
      city: 'Munich',
      containment: PointContainment.outside,
      accuracyMeters: 40,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          key: UniqueKey(),
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          classificationBridge: bridge,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();
    expect(find.text('Standort stimmt nicht überein'), findsOneWidget);
    expect(
      find.text(
        'Die Standortprüfung stimmt nicht mit München überein. Du kannst es erneut versuchen oder die Stadt ändern.',
      ),
      findsOneWidget,
    );
    expect(find.text('Stadt ändern'), findsOneWidget);
  });

  testWidgets('12. outside + limited IT/DE copy', (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.outside,
        accuracyMeters: 100,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'La lettura non corrisponde a Milano. Precisione limitata: circa 100 m. Puoi riprovare o cambiare città.',
      ),
      findsOneWidget,
    );

    bridge.result = _result(
      city: 'Munich',
      containment: PointContainment.outside,
      accuracyMeters: 110,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          key: UniqueKey(),
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          classificationBridge: bridge,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Die Standortprüfung stimmt nicht mit München überein. Die Genauigkeit ist eingeschränkt: ungefähr 110 m. Du kannst es erneut versuchen oder die Stadt ändern.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('13. outside + insufficient IT/DE maps to uncertain',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.outside,
        accuracyMeters: 200,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Posizione non confermata'), findsOneWidget);
    expect(
      find.text(
        'Non possiamo confermare con certezza la tua posizione rispetto a Milano. Riprova in uno spazio aperto.',
      ),
      findsOneWidget,
    );
    expect(find.text('Cambia città'), findsOneWidget);

    bridge.result = _result(
      city: 'Munich',
      containment: PointContainment.outside,
      accuracyMeters: 250,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LocationConfirmationScreen(
          key: UniqueKey(),
          selectedCountry: 'Germany',
          selectedCity: 'Munich',
          permissionService: permission,
          classificationBridge: bridge,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();
    expect(find.text('Standort nicht bestätigt'), findsOneWidget);
    expect(
      find.text(
        'Wir können deine Position im Vergleich zu München nicht sicher bestätigen. Versuche es erneut im Freien.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('14-16. boundary + any accuracy maps to uncertain',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);

    for (final int accuracy in <int>[20, 100, 200]) {
      final _FakeClassificationBridge bridge = _FakeClassificationBridge(
        result: _result(
          city: 'Milano',
          containment: PointContainment.boundary,
          accuracyMeters: accuracy,
        ),
      );
      await _pumpScreen(
        tester,
        country: 'Italy',
        city: 'Milano',
        permission: permission,
        bridge: bridge,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
      await tester.pumpAndSettle();
      expect(find.text('Posizione non confermata'), findsOneWidget);
      expect(
        find.text(
          'Non siamo riusciti a confermare con certezza che ti trovi a Milano. Riprova.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('boundary'), findsNothing);
      expect(find.text('Cambia città'), findsOneWidget);
    }
  });

  testWidgets('18. services disabled mapping', (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(
      state: ForegroundLocationState.serviceDisabled,
    );
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(bridge.callCount, 0);
    expect(find.text('Localizzazione disattivata'), findsOneWidget);
    expect(
      find.text(
        'Attiva i servizi di localizzazione per completare la verifica.',
      ),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(
        FilledButton,
        'Apri le impostazioni di localizzazione',
      ),
      findsOneWidget,
    );
    expect(find.text('Perché è richiesta la posizione?'), findsOneWidget);
  });

  testWidgets('19. permission denied mapping', (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.denied);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(bridge.callCount, 0);
    expect(find.text('Autorizzazione richiesta'), findsOneWidget);
    expect(
      find.text(
        'TOWN usa la posizione solo per questa verifica una tantum.',
      ),
      findsOneWidget,
    );
    expect(find.widgetWithText(FilledButton, 'Riprova'), findsOneWidget);
  });

  testWidgets('20. permission permanently denied mapping',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(
      state: ForegroundLocationState.permanentlyDenied,
    );
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(bridge.callCount, 0);
    expect(find.text('Autorizzazione necessaria'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Apri le impostazioni dell’app'),
      findsOneWidget,
    );
  });

  testWidgets('21-25. timeout and technical bridge failures',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);

    Future<void> expectFailure(
      ForegroundCityClassificationBridgeFailure failure,
      String title,
      String body, {
      required bool changeCity,
    }) async {
      final _FakeClassificationBridge bridge = _FakeClassificationBridge(
        failure: failure,
      );
      await _pumpScreen(
        tester,
        country: 'Italy',
        city: 'Milano',
        permission: permission,
        bridge: bridge,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      expect(find.text(body), findsOneWidget);
      expect(
        find.byKey(const Key('location_change_city')),
        changeCity ? findsOneWidget : findsNothing,
      );
      expect(find.textContaining('BridgeException'), findsNothing);
      expect(find.textContaining('$failure'), findsNothing);
    }

    await expectFailure(
      ForegroundCityClassificationBridgeFailure.timeout,
      'Tempo scaduto',
      'Non siamo riusciti a rilevare la posizione in tempo. Riprova.',
      changeCity: true,
    );
    await expectFailure(
      ForegroundCityClassificationBridgeFailure.positionReadFailed,
      'Qualcosa non ha funzionato',
      'Non siamo riusciti a completare la verifica. Riprova.',
      changeCity: true,
    );
    await expectFailure(
      ForegroundCityClassificationBridgeFailure.boundaryAssetFailed,
      'Qualcosa non ha funzionato',
      'Non siamo riusciti a completare la verifica. Riprova.',
      changeCity: true,
    );
    await expectFailure(
      ForegroundCityClassificationBridgeFailure.classificationFailed,
      'Qualcosa non ha funzionato',
      'Non siamo riusciti a completare la verifica. Riprova.',
      changeCity: true,
    );
    await expectFailure(
      ForegroundCityClassificationBridgeFailure.unsupportedCity,
      'Qualcosa non ha funzionato',
      'Non siamo riusciti a completare la verifica. Riprova.',
      changeCity: true,
    );
  });

  testWidgets(
      '26. busy keeps progress, clears busy flag, and allows later retry',
      (WidgetTester tester) async {
    final Completer<void> gate = Completer<void>();
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _GatedBusyBridge(gate: gate);

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pump();

    // Progress remains visible while the busy failure is still in-flight.
    expect(find.text('Verifica della posizione in corso…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Qualcosa non ha funzionato'), findsNothing);
    expect(find.textContaining('busy'), findsNothing);
    expect(bridge.callCount, 1);

    // Duplicate tap while busy must not start a second bridge call.
    await tester.tap(find.byKey(const Key('location_primary_action')));
    await tester.pump();
    expect(bridge.callCount, 1);

    gate.complete();
    await tester.pumpAndSettle();

    // After settle: no idle flash, progress copy kept, no technical error,
    // spinner gone, primary re-enabled for a later retry.
    expect(find.text('Verifica della posizione in corso…'), findsOneWidget);
    expect(find.text('Qualcosa non ha funzionato'), findsNothing);
    expect(find.textContaining('busy'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      find.widgetWithText(FilledButton, 'Verifica posizione'),
      findsOneWidget,
    );
    expect(bridge.callCount, 1);

    // Later normal retry can proceed once busy is cleared.
    bridge.failure = null;
    bridge.result = _result(
      city: 'Milano',
      containment: PointContainment.inside,
      accuracyMeters: 20,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(bridge.callCount, 2);
    expect(find.text('Posizione verificata'), findsOneWidget);
    expect(find.text('Verifica della posizione in corso…'), findsNothing);
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
  });

  testWidgets('27-28. Change city pops to Select City preserving selection',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.outside,
        accuracyMeters: 20,
      ),
    );
    final _RecordingNavigatorObserver observer = _RecordingNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  const Text('Seleziona la tua città'),
                  const Text('Milano'),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => LocationConfirmationScreen(
                            selectedCountry: 'Italy',
                            selectedCity: 'Milano',
                            permissionService: permission,
                            classificationBridge: bridge,
                          ),
                        ),
                      );
                    },
                    child: const Text('open-confirm'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('open-confirm'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    final int pushesBefore = observer.pushCount;

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Cambia città'), findsOneWidget);
    expect(bridge.callCount, 1);

    await tester.ensureVisible(find.byKey(const Key('location_change_city')));
    await tester.tap(find.widgetWithText(TextButton, 'Cambia città'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(observer.popCount, greaterThan(0));
    expect(bridge.callCount, 1);
    expect(find.byType(LocationConfirmationScreen), findsNothing);
    expect(find.text('Seleziona la tua città'), findsOneWidget);
    expect(find.text('Milano'), findsOneWidget);
    expect(pushesBefore, greaterThan(0));
  });

  testWidgets('29. Not now returns to WelcomeScreen',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );
    final _RecordingNavigatorObserver observer = _RecordingNavigatorObserver();

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: <NavigatorObserver>[observer],
        home: const WelcomeScreen(),
      ),
    );
    await tester.pump();

    final NavigatorState nav =
        tester.state<NavigatorState>(find.byType(Navigator));
    nav.push(
      MaterialPageRoute<void>(
        builder: (_) => LocationConfirmationScreen(
          selectedCountry: 'Italy',
          selectedCity: 'Milano',
          permissionService: permission,
          classificationBridge: bridge,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('location_not_now')));
    await tester.tap(find.widgetWithText(TextButton, 'Non ora'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(observer.popCount, greaterThan(0));
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.byType(LocationConfirmationScreen), findsNothing);
    expect(bridge.callCount, 0);
  });

  testWidgets('30. Back returns to Select City preserving city',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: SelectCityScreen(selectedCountry: 'Italy'),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Milano'));
    await tester.tap(find.text('Milano'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Continua'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LocationConfirmationScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Indietro'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(SelectCityScreen), findsOneWidget);
    expect(find.text('Seleziona la tua città'), findsOneWidget);
    expect(find.text('Milano'), findsOneWidget);
  });

  testWidgets('31-33. confirmed stays on screen; privacy visible; no Continue',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 15,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.byType(LocationConfirmationScreen), findsOneWidget);
    expect(find.text('Posizione verificata'), findsOneWidget);
    expect(find.text('Continua'), findsNothing);
    expect(find.text('Weiter'), findsNothing);
    expect(find.text('Perché è richiesta la posizione?'), findsOneWidget);
    expect(
      find.text(
        'Non memorizziamo né trasmettiamo le tue coordinate.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('34. privacy card remains visible after error',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      failure: ForegroundCityClassificationBridgeFailure.timeout,
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.text('Perché è richiesta la posizione?'), findsOneWidget);
    expect(
      find.text(
        'Usiamo la tua posizione solo una volta, in primo piano, per questa verifica.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('38. no automatic retry occurs', (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.granted);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      failure: ForegroundCityClassificationBridgeFailure.timeout,
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();
    expect(bridge.callCount, 1);
    await tester.pump(const Duration(seconds: 2));
    expect(bridge.callCount, 1);
  });

  testWidgets('bridge not called when permission denied',
      (WidgetTester tester) async {
    final _FakeLocationPermissionService permission =
        _FakeLocationPermissionService(state: ForegroundLocationState.denied);
    final _FakeClassificationBridge bridge = _FakeClassificationBridge(
      result: _result(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 10,
      ),
    );

    await _pumpScreen(
      tester,
      country: 'Italy',
      city: 'Milano',
      permission: permission,
      bridge: bridge,
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();
    expect(permission.ensureCalls, 1);
    expect(bridge.callCount, 0);
  });

  test('Accuracy thresholds remain good/limited/insufficient', () {
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

  test('3/37. screen verification flow does not use ForegroundPositionReader.readOnce',
      () {
    final String screen =
        File('lib/screens/location_confirmation_screen.dart').readAsStringSync();
    // Thresholds live in the reader file; the class itself must not be used.
    expect(screen.contains('ForegroundAccuracyThresholds'), isTrue);
    expect(screen.contains('ForegroundPositionReader'), isFalse);
    expect(screen.contains('readOnce'), isFalse);
    expect(screen.contains('positionReader'), isFalse);
    expect(screen.contains('getPositionStream'), isFalse);
    expect(screen.contains('getLastKnownPosition'), isFalse);
    expect(screen.contains('getCurrentPosition'), isFalse);
    expect(screen.contains('readAndClassifyOnce'), isTrue);
    expect(screen.contains('ForegroundCityClassificationBridge'), isTrue);
  });

  test('35/39 source scan of LocationConfirmationScreen', () {
    final String screen =
        File('lib/screens/location_confirmation_screen.dart').readAsStringSync();

    final List<String> report = <String>[];
    void note(String token, bool present, String explanation) {
      report.add('$token: ${present ? "PRESENT" : "absent"} — $explanation');
      if (present &&
          const <String>{
            'getCurrentPosition',
            'getPositionStream',
            'getLastKnownPosition',
            'latitude',
            'longitude',
            'GeoPoint',
            'SharedPreferences',
            'secure storage',
            'http',
            'dio',
            'analytics',
            'print(',
            'debugPrint(',
            'jsonEncode',
            'membership',
            'account',
            'payment',
            'eligible',
            'approved',
            'rejected',
            'Continue',
            'Continua',
            'Weiter',
          }.contains(token)) {
        // Hard-fail forbidden tokens except documented allowlist below.
        if (token == 'Continue' || token == 'Continua' || token == 'Weiter') {
          // Allowed only if absent from user-facing actions; assert absence.
          expect(screen.contains(token), isFalse, reason: report.last);
        } else if (token == 'http') {
          // package imports may include https? check word boundary
          expect(RegExp(r'\bhttp\b').hasMatch(screen), isFalse);
        } else if (token == 'print(') {
          expect(RegExp(r'\bprint\s*\(').hasMatch(screen), isFalse);
        } else {
          expect(screen.contains(token), isFalse, reason: report.last);
        }
      }
    }

    note(
      'ForegroundPositionReader.readOnce',
      screen.contains('readOnce'),
      'Must not call reader.readOnce in verification flow',
    );
    note(
      'getCurrentPosition',
      screen.contains('getCurrentPosition'),
      'Must not read GPS directly',
    );
    note(
      'getPositionStream',
      screen.contains('getPositionStream'),
      'Must not use streams',
    );
    note(
      'getLastKnownPosition',
      screen.contains('getLastKnownPosition'),
      'Must not use last-known position',
    );
    note(
      'Position',
      RegExp(r'\bPosition\b').hasMatch(screen),
      'Must not retain geolocator Position',
    );
    note(
      'latitude',
      screen.contains('latitude'),
      'Must not display/retain latitude',
    );
    note(
      'longitude',
      screen.contains('longitude'),
      'Must not display/retain longitude',
    );
    note('GeoPoint', screen.contains('GeoPoint'), 'Must not retain GeoPoint');
    note(
      'SharedPreferences',
      screen.contains('SharedPreferences'),
      'Must not persist',
    );
    note(
      'secure storage',
      screen.contains('secure storage'),
      'Must not persist',
    );
    note('http', RegExp(r'\bhttp\b').hasMatch(screen), 'Must not network');
    note('dio', screen.contains('dio'), 'Must not network');
    note('analytics', screen.contains('analytics'), 'Must not analytics');
    note('print(', RegExp(r'\bprint\s*\(').hasMatch(screen), 'Must not log');
    note('debugPrint(', screen.contains('debugPrint('), 'Must not log');
    note('jsonEncode', screen.contains('jsonEncode'), 'Must not serialize');
    note('membership', screen.contains('membership'), 'No membership flow');
    note('account', screen.contains('account'), 'No account flow');
    note('payment', screen.contains('payment'), 'No payment flow');
    note('eligible', screen.contains('eligible'), 'No eligibility');
    note('approved', screen.contains('approved'), 'No eligibility');
    note('rejected', screen.contains('rejected'), 'No eligibility');
    note('Continue', screen.contains('Continue'), 'No Continue action');
    note('Continua', screen.contains('Continua'), 'No Continua action');
    note('Weiter', screen.contains('Weiter'), 'No Weiter action');

    // Allowed intentional references:
    expect(screen.contains('ForegroundAccuracyThresholds'), isTrue);
    expect(screen.contains('PointContainment'), isTrue);
    expect(screen.contains('readAndClassifyOnce'), isTrue);

    // Ensure report was produced (for delivery).
    expect(report, isNotEmpty);
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

class _RecordingNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;
  int popCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount += 1;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    popCount += 1;
  }
}

class _BlockingPermissionService extends LocationPermissionService {
  _BlockingPermissionService({
    required this.state,
    required this.gate,
  });

  final ForegroundLocationState state;
  final Completer<void> gate;

  @override
  Future<ForegroundLocationState> ensureForegroundPermission() async {
    await gate.future;
    return state;
  }
}

class _GatedBridge extends _FakeClassificationBridge {
  _GatedBridge({
    required this.gate,
    required CityBoundaryClassificationResult result,
  }) : super(result: result);

  final Completer<void> gate;

  @override
  Future<CityBoundaryClassificationResult> readAndClassifyOnce({
    required String selectedCity,
  }) async {
    callCount += 1;
    cities.add(selectedCity);
    await gate.future;
    return result!;
  }
}

class _GatedBusyBridge extends _FakeClassificationBridge {
  _GatedBusyBridge({
    required this.gate,
  }) : super(failure: ForegroundCityClassificationBridgeFailure.busy);

  final Completer<void> gate;
  bool _busyEmitted = false;

  @override
  Future<CityBoundaryClassificationResult> readAndClassifyOnce({
    required String selectedCity,
  }) async {
    callCount += 1;
    cities.add(selectedCity);
    if (!_busyEmitted) {
      await gate.future;
      _busyEmitted = true;
      throw const ForegroundCityClassificationBridgeException(
        ForegroundCityClassificationBridgeFailure.busy,
      );
    }
    if (failure != null &&
        failure != ForegroundCityClassificationBridgeFailure.busy) {
      throw ForegroundCityClassificationBridgeException(failure!);
    }
    if (result != null) {
      return result!;
    }
    throw const ForegroundCityClassificationBridgeException(
      ForegroundCityClassificationBridgeFailure.busy,
    );
  }
}
