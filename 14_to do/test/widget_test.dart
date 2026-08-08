// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:diploma_it_todo/main.dart';

void main() {
  testWidgets('TodoApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TodoApp());

    // Verify that our app header is present.
    expect(find.text('📚 Diploma IT Student To-Do List'), findsOneWidget);
    expect(find.text('Complete DBMS Assignment'), findsOneWidget);
  });
}

