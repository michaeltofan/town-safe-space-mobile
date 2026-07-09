import 'package:flutter_test/flutter_test.dart';

import 'package:town_safe_space/app.dart';

void main() {
  testWidgets('Welcome screen shows TOWN brand', (WidgetTester tester) async {
    await tester.pumpWidget(const TownApp());

    expect(find.text('TOWN'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.textContaining('Real communities.'), findsOneWidget);
  });
}
