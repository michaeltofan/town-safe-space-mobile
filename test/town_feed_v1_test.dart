import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/geometry/point_in_polygon_engine.dart';
import 'package:town_safe_space_mobile/models/community_signal_mock.dart';
import 'package:town_safe_space_mobile/models/town_feed_copy.dart';
import 'package:town_safe_space_mobile/screens/account_creation_screen.dart';
import 'package:town_safe_space_mobile/screens/account_setup_introduction_screen.dart';
import 'package:town_safe_space_mobile/screens/location_confirmation_screen.dart';
import 'package:town_safe_space_mobile/screens/membership_entry_screen.dart';
import 'package:town_safe_space_mobile/screens/town_feed_screen.dart';
import 'package:town_safe_space_mobile/screens/welcome_screen.dart';
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

CityBoundaryClassificationResult _inside({
  required int accuracy,
  String city = 'Milano',
}) {
  return CityBoundaryClassificationResult(
    city: city,
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
  String selectedCountry = 'Italy',
  String selectedCity = 'Milano',
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: TownFeedScreen(
        selectedCountry: selectedCountry,
        selectedCity: selectedCity,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpLocationForCity(
  WidgetTester tester, {
  required String country,
  required String city,
  required _FakePermission permission,
  required _FakeBridge bridge,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: LocationConfirmationScreen(
        selectedCountry: country,
        selectedCity: city,
        permissionService: permission,
        classificationBridge: bridge,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  const TownFeedCopy italianCopy = TownFeedCopy.italian();
  const TownFeedCopy germanCopy = TownFeedCopy.german();

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
    expect(
      find.text('Marciapiede danneggiato davanti alla scuola di via Padova'),
      findsOneWidget,
    );
    expect(find.text('Città Studi'), findsOneWidget);
    expect(find.text('Apri segnale'), findsOneWidget);
    expect(
      find.text('Der Gehweg ist hier kaum noch sicher passierbar.'),
      findsNothing,
    );
  });

  testWidgets('Germany Munich Continue to TOWN opens German Munich feed', (
    WidgetTester tester,
  ) async {
    await _pumpLocationForCity(
      tester,
      country: 'Germany',
      city: 'Munich',
      permission: _FakePermission(ForegroundLocationState.granted),
      bridge: _FakeBridge(result: _inside(accuracy: 15, city: 'Munich')),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Standort prüfen'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('continue_to_town')));
    await tester.pumpAndSettle();

    final TownFeedScreen feed = tester.widget(find.byType(TownFeedScreen));
    expect(feed.selectedCountry, 'Germany');
    expect(feed.selectedCity, 'Munich');
    expect(find.text('Schwabing'), findsOneWidget);
    expect(
      find.text('Der Gehweg ist hier kaum noch sicher passierbar.'),
      findsOneWidget,
    );
    expect(find.text('ÖFFENTLICHER RAUM'), findsOneWidget);
    expect(find.text('Lokal bestätigt'), findsOneWidget);
    expect(find.text('ICH SEHE DAS AUCH'), findsOneWidget);
    expect(find.text('Signal öffnen'), findsOneWidget);
    expect(find.text('Von 16 Menschen in der Nähe bestätigt'), findsOneWidget);
    expect(
      find.text('Marciapiede danneggiato davanti alla scuola di via Padova'),
      findsNothing,
    );
    expect(find.text('Città Studi'), findsNothing);
    expect(find.text('Open signal'), findsNothing);
    expect(find.text('I SEE THIS TOO'), findsNothing);
    expect(find.text('Apri segnale'), findsNothing);
    expect(find.text('LO VEDO ANCH’IO'), findsNothing);
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
    expect(find.text(italianCopy.statusLocallyConfirmed), findsOneWidget);
    expect(find.text('Città Studi'), findsOneWidget);
    expect(find.text(italianCopy.confirmationCount(18)), findsOneWidget);
    expect(find.text(italianCopy.seeThisToo), findsOneWidget);
    expect(find.text(italianCopy.openSignalAction), findsOneWidget);
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
    expect(find.text(italianCopy.statusReported), findsOneWidget);
    expect(find.text('Porta Romana'), findsOneWidget);
    expect(find.text(italianCopy.confirmationCount(11)), findsOneWidget);

    await tester.fling(pageView, const Offset(0, -500), 2000);
    await tester.pumpAndSettle();
    expect(find.text('3 / 3'), findsOneWidget);
    expect(
      find.text(
        'Il cantiere restringe il passaggio pedonale senza indicazioni chiare',
      ),
      findsOneWidget,
    );
    expect(find.text(italianCopy.statusInProgress), findsOneWidget);
    expect(find.text('Lorenteggio'), findsOneWidget);
    expect(find.text(italianCopy.confirmationCount(7)), findsOneWidget);

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
      expect(find.text(italianCopy.seeThisToo), findsOneWidget);
      expect(find.text(italianCopy.openSignalAction), findsOneWidget);
      expect(find.textContaining('Confermato da'), findsOneWidget);
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

    expect(find.text(italianCopy.confirmationCount(18)), findsOneWidget);
    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();

    // Count must not increase; button must not flip to confirmed.
    expect(find.text(italianCopy.confirmationCount(18)), findsOneWidget);
    expect(find.text(italianCopy.confirmationCount(19)), findsNothing);
    expect(find.text(italianCopy.youConfirmedLocally), findsNothing);
    expect(find.text(firstHeadline), findsOneWidget);

    expect(
      find.byKey(const Key('visitor_membership_invitation')),
      findsOneWidget,
    );
    expect(
      find.text(italianCopy.visitorInvitationTitle),
      findsOneWidget,
    );
    expect(
      find.text(italianCopy.visitorInvitationBody),
      findsOneWidget,
    );
    expect(
      find.text(italianCopy.visitorInvitationBodySecond),
      findsOneWidget,
    );
    expect(find.text(italianCopy.visitorJoinAction), findsOneWidget);
    expect(find.text(italianCopy.visitorNotNowAction), findsOneWidget);

    // Feed swipe blocked while invitation is open.
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));
    await tester.drag(pageView, const Offset(0, -700), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
    expect(find.text('2 / 3'), findsNothing);
  });

  testWidgets('Join your community opens Membership Entry Screen', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visitor_join_community')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('membership_entry_screen')), findsOneWidget);
    expect(find.byType(MembershipEntryScreen), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryLabel), findsOneWidget);
    expect(
      find.text(italianCopy.membershipEntryHeadline('Milano')),
      findsOneWidget,
    );
    expect(find.text(italianCopy.membershipEntryBody), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryBodySecond), findsOneWidget);
    expect(find.byKey(const Key('membership_entry_price')), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryPrice), findsOneWidget);
    expect(find.text('€12 all’anno'), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryRenewal), findsOneWidget);
    expect(
      find.text(italianCopy.membershipEntryRenewalSecond),
      findsOneWidget,
    );
    expect(
      find.text(italianCopy.membershipEntryConditionsTitle),
      findsOneWidget,
    );
    expect(find.byKey(const Key('membership_entry_conditions')), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryCondition1), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryCondition2), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryCondition3), findsOneWidget);
    expect(find.byKey(const Key('membership_entry_rights')), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryRights), findsOneWidget);
    expect(find.text(italianCopy.membershipEntryContinue), findsOneWidget);
    expect(
      find.text(italianCopy.membershipEntrySecondaryBack),
      findsOneWidget,
    );
    expect(find.text(italianCopy.confirmationCount(18)), findsNothing);
    expect(find.byKey(const Key('visitor_join_placeholder')), findsNothing);

    await tester.tap(find.byKey(const Key('membership_entry_back')));
    await tester.pumpAndSettle();

    // Back returns to membership invitation, not free browsing.
    expect(find.byKey(const Key('membership_entry_screen')), findsNothing);
    expect(
      find.byKey(const Key('visitor_membership_invitation')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('town_feed_page_view')), findsOneWidget);
    expect(find.text(italianCopy.confirmationCount(18)), findsOneWidget);
    expect(find.text(italianCopy.youConfirmedLocally), findsNothing);
    final Finder pageView = find.byKey(const Key('town_feed_page_view'));
    await tester.drag(pageView, const Offset(0, -700), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets(
    'Milano Continua opens Account Setup Introduction with Italian copy',
    (WidgetTester tester) async {
      await _pumpFeed(tester);
      await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('visitor_join_community')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('membership_entry_continue')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('account_setup_intro_screen')),
        findsOneWidget,
      );
      expect(find.byType(AccountSetupIntroductionScreen), findsOneWidget);
      final AccountSetupIntroductionScreen intro = tester.widget(
        find.byType(AccountSetupIntroductionScreen),
      );
      expect(intro.selectedCountry, 'Italy');
      expect(intro.selectedCity, 'Milano');

      expect(
        find.byKey(const Key('account_setup_intro_label')),
        findsOneWidget,
      );
      expect(find.text(italianCopy.accountSetupIntroLabel), findsOneWidget);
      expect(find.text(italianCopy.accountSetupIntroHeadline), findsOneWidget);
      expect(find.text(italianCopy.accountSetupIntroBody), findsOneWidget);
      expect(
        find.byKey(const Key('account_setup_intro_why')),
        findsOneWidget,
      );
      expect(find.text(italianCopy.accountSetupIntroWhyTitle), findsOneWidget);
      expect(find.text(italianCopy.accountSetupIntroWhyBody), findsOneWidget);
      expect(
        find.text(italianCopy.accountSetupIntroWhyBodySecond),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_setup_intro_verification')),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroVerificationTitle),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroVerification1),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroVerification2),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroVerification3),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_setup_intro_privacy')),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroPrivacyTitle),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroPrivacyBody),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountSetupIntroPrivacyBodySecond),
        findsOneWidget,
      );
      expect(find.text(italianCopy.accountSetupIntroStart), findsOneWidget);
      expect(
        find.text(italianCopy.accountSetupIntroSecondaryBack),
        findsOneWidget,
      );

      // Inizia opens the single Account Creation Screen (email step).
      await tester.tap(find.byKey(const Key('account_setup_intro_start')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('account_creation_screen')), findsOneWidget);
      expect(find.byType(AccountCreationScreen), findsOneWidget);
      expect(
        find.byKey(const Key('account_creation_email_step')),
        findsOneWidget,
      );
      expect(find.text(italianCopy.accountCreationEmailLabel), findsOneWidget);
      expect(
        find.text(italianCopy.accountCreationEmailHeadline),
        findsOneWidget,
      );

      // Empty Italian email error.
      await tester.tap(find.byKey(const Key('account_creation_email_continue')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_email_error')),
        findsOneWidget,
      );
      expect(find.text(italianCopy.accountCreationEmailEmpty), findsOneWidget);
      expect(
        find.byKey(const Key('account_creation_email_step')),
        findsOneWidget,
      );

      // Invalid Italian email error.
      await tester.enterText(
        find.byKey(const Key('account_creation_email_field')),
        'not-an-email',
      );
      await tester.tap(find.byKey(const Key('account_creation_email_continue')));
      await tester.pumpAndSettle();
      expect(
        find.text(italianCopy.accountCreationEmailInvalid),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_creation_code_step')),
        findsNothing,
      );

      // Valid email advances to code step on the same screen.
      const String testEmail = 'prova@esempio.it';
      await tester.enterText(
        find.byKey(const Key('account_creation_email_field')),
        '  $testEmail  ',
      );
      await tester.tap(find.byKey(const Key('account_creation_email_continue')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('account_creation_screen')), findsOneWidget);
      expect(
        find.byKey(const Key('account_creation_code_step')),
        findsOneWidget,
      );
      expect(find.text(testEmail), findsOneWidget);
      expect(find.text(italianCopy.accountCreationCodeLabel), findsOneWidget);
      expect(
        find.text(italianCopy.accountCreationCodePrototypeNote),
        findsOneWidget,
      );

      // Wrong code stays on code step.
      await tester.enterText(
        find.byKey(const Key('account_creation_code_field')),
        '000000',
      );
      await tester.tap(find.byKey(const Key('account_creation_code_verify')));
      await tester.pumpAndSettle();
      expect(find.text(italianCopy.accountCreationCodeInvalid), findsOneWidget);
      expect(
        find.byKey(const Key('account_creation_code_step')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_creation_passkey_step')),
        findsNothing,
      );

      // 123456 advances to passkey step.
      await tester.enterText(
        find.byKey(const Key('account_creation_code_field')),
        '123456',
      );
      await tester.tap(find.byKey(const Key('account_creation_code_verify')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_passkey_step')),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountCreationPasskeyLabel),
        findsOneWidget,
      );

      // Passkey dialog → simulate → account-ready step.
      await tester.tap(find.byKey(const Key('account_creation_passkey_create')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_passkey_prototype_dialog')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('account_creation_passkey_simulate')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_ready_step')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_creation_email_verified_status')),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountCreationReadyEmailStatus),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_creation_passkey_status')),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountCreationReadyPasskeyStatus),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountCreationReadyNextStep),
        findsOneWidget,
      );
      expect(find.text('Account created'), findsNothing);
      expect(find.text('Membership active'), findsNothing);
      expect(find.text('Payment complete'), findsNothing);
      expect(find.text('Subscription active'), findsNothing);
      expect(find.text('Local verification complete'), findsNothing);

      // Payment boundary; dismiss stays on ready.
      await tester.tap(
        find.byKey(const Key('account_creation_continue_membership')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_payment_boundary_dialog')),
        findsOneWidget,
      );
      expect(
        find.text(italianCopy.accountCreationPaymentBoundaryMessage),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('account_creation_payment_boundary_dismiss')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_payment_boundary_dialog')),
        findsNothing,
      );
      expect(
        find.byKey(const Key('account_creation_ready_step')),
        findsOneWidget,
      );

      // Step-by-step back inside the same route.
      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_passkey_step')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_code_step')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_email_step')),
        findsOneWidget,
      );

      // Back from email returns to Account Setup Introduction.
      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_setup_intro_screen')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('account_creation_screen')), findsNothing);

      await tester.tap(find.byKey(const Key('account_setup_intro_back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('membership_entry_screen')), findsOneWidget);

      await tester.tap(find.byKey(const Key('membership_entry_continue')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('account_setup_intro_secondary_back')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('membership_entry_screen')), findsOneWidget);

      await tester.tap(find.byKey(const Key('membership_entry_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('visitor_membership_invitation')),
        findsOneWidget,
      );
      expect(find.text(italianCopy.confirmationCount(18)), findsOneWidget);
      expect(find.text(italianCopy.confirmationCount(19)), findsNothing);
      expect(find.text(italianCopy.youConfirmedLocally), findsNothing);
    },
  );

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
      MaterialPageRoute<void>(builder: (_) => TownFeedScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TownFeedScreen), findsOneWidget);
    expect(find.text(italianCopy.seeThisToo), findsOneWidget);

    await tester.tap(find.byKey(const Key('signal_confirm_milano-signal-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visitor_not_now')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('visitor_experience_ended')), findsOneWidget);
    expect(find.byKey(const Key('town_feed_page_view')), findsNothing);
    expect(find.text(italianCopy.seeThisToo), findsNothing);
    expect(find.text(italianCopy.openSignalAction), findsNothing);
    expect(find.text(italianCopy.visitorEndedTitle), findsOneWidget);
    expect(find.text(italianCopy.visitorEndedBody), findsOneWidget);
    expect(
      find.text(italianCopy.visitorLeaveTownAction),
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
    expect(find.text(italianCopy.openSignalSheetTitle), findsOneWidget);
    expect(
      find.byKey(const Key('open_signal_prototype_message')),
      findsOneWidget,
    );
    expect(
      find.text(italianCopy.openSignalPrototypeMessage),
      findsOneWidget,
    );
    expect(find.text(italianCopy.openSignalClose), findsOneWidget);

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
      await tester.pumpWidget(MaterialApp(home: TownFeedScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'overflow at $size');
      expect(find.text(italianCopy.seeThisToo), findsOneWidget, reason: '$size');
      expect(
        find.text(italianCopy.openSignalAction),
        findsOneWidget,
        reason: '$size',
      );
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

  test('Munich catalog is three German civic scenes', () {
    expect(kMunichFeedV1MockSignals, hasLength(3));
    expect(feedSignalsForCity('Milano'), same(kMilanoFeedV1MockSignals));
    expect(feedSignalsForCity('Munich'), same(kMunichFeedV1MockSignals));
    expect(
      () => feedSignalsForCity('Rome'),
      throwsA(isA<ArgumentError>()),
    );
    expect(kMunichFeedV1MockSignals[0].area, 'Schwabing');
    expect(kMunichFeedV1MockSignals[1].area, 'Haidhausen');
    expect(kMunichFeedV1MockSignals[2].area, 'Sendling');
    expect(
      kMunichFeedV1MockSignals[0].headline,
      'Der Gehweg ist hier kaum noch sicher passierbar.',
    );
    expect(
      kMunichFeedV1MockSignals[0].mediaPresentation,
      CivicMediaPresentation.landscape,
    );
    expect(
      kMunichFeedV1MockSignals[1].mediaPresentation,
      CivicMediaPresentation.portrait,
    );
    expect(
      kMunichFeedV1MockSignals[2].mediaPresentation,
      CivicMediaPresentation.square,
    );
  });

  testWidgets('Munich feed renders German scene 1 chrome and copy', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(
      tester,
      selectedCountry: 'Germany',
      selectedCity: 'Munich',
    );

    expect(find.text('Anna Weber · Gestern beobachtet'), findsOneWidget);
    expect(find.text('ÖFFENTLICHER RAUM'), findsOneWidget);
    expect(
      find.text('Der Gehweg ist hier kaum noch sicher passierbar.'),
      findsOneWidget,
    );
    expect(find.text('Lokal bestätigt'), findsOneWidget);
    expect(find.text('Schwabing'), findsOneWidget);
    expect(find.text('Von 16 Menschen in der Nähe bestätigt'), findsOneWidget);
    expect(find.text(germanCopy.seeThisToo), findsOneWidget);
    expect(find.text(germanCopy.openSignalAction), findsOneWidget);
    expect(find.text('Città Studi'), findsNothing);
    expect(find.text('Open signal'), findsNothing);
  });

  testWidgets('Munich Open signal and visitor gate use German copy', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(
      tester,
      selectedCountry: 'Germany',
      selectedCity: 'Munich',
    );

    await tester.tap(find.byKey(const Key('signal_open_munich-signal-1')));
    await tester.pumpAndSettle();
    expect(find.text(germanCopy.openSignalSheetTitle), findsOneWidget);
    expect(find.text(germanCopy.openSignalPrototypeMessage), findsOneWidget);
    expect(find.text(germanCopy.openSignalClose), findsOneWidget);
    await tester.tap(find.byKey(const Key('open_signal_prototype_close')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signal_confirm_munich-signal-1')));
    await tester.pumpAndSettle();
    expect(find.text(germanCopy.visitorInvitationTitle), findsOneWidget);
    expect(find.text(germanCopy.visitorJoinAction), findsOneWidget);
    expect(find.text(germanCopy.visitorNotNowAction), findsOneWidget);

    await tester.tap(find.byKey(const Key('visitor_not_now')));
    await tester.pumpAndSettle();
    expect(find.text(germanCopy.visitorEndedTitle), findsOneWidget);
    expect(find.text(germanCopy.visitorLeaveTownAction), findsOneWidget);
  });

  testWidgets(
    'Munich Weiter opens German Account Setup Introduction',
    (WidgetTester tester) async {
      await _pumpFeed(
        tester,
        selectedCountry: 'Germany',
        selectedCity: 'Munich',
      );

      await tester.tap(find.byKey(const Key('signal_confirm_munich-signal-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('visitor_join_community')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('membership_entry_screen')), findsOneWidget);
      expect(find.text(germanCopy.membershipEntryLabel), findsOneWidget);
      expect(
        find.text(germanCopy.membershipEntryHeadline('Munich')),
        findsOneWidget,
      );
      expect(
        find.text('Werde Mitglied in deiner Münchner Gemeinschaft.'),
        findsOneWidget,
      );
      expect(find.text(germanCopy.membershipEntryPrice), findsOneWidget);
      expect(find.text('€12 pro Jahr'), findsOneWidget);
      expect(find.text(germanCopy.membershipEntryContinue), findsOneWidget);
      expect(
        find.text(germanCopy.membershipEntrySecondaryBack),
        findsOneWidget,
      );
      expect(find.text(italianCopy.membershipEntryPrice), findsNothing);
      expect(find.text('€12 all’anno'), findsNothing);

      await tester.tap(find.byKey(const Key('membership_entry_continue')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('account_setup_intro_screen')),
        findsOneWidget,
      );
      expect(find.byType(AccountSetupIntroductionScreen), findsOneWidget);
      final AccountSetupIntroductionScreen intro = tester.widget(
        find.byType(AccountSetupIntroductionScreen),
      );
      expect(intro.selectedCountry, 'Germany');
      expect(intro.selectedCity, 'Munich');

      expect(find.text(germanCopy.accountSetupIntroLabel), findsOneWidget);
      expect(find.text(germanCopy.accountSetupIntroHeadline), findsOneWidget);
      expect(find.text(germanCopy.accountSetupIntroBody), findsOneWidget);
      expect(find.text(germanCopy.accountSetupIntroWhyTitle), findsOneWidget);
      expect(find.text(germanCopy.accountSetupIntroWhyBody), findsOneWidget);
      expect(
        find.text(germanCopy.accountSetupIntroWhyBodySecond),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountSetupIntroVerificationTitle),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountSetupIntroPrivacyTitle),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountSetupIntroPrivacyBody),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountSetupIntroPrivacyBodySecond),
        findsOneWidget,
      );
      expect(find.text(germanCopy.accountSetupIntroStart), findsOneWidget);
      expect(find.text(italianCopy.accountSetupIntroLabel), findsNothing);
      expect(find.text(italianCopy.accountSetupIntroStart), findsNothing);

      // Starten opens German Account Creation Screen.
      await tester.tap(find.byKey(const Key('account_setup_intro_start')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('account_creation_screen')), findsOneWidget);
      expect(
        find.byKey(const Key('account_creation_email_step')),
        findsOneWidget,
      );
      expect(find.text(germanCopy.accountCreationEmailLabel), findsOneWidget);
      expect(find.text(italianCopy.accountCreationEmailLabel), findsNothing);

      await tester.tap(find.byKey(const Key('account_creation_email_continue')));
      await tester.pumpAndSettle();
      expect(find.text(germanCopy.accountCreationEmailEmpty), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('account_creation_email_field')),
        'ungueltig',
      );
      await tester.tap(find.byKey(const Key('account_creation_email_continue')));
      await tester.pumpAndSettle();
      expect(find.text(germanCopy.accountCreationEmailInvalid), findsOneWidget);

      const String testEmail = 'name@beispiel.de';
      await tester.enterText(
        find.byKey(const Key('account_creation_email_field')),
        testEmail,
      );
      await tester.tap(find.byKey(const Key('account_creation_email_continue')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_code_step')),
        findsOneWidget,
      );
      expect(find.text(testEmail), findsOneWidget);
      expect(find.text(germanCopy.accountCreationCodeLabel), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('account_creation_code_field')),
        '111111',
      );
      await tester.tap(find.byKey(const Key('account_creation_code_verify')));
      await tester.pumpAndSettle();
      expect(find.text(germanCopy.accountCreationCodeInvalid), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('account_creation_code_field')),
        '123456',
      );
      await tester.tap(find.byKey(const Key('account_creation_code_verify')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_passkey_step')),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountCreationPasskeyLabel),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('account_creation_passkey_create')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_passkey_prototype_dialog')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('account_creation_passkey_simulate')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_ready_step')),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountCreationReadyEmailStatus),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountCreationReadyPasskeyStatus),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountCreationReadyNextStep),
        findsOneWidget,
      );
      expect(find.text('Account created'), findsNothing);
      expect(find.text('Membership active'), findsNothing);
      expect(find.text('Payment complete'), findsNothing);

      await tester.tap(
        find.byKey(const Key('account_creation_continue_membership')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_payment_boundary_dialog')),
        findsOneWidget,
      );
      expect(
        find.text(germanCopy.accountCreationPaymentBoundaryMessage),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('account_creation_payment_boundary_dismiss')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_ready_step')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_passkey_step')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_code_step')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('account_creation_code_change_email')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_creation_email_step')),
        findsOneWidget,
      );
      expect(find.text(testEmail), findsOneWidget);

      await tester.tap(find.byKey(const Key('account_creation_back')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('account_setup_intro_screen')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const Key('account_setup_intro_secondary_back')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('membership_entry_screen')), findsOneWidget);

      await tester.tap(find.text(germanCopy.membershipEntrySecondaryBack));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('visitor_membership_invitation')),
        findsOneWidget,
      );
      expect(find.text(germanCopy.confirmationCount(16)), findsOneWidget);
      expect(find.text(germanCopy.youConfirmedLocally), findsNothing);
    },
  );
  testWidgets('default TownFeedScreen stays Milano Italian chrome', (
    WidgetTester tester,
  ) async {
    await _pumpFeed(tester);
    final TownFeedScreen feed = tester.widget(find.byType(TownFeedScreen));
    expect(feed.selectedCity, 'Milano');
    expect(feed.selectedCountry, 'Italy');
    expect(find.text('Città Studi'), findsOneWidget);
    expect(find.text(italianCopy.openSignalAction), findsOneWidget);
    expect(find.text(italianCopy.seeThisToo), findsOneWidget);
    expect(find.text('Open signal'), findsNothing);
    expect(find.text('I SEE THIS TOO'), findsNothing);
    expect(find.text('Schwabing'), findsNothing);
  });
}
