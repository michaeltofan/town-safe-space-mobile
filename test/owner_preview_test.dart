import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/main.dart';
import 'package:town_safe_space_mobile/models/community_signal_mock.dart';
import 'package:town_safe_space_mobile/owner_preview.dart';
import 'package:town_safe_space_mobile/screens/select_country_screen.dart';
import 'package:town_safe_space_mobile/screens/town_feed_screen.dart';
import 'package:town_safe_space_mobile/screens/welcome_screen.dart';

void main() {
  group('shouldOpenOwnerFeedPreview', () {
    test('no query parameter does not open preview', () {
      expect(
        shouldOpenOwnerFeedPreview(
          uri: Uri.parse('https://example.com/town-safe-space-mobile/'),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('ownerPreview=feed on web opens preview', () {
      expect(
        shouldOpenOwnerFeedPreview(
          uri: Uri.parse(
            'https://example.com/town-safe-space-mobile/?ownerPreview=feed',
          ),
          isWeb: true,
        ),
        isTrue,
      );
    });

    test('unknown ownerPreview value does nothing', () {
      expect(
        shouldOpenOwnerFeedPreview(
          uri: Uri.parse(
            'https://example.com/town-safe-space-mobile/?ownerPreview=admin',
          ),
          isWeb: true,
        ),
        isFalse,
      );
      expect(
        shouldOpenOwnerFeedPreview(
          uri: Uri.parse(
            'https://example.com/town-safe-space-mobile/?ownerPreview=Feed',
          ),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('ownerPreview=feed is ignored when not web', () {
      expect(
        shouldOpenOwnerFeedPreview(
          uri: Uri.parse(
            'https://example.com/town-safe-space-mobile/?ownerPreview=feed',
          ),
          isWeb: false,
        ),
        isFalse,
      );
    });
  });

  group('isOwnerJourneyMode', () {
    test('activates only for /owner-journey-v1/ path segment on web', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/owner-journey-v1/',
          ),
          isWeb: true,
        ),
        isTrue,
      );
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/owner-journey-v1',
          ),
          isWeb: true,
        ),
        isTrue,
      );
    });

    test('does not activate on production root /', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/',
          ),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('does not activate on /experience-v1/', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/experience-v1/',
          ),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('does not activate on /pr30-preview/', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/pr30-preview/',
          ),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('does not activate on /pr33-preview/', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/pr33-preview/',
          ),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('does not activate from country/city query alone', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/?country=Italy&city=Milano',
          ),
          isWeb: true,
        ),
        isFalse,
      );
    });

    test('does not activate when not web', () {
      expect(
        isOwnerJourneyMode(
          uri: Uri.parse(
            'https://michaeltofan.github.io/town-safe-space-mobile/owner-journey-v1/',
          ),
          isWeb: false,
        ),
        isFalse,
      );
    });
  });

  group('initialHomeForApp', () {
    testWidgets('no query parameter starts at Welcome', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: initialHomeForApp(
            uri: Uri.parse('https://example.com/town-safe-space-mobile/'),
            isWeb: true,
          ),
        ),
      );
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(TownFeedScreen), findsNothing);
    });

    testWidgets('ownerPreview=feed starts at Feed V1 with 3 cards', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: initialHomeForApp(
            uri: Uri.parse(
              'https://example.com/town-safe-space-mobile/?ownerPreview=feed',
            ),
            isWeb: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TownFeedScreen), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);
      expect(find.text('1 / 3'), findsOneWidget);
      expect(kMilanoFeedV1MockSignals, hasLength(3));
    });

    testWidgets('unknown ownerPreview starts at Welcome', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: initialHomeForApp(
            uri: Uri.parse(
              'https://example.com/town-safe-space-mobile/?ownerPreview=oops',
            ),
            isWeb: true,
          ),
        ),
      );
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(TownFeedScreen), findsNothing);
    });

    testWidgets('non-web ignores ownerPreview=feed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: initialHomeForApp(
            uri: Uri.parse(
              'https://example.com/town-safe-space-mobile/?ownerPreview=feed',
            ),
            isWeb: false,
          ),
        ),
      );
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(TownFeedScreen), findsNothing);
    });
  });

  group('MyApp wiring', () {
    testWidgets('default MyApp starts at Welcome', (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(TownFeedScreen), findsNothing);
    });

    testWidgets('MyApp with ownerPreview=feed on web opens Feed V1', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MyApp(
          uri: Uri.parse(
            'https://example.com/town-safe-space-mobile/?ownerPreview=feed',
          ),
          isWeb: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TownFeedScreen), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);
    });

    testWidgets('normal Welcome → Country flow remains unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(const MyApp(isWeb: true));
      expect(find.byType(WelcomeScreen), findsOneWidget);
      await tester.tap(find.text('Welcome'));
      await tester.pumpAndSettle();
      expect(find.byType(SelectCountryScreen), findsOneWidget);
      expect(find.text('Where is your TOWN?'), findsOneWidget);
    });
  });

  test('owner preview module adds no persistence, auth, or payment code', () {
    final String source = File('lib/owner_preview.dart').readAsStringSync();
    expect(source.contains('PUBLIC WEB VISUAL PREVIEW ONLY'), isTrue);
    expect(source.contains('NOT AUTHENTICATION'), isTrue);
    expect(source.contains('NOT OWNER AUTHORIZATION'), isTrue);
    expect(source.contains('NOT FOR PRODUCTION ACCESS CONTROL'), isTrue);
    expect(source.contains('isOwnerJourneyMode'), isTrue);
    expect(source.contains('kOwnerJourneyPathSegment'), isTrue);
    expect(source.contains("import 'dart:html'"), isFalse);
    expect(source.contains('shared_preferences'), isFalse);
    expect(source.contains('localStorage'), isFalse);
    expect(source.contains('document.cookie'), isFalse);
    expect(source.contains('Firebase'), isFalse);
    expect(source.contains('Supabase'), isFalse);
    expect(source.contains('RevenueCat'), isFalse);
    expect(source.contains('SharedPreferences'), isFalse);
    expect(source.contains('HttpClient'), isFalse);
    expect(source.contains('package:http'), isFalse);

    final String mainSource = File('lib/main.dart').readAsStringSync();
    expect(mainSource.contains('initialHomeForApp'), isTrue);
    expect(mainSource.contains('Uri.base'), isTrue);
    expect(mainSource.contains('kIsWeb'), isTrue);
  });
}
