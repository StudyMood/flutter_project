import 'package:flutter_test/flutter_test.dart';
import 'package:advance_contact_list/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ContactsApp());
    expect(find.byType(ContactsApp), findsOneWidget);
  });
}
