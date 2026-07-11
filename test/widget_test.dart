import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/main.dart';
import 'package:town_safe_space_mobile/screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.textContaining('Real communities.'), findsOneWidget);
    expect(find.textContaining('Real stories.'), findsOneWidget);
    expect(find.textContaining('No noise.'), findsOneWidget);
    expect(
      find.text(
        'TOWN accepts accounts only with registration, confirmed location, and an active membership.',
      ),
      findsOneWidget,
    );
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Learn more'), findsOneWidget);
  });

  testWidgets('Learn more opens approved bottom sheet and Close dismisses it', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byKey(const Key('learn_more_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('learn_more_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('learn_more_title')), findsOneWidget);
    expect(find.text(WelcomeScreen.learnMoreTitle), findsOneWidget);
    expect(find.byKey(const Key('learn_more_body')), findsOneWidget);
    expect(find.text(WelcomeScreen.learnMoreBody), findsOneWidget);
    expect(find.byKey(const Key('learn_more_close')), findsOneWidget);
    expect(find.text(WelcomeScreen.learnMoreCloseLabel), findsOneWidget);
    expect(find.byType(WelcomeScreen), findsOneWidget);

    await tester.tap(find.byKey(const Key('learn_more_close')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('learn_more_title')), findsNothing);
    expect(find.byKey(const Key('learn_more_body')), findsNothing);
    expect(find.byKey(const Key('learn_more_close')), findsNothing);
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Learn more'), findsOneWidget);
  });
}
