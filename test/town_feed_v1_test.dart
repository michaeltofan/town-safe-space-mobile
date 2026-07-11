import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/models/community_signal_mock.dart';
import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/town_feed_screen.dart';
import 'package:town_safe_space_mobile/services/city_boundary_classification_service.dart';
import 'package:town_safe_space_mobile/services/foreground_city_classification_bridge.dart';
import 'package:town_safe_space_mobile/services/location_permission_service.dart';
import 'package:town_safe_space_mobile/widgets/community_signal_card.dart';

class _FakePermission extends LocationPermissionService {
  _FakePermission(this.state);

  final ForegroundLocationState state;

  @override
  Future<ForegroundLocationState> ensureForegroundPermission() async => state;
}

class _FakeBridge extends ForegroundCityClassificationBridge {
  _FakeBridge({this.result, this.failure});

  final CityBoundaryClassificationResult? result;
  final ForegroundCityClassificationBridgeFailure? failure;

  @override
  Future<CityBoundaryClassificationResult> readAndClassifyOnce({
    required String selectedCity,
  }) async {
    if (failure != null) {
      throw ForegroundCityClassificationBridgeException(failure!);
    }
    return result!;
  }
}

CityBoundaryClassificationResult _inside({required int accuracy}) {
  return CityBoundaryClassificationResult(
    city: 'Milano',
    containment: PointContainment.inside,
    accuracyMeters: accuracy,
    classifiedAt: DateTime.utc(2026, 1, 1),
  );
}

Future<void> _pumpLocation(
  WidgetTester tester, {
  required _FakePermission permission,
  required _FakeBridge bridge,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: LocationConfirmationScreen(
        selectedCountry: 'Italy',
        selectedCity: 'Milano',
        permissionService: permission,
        classificationBridge: bridge,
      ),
    ),
  );
  await tester.pump();
}

Future<void> _pumpFeed(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(const MaterialApp(home: TownFeedScreen()));
  await tester.pumpAndSettle();
}

void main() {
  test('Feed V1 mock catalog is exactly three fictional Milano signals', () {
    expect(kMilanoFeedV1MockSignals, hasLength(3));
    expect(
      kMilanoFeedV1MockSignals[0].status,
      CommunitySignalStatus.locallyConfirmed,
    );
    expect(kMilanoFeedV1MockSignals[1].status, CommunitySignalStatus.reported);
    expect(
      kMilanoFeedV1MockSignals[2].status,
      CommunitySignalStatus.inProgress,
    );
    expect(
      kMilanoFeedV1MockSignals[0].headline,
      'Marciapiede danneggiato davanti alla scuola di via Padova',
    );
  });

  testWidgets('eligible confirmedGood shows Continue to TOWN', (
    WidgetTester tester,
  ) async {
    await _pumpLocation(
      tester,
      permission: _FakePermission(ForegroundLocationState.granted),
      bridge: _FakeBridge(result: _inside(accuracy: 20)),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('continue_to_town')), findsOneWidget);
    expect(find.text('Continue to TOWN'), findsOneWidget);
  });

  testWidgets('eligible confirmedLimited shows Continue to TOWN', (
    WidgetTester tester,
  ) async {
    await _pumpLocation(
      tester,
      permission: _FakePermission(ForegroundLocationState.granted),
      bridge: _FakeBridge(result: _inside(accuracy: 90)),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('continue_to_town')), findsOneWidget);
    expect(find.text('Riprova'), findsOneWidget);
  });

  testWidgets('ineligible states do not show Continue to TOWN', (
    WidgetTester tester,
  ) async {
    Future<void> expectAbsent({
      required ForegroundLocationState permission,
      CityBoundaryClassificationResult? result,
      ForegroundCityClassificationBridgeFailure? failure,
    }) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        MaterialApp(
          home: LocationConfirmationScreen(
            key: UniqueKey(),
            selectedCountry: 'Italy',
            selectedCity: 'Milano',
            permissionService: _FakePermission(permission),
            classificationBridge: _FakeBridge(result: result, failure: failure),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('continue_to_town')), findsNothing);
      expect(find.text('Continue to TOWN'), findsNothing);
    }

    await expectAbsent(permission: ForegroundLocationState.denied);
    await expectAbsent(permission: ForegroundLocationState.serviceDisabled);
    await expectAbsent(
      permission: ForegroundLocationState.granted,
      failure: ForegroundCityClassificationBridgeFailure.timeout,
    );
    await expectAbsent(
      permission: ForegroundLocationState.granted,
      result: CityBoundaryClassificationResult(
        city: 'Milano',
        containment: PointContainment.outside,
        accuracyMeters: 20,
        classifiedAt: DateTime.utc(2026, 1, 1),
      ),
    );
    await expectAbsent(
      permission: ForegroundLocationState.granted,
      result: CityBoundaryClassificationResult(
        city: 'Milano',
        containment: PointContainment.inside,
        accuracyMeters: 250,
        classifiedAt: DateTime.utc(2026, 1, 1),
      ),
    );
  });

  testWidgets('Continue to TOWN opens Feed V1', (WidgetTester tester) async {
    await _pumpLocation(
      tester,
      permission: _FakePermission(ForegroundLocationState.granted),
      bridge: _FakeBridge(result: _inside(accuracy: 15)),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Verifica posizione'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('continue_to_town')));
    await tester.pumpAndSettle();

    expect(find.byType(TownFeedScreen), findsOneWidget);
    expect(find.byType(CommunitySignalCard), findsWidgets);
  });

  testWidgets('Feed V1 renders exactly 3 cards and first Milano content', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);

    expect(find.byType(CommunitySignalCard), findsOneWidget);
    expect(find.byKey(const Key('town_feed_page_view')), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(
      find.text('Marciapiede danneggiato davanti alla scuola di via Padova'),
      findsOneWidget,
    );
    expect(find.text('Locally confirmed'), findsOneWidget);
    expect(find.text('Milano · Città Studi'), findsWidgets);
    expect(find.text('Confirmed by 18 people nearby'), findsOneWidget);
    expect(find.text('I SEE THIS TOO'), findsOneWidget);
    expect(find.text('Open signal'), findsOneWidget);
    expect(find.text('SPAZIO PUBBLICO'), findsOneWidget);
    expect(find.text('Marta Rinaldi'), findsOneWidget);
  });

  testWidgets('vertical swipe moves 1→2→3 and does not loop', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));

    await tester.fling(pageView, const Offset(0, -500), 2000);
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);
    expect(
      find.text('Il percorso vicino alla scuola resta al buio la sera'),
      findsOneWidget,
    );
    expect(find.text('Reported'), findsOneWidget);
    expect(find.text('Confirmed by 11 people nearby'), findsOneWidget);

    await tester.fling(pageView, const Offset(0, -500), 2000);
    await tester.pumpAndSettle();
    expect(find.text('3 / 3'), findsOneWidget);
    expect(
      find.text(
        'Il cantiere restringe il passaggio pedonale senza indicazioni chiare',
      ),
      findsOneWidget,
    );
    expect(find.text('In progress'), findsOneWidget);
    expect(find.text('Confirmed by 7 people nearby'), findsOneWidget);

    // Attempt to go past last card — must stay on 3 / 3.
    await tester.fling(pageView, const Offset(0, -500), 2000);
    await tester.pumpAndSettle();
    expect(find.text('3 / 3'), findsOneWidget);
    expect(find.text('1 / 3'), findsNothing);
  });

  testWidgets('every visible card exposes required civic fields', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));

    for (int i = 0; i < 3; i++) {
      expect(find.textContaining('Milano'), findsWidgets);
      expect(find.text('I SEE THIS TOO'), findsOneWidget);
      expect(find.text('Open signal'), findsOneWidget);
      expect(find.textContaining('Confirmed by'), findsOneWidget);
      expect(find.text('${i + 1} / 3'), findsOneWidget);
      if (i < 2) {
        await tester.fling(pageView, const Offset(0, -500), 2000);
        await tester.pumpAndSettle();
      }
    }
  });

  testWidgets('I SEE THIS TOO increments once, updates copy, no reorder', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    final String firstHeadline =
        'Marciapiede danneggiato davanti alla scuola di via Padova';

    expect(find.text('Confirmed by 18 people nearby'), findsOneWidget);
    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();

    expect(find.text('Confirmed by 19 people nearby'), findsOneWidget);
    expect(find.text('You confirmed this locally'), findsOneWidget);
    expect(find.text('I SEE THIS TOO'), findsNothing);
    expect(find.text(firstHeadline), findsOneWidget);

    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();
    expect(find.text('Confirmed by 19 people nearby'), findsOneWidget);
    expect(find.text(firstHeadline), findsOneWidget);

    // Other cards unchanged when not visited/confirmed.
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));
    await tester.fling(pageView, const Offset(0, -500), 2000);
    await tester.pumpAndSettle();
    expect(find.text('Confirmed by 11 people nearby'), findsOneWidget);
    expect(find.text('I SEE THIS TOO'), findsOneWidget);
  });

  testWidgets('Open signal shows controlled prototype message', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    await tester.tap(find.byKey(const Key('signal_open_milano-signal-1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('open_signal_prototype_message')),
      findsOneWidget,
    );
    expect(
      find.text(TownFeedScreen.openSignalPrototypeMessage),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('open_signal_prototype_close')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('open_signal_prototype_message')),
      findsNothing,
    );
  });

  testWidgets('no forbidden social metrics or third-party branding', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    expect(find.textContaining('like'), findsNothing);
    expect(find.textContaining('Like'), findsNothing);
    expect(find.textContaining('heart'), findsNothing);
    expect(find.textContaining('followers'), findsNothing);
    expect(find.textContaining('views'), findsNothing);
    expect(find.textContaining('trending'), findsNothing);
    expect(find.textContaining('Substack'), findsNothing);
    expect(find.textContaining('TikTok'), findsNothing);
    expect(find.textContaining('restack'), findsNothing);
  });

  testWidgets('no internal scrollable card content', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    final Finder card = find.byType(CommunitySignalCard);
    expect(
      find.descendant(of: card, matching: find.byType(SingleChildScrollView)),
      findsNothing,
    );
    expect(
      find.descendant(of: card, matching: find.byType(ListView)),
      findsNothing,
    );
  });

  testWidgets('smallest supported mobile viewport has no overflow', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester, size: const Size(320, 568));
    expect(tester.takeException(), isNull);
    expect(find.byType(TownFeedScreen), findsOneWidget);
    expect(find.text('I SEE THIS TOO'), findsOneWidget);
    expect(find.text('Open signal'), findsOneWidget);
    expect(
      find.text('Marciapiede danneggiato davanti alla scuola di via Padova'),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('signal_summary_milano-signal-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('signal_image_milano-signal-1')),
      findsOneWidget,
    );
  });

  testWidgets('feed image assets are local photorealistic jpgs', (
    WidgetTester tester,
  ) async {
    expect(kMilanoFeedV1MockSignals.map((s) => s.imageAsset).toList(), <String>[
      'assets/images/feed/signal_citta_studi_pavement.jpg',
      'assets/images/feed/signal_porta_romana_lighting.jpg',
      'assets/images/feed/signal_lorenteggio_works.jpg',
    ]);
    await _pumpFeed(tester);
    expect(
      find.byKey(const Key('signal_image_milano-signal-1')),
      findsOneWidget,
    );
    final Image image = tester.widget<Image>(
      find.byKey(const Key('signal_image_milano-signal-1')),
    );
    expect(image.image, isA<AssetImage>());
    expect(
      (image.image as AssetImage).assetName,
      'assets/images/feed/signal_citta_studi_pavement.jpg',
    );
  });

  testWidgets('shell shows only Home as active destination', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);

    expect(find.byKey(const Key('town_feed_home_shell')), findsOneWidget);
    expect(find.byKey(const Key('town_feed_home_label')), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    // Unfinished shell controls must not appear as functional UI.
    expect(find.byIcon(Icons.search), findsNothing);
    expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
    expect(find.text('Esplora'), findsNothing);
    expect(find.text('Attività'), findsNothing);
    expect(find.text('Salvati'), findsNothing);
    expect(find.text('Profilo'), findsNothing);
    expect(find.text('Per te'), findsNothing);
    expect(find.text('Spazio pubblico'), findsNothing);
    expect(find.text('Illuminazione'), findsNothing);
  });

  testWidgets('removed unfinished shell controls expose no interactions', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);

    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(IconButton), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('town_feed_home_shell')),
        matching: find.byType(GestureDetector),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('town_feed_home_shell')),
        matching: find.byType(InkWell),
      ),
      findsNothing,
    );

    // Civic actions remain interactive.
    expect(
      find.byKey(const Key('signal_confirm_milano-signal-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('signal_open_milano-signal-1')),
      findsOneWidget,
    );
  });
}
