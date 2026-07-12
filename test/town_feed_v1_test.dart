import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/models/community_signal_mock.dart';
import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/town_feed_screen.dart';
import 'package:town_safe_space_mobile/screens/welcome_screen.dart';
import 'package:town_safe_space_mobile/services/city_boundary_classification_service.dart';
import 'package:town_safe_space_mobile/services/foreground_city_classification_bridge.dart';
import 'package:town_safe_space_mobile/services/location_permission_service.dart';
import 'package:town_safe_space_mobile/widgets/community_signal_card.dart';
import 'package:town_safe_space_mobile/widgets/visitor_civic_commitment_gate.dart';

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
  test('Feed mock catalog is exactly three Experience V1 Milano signals', () {
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
    expect(
      kMilanoFeedV1MockSignals[0].summary,
      'Le radici hanno sollevato il marciapiede. Bambini e anziani sono '
      'costretti sulla carreggiata.',
    );
    expect(
      kMilanoFeedV1MockSignals[1].summary,
      'Diversi lampioni non funzionano sul tratto pedonale. I residenti '
      'hanno già segnalato il Comune.',
    );
    expect(
      kMilanoFeedV1MockSignals[2].summary,
      'Il percorso temporaneo è stretto e poco segnalato. Servono tempi '
      'chiari e un passaggio più sicuro.',
    );
    expect(kMilanoFeedV1MockSignals[0].area, 'Città Studi');
    expect(kMilanoFeedV1MockSignals[1].area, 'Porta Romana');
    expect(kMilanoFeedV1MockSignals[2].area, 'Lorenteggio');
    expect(
      kMilanoFeedV1MockSignals[0].metaLine,
      'Marta Rinaldi · Osservato ieri',
    );
  });

  test('Feed assigns distinct landscape, portrait, and square media modes', () {
    expect(
      kMilanoFeedV1MockSignals[0].mediaPresentation,
      CivicMediaPresentation.landscape,
    );
    expect(
      kMilanoFeedV1MockSignals[1].mediaPresentation,
      CivicMediaPresentation.portrait,
    );
    expect(
      kMilanoFeedV1MockSignals[2].mediaPresentation,
      CivicMediaPresentation.square,
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

  testWidgets('Continue to TOWN opens rebuilt feed', (
    WidgetTester tester,
  ) async {
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

  testWidgets('Feed renders scene 1 with exact Experience V1 copy', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);

    expect(find.byType(CommunitySignalCard), findsOneWidget);
    expect(find.byKey(const Key('town_feed_page_view')), findsOneWidget);
    expect(find.byKey(const Key('scene_brand')), findsOneWidget);
    expect(find.byKey(const Key('scene_veil')), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('TOWN'), findsWidgets);
    expect(find.text('Marta Rinaldi · Osservato ieri'), findsOneWidget);
    expect(find.text('SPAZIO PUBBLICO'), findsOneWidget);
    expect(
      find.text('Marciapiede danneggiato davanti alla scuola di via Padova'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Le radici hanno sollevato il marciapiede. Bambini e anziani sono '
        'costretti sulla carreggiata.',
      ),
      findsOneWidget,
    );
    expect(find.text('Locally confirmed'), findsOneWidget);
    expect(find.text('Città Studi'), findsOneWidget);
    expect(find.text('Confirmed by 18 people nearby'), findsOneWidget);
    expect(find.text('I SEE THIS TOO'), findsOneWidget);
    expect(find.text('Open signal'), findsOneWidget);
  });

  testWidgets('no Home bar and no Flutter-only city header', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);

    expect(find.text('Home'), findsNothing);
    expect(find.byKey(const Key('town_feed_home_shell')), findsNothing);
    expect(find.byKey(const Key('town_feed_home_label')), findsNothing);
    expect(find.text('Milano · Community Signals'), findsNothing);
    expect(find.text('Milano · Città Studi'), findsNothing);
    expect(find.text('Residente del quartiere'), findsNothing);
    expect(find.text('Via Padova · Città Studi · Milano'), findsNothing);
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
    expect(find.text('Chiara Valli · Segnalato due giorni fa'), findsOneWidget);
    expect(find.text('Reported'), findsOneWidget);
    expect(find.text('Porta Romana'), findsOneWidget);
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
    expect(find.text('Lorenteggio'), findsOneWidget);
    expect(find.text('Confirmed by 7 people nearby'), findsOneWidget);

    await tester.fling(pageView, const Offset(0, -500), 2000);
    await tester.pumpAndSettle();
    expect(find.text('3 / 3'), findsOneWidget);
    expect(find.text('1 / 3'), findsNothing);
  });

  testWidgets('every visible scene exposes required Experience V1 fields', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));
    final List<String> areas = <String>[
      'Città Studi',
      'Porta Romana',
      'Lorenteggio',
    ];

    for (int i = 0; i < 3; i++) {
      expect(find.text(areas[i]), findsOneWidget);
      expect(find.text('I SEE THIS TOO'), findsOneWidget);
      expect(find.text('Open signal'), findsOneWidget);
      expect(find.textContaining('Confirmed by'), findsOneWidget);
      expect(find.text('${i + 1} / 3'), findsOneWidget);
      expect(find.byKey(const Key('scene_veil')), findsWidgets);
      if (i < 2) {
        await tester.fling(pageView, const Offset(0, -500), 2000);
        await tester.pumpAndSettle();
      }
    }
  });

  testWidgets('I SEE THIS TOO opens membership invitation without confirming', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    const String firstHeadline =
        'Marciapiede danneggiato davanti alla scuola di via Padova';

    expect(find.text('Confirmed by 18 people nearby'), findsOneWidget);
    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();

    // Count must not increase; button must not flip to confirmed.
    expect(find.text('Confirmed by 18 people nearby'), findsOneWidget);
    expect(find.text('Confirmed by 19 people nearby'), findsNothing);
    expect(find.text('You confirmed this locally'), findsNothing);
    expect(find.text(firstHeadline), findsOneWidget);

    expect(
      find.byKey(const Key('visitor_membership_invitation')),
      findsOneWidget,
    );
    expect(
      find.text(VisitorCivicCommitmentCopy.invitationTitle),
      findsOneWidget,
    );
    expect(
      find.text(VisitorCivicCommitmentCopy.invitationBody),
      findsOneWidget,
    );
    expect(
      find.text(VisitorCivicCommitmentCopy.invitationBodySecond),
      findsOneWidget,
    );
    expect(find.text(VisitorCivicCommitmentCopy.joinAction), findsOneWidget);
    expect(find.text(VisitorCivicCommitmentCopy.notNowAction), findsOneWidget);

    // Feed swipe blocked while invitation is open.
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));
    await tester.drag(pageView, const Offset(0, -700), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('2 / 3'), findsNothing);
  });

  testWidgets('Join your community shows temporary next-phase placeholder', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visitor_join_community')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('visitor_join_placeholder')), findsOneWidget);
    expect(
      find.text(VisitorCivicCommitmentCopy.joinPlaceholderTitle),
      findsOneWidget,
    );
    expect(
      find.text(VisitorCivicCommitmentCopy.joinPlaceholderBody),
      findsOneWidget,
    );
    expect(find.text('Confirmed by 18 people nearby'), findsOneWidget);
    expect(find.text('You confirmed this locally'), findsNothing);

    await tester.tap(find.byKey(const Key('visitor_join_placeholder_close')));
    await tester.pumpAndSettle();

    // Close returns to membership invitation, not free browsing.
    expect(find.byKey(const Key('visitor_join_placeholder')), findsNothing);
    expect(
      find.byKey(const Key('visitor_membership_invitation')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('town_feed_page_view')), findsOneWidget);
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));
    await tester.drag(pageView, const Offset(0, -700), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('Not now ends experience; Leave TOWN returns to Welcome', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    await tester.pumpAndSettle();

    // Push feed onto Welcome so Leave TOWN can pop back.
    final NavigatorState navigator = tester.state<NavigatorState>(
      find.byType(Navigator),
    );
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const TownFeedScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TownFeedScreen), findsOneWidget);
    expect(find.text('I SEE THIS TOO'), findsOneWidget);

    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visitor_not_now')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('visitor_experience_ended')), findsOneWidget);
    expect(find.byKey(const Key('town_feed_page_view')), findsNothing);
    expect(find.text('I SEE THIS TOO'), findsNothing);
    expect(find.text('Open signal'), findsNothing);
    expect(find.text(VisitorCivicCommitmentCopy.endedTitle), findsOneWidget);
    expect(find.text(VisitorCivicCommitmentCopy.endedBody), findsOneWidget);
    expect(
      find.text(VisitorCivicCommitmentCopy.leaveTownAction),
      findsOneWidget,
    );
    expect(find.text('Back'), findsNothing);
    expect(find.text('Continue browsing'), findsNothing);
    expect(find.text('Maybe later'), findsNothing);

    await tester.tap(find.byKey(const Key('visitor_leave_town')));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(TownFeedScreen), findsNothing);
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('Open signal shows approved sheet hierarchy', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    await tester.tap(find.byKey(const Key('signal_open_milano-signal-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('open_signal_sheet_title')), findsOneWidget);
    expect(find.text(TownFeedScreen.openSignalSheetTitle), findsOneWidget);
    expect(
      find.byKey(const Key('open_signal_prototype_message')),
      findsOneWidget,
    );
    expect(
      find.text(TownFeedScreen.openSignalPrototypeMessage),
      findsOneWidget,
    );
    expect(find.text('Close'), findsOneWidget);

    await tester.tap(find.byKey(const Key('open_signal_prototype_close')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('open_signal_sheet_title')), findsNothing);
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
    expect(find.textContaining('follower'), findsNothing);
    expect(find.textContaining('Share'), findsNothing);
    expect(find.textContaining('TikTok'), findsNothing);
    expect(find.textContaining('Substack'), findsNothing);
    expect(find.textContaining('trending'), findsNothing);
  });

  testWidgets('feed image assets are local photorealistic jpgs', (
    WidgetTester tester,
  ) async {
    expect(
      kMilanoFeedV1MockSignals.every(
        (CommunitySignalMock s) =>
            s.imageAsset.startsWith('assets/images/feed/') &&
            s.imageAsset.endsWith('.jpg'),
      ),
      isTrue,
    );
    await _pumpFeed(tester);
    expect(
      find.byKey(const Key('signal_image_milano-signal-1')),
      findsOneWidget,
    );
  });

  testWidgets('representative viewports have no overflow', (
    WidgetTester tester,
  ) async {
    final List<Size> sizes = <Size>[
      const Size(320, 568),
      const Size(375, 812),
      const Size(390, 844),
      const Size(430, 932),
      const Size(440, 956),
    ];

    addTearDown(() => tester.binding.setSurfaceSize(null));

    for (final Size size in sizes) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(const MaterialApp(home: TownFeedScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'overflow at $size');
      expect(find.text('I SEE THIS TOO'), findsOneWidget, reason: '$size');
      expect(find.text('Open signal'), findsOneWidget, reason: '$size');
      expect(find.text('1 / 3'), findsOneWidget, reason: '$size');
      expect(
        find.byKey(const Key('scene_veil')),
        findsWidgets,
        reason: '$size',
      );

      final Finder pageView = find.byKey(const Key('town_feed_page_view'));
      await tester.drag(pageView, Offset(0, -size.height * 0.85));
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: 'scene2 overflow at $size',
      );
      expect(find.text('2 / 3'), findsOneWidget, reason: '$size');
    }
  });

  testWidgets('each PageView child expands to the full viewport', (
    WidgetTester tester,
  ) async {
    const Size size = Size(390, 844);
    await _pumpFeed(tester, size: size);

    final Size cardSize = tester.getSize(
      find.byKey(const Key('town_feed_card_0')),
    );
    expect(cardSize.width, size.width);
    expect(cardSize.height, size.height);
  });
}
