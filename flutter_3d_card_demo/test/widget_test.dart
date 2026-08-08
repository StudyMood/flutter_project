import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_3d_card_demo/main.dart';

void main() {
  testWidgets('Smoke test for Flutter3DCardApp rendering', (WidgetTester tester) async {
    await tester.pumpWidget(const Flutter3DCardApp());
    expect(find.text('3D INTERACTIVE UI'), findsOneWidget);
  });
}
