import 'package:flutter_test/flutter_test.dart';
import 'package:upper_deck_restro/main.dart';

void main() {
  testWidgets('Upper Deck Restro App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UpperDeckRestroApp());
    expect(find.text('Upper Deck Restro'), findsWidgets);
  });
}
