import 'package:flutter_test/flutter_test.dart';
import 'package:clock_app/main.dart';

void main() {
  testWidgets('ClockApp renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ClockApp());
    expect(find.text('Active Time'), findsOneWidget);
  });
}
