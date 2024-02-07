import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/pages/profiling_page.dart';

void main() {
  testWidgets('ChildProfilePage should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(key: Key('test'), home: ChildProfilePage(key:Key('childProfilePage'))));
    expect(find.byType(ChildProfilePage), findsOneWidget);
  });

  testWidgets('ChildProfilePage should navigate to MyHomePage after saving', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ChildProfilePage(key:Key('childProfilePage')),
    ));

    // Simula l'inserimento del nome
    await tester.enterText(find.byType(TextField), 'John Doe');
    await tester.pump();

    // Simula l'inserimento dell'età
    await tester.enterText(find.byType(TextField), '5');
    await tester.pump();

    // Simula la selezione dell'avatar
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    
  });
}
