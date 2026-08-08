import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_id/main.dart';

void main() {
  testWidgets('App renders correctly test', (WidgetTester tester) async {
    await tester.pumpWidget(const DigiCodersApp());
    expect(find.text('DigiCoders'), findsWidgets);
  });
}
