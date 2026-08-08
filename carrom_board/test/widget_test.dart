import 'package:flutter_test/flutter_test.dart';
import 'package:carrom_board/main.dart';

void main() {
  testWidgets('Carrom board loads test', (WidgetTester tester) async {
    await tester.pumpWidget(const CarromBoardApp());
    expect(find.text('Carrom Board Pro'), findsOneWidget);
  });
}
