import 'package:flutter_test/flutter_test.dart';
import 'package:age_calculator/main.dart';

void main() {
  testWidgets('Age Calculator Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgeCalculatorApp());
    expect(find.text('Age Calculator'), findsWidgets);
  });
}
