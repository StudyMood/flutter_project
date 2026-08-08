import 'package:flutter_test/flutter_test.dart';
import 'package:ai_se_tips/main.dart';

void main() {
  testWidgets('App renders correctly test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AiHealthTipsApp());

    // Verify app title appears
    expect(find.text('24 AI Health & Care'), findsOneWidget);
  });
}
