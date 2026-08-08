import 'package:flutter_test/flutter_test.dart';

import 'package:fit_bmi/main.dart';

void main() {
  testWidgets('BMI Calculator UI verification test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our main title is present.
    expect(find.text('FIT BMI'), findsOneWidget);
    expect(find.text('CALCULATE BMI'), findsOneWidget);

    // Verify that input labels exist.
    expect(find.text('WT (kg)'), findsOneWidget);
    expect(find.text('FT (feet)'), findsOneWidget);
    expect(find.text('HT (inch)'), findsOneWidget);
  });
}
