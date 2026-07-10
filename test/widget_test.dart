import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space_mobile/main.dart';

void main() {
  testWidgets('WelcomeScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.textContaining('Real communities.'), findsOneWidget);
    expect(find.textContaining('Real stories.'), findsOneWidget);
    expect(find.textContaining('No noise.'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Learn more'), findsOneWidget);
  });
}
