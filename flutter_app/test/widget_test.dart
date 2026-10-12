import 'package:flutter_test/flutter_test.dart';
import 'package:smuct_lost_and_found/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmuctLostAndFoundApp());
    expect(find.byType(SmuctLostAndFoundApp), findsOneWidget);
  });
}
