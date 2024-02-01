import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/pages/add_second_character_page.dart';
import 'mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('AddSecondCharacterPage UI Test - Dropdown Gender', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSecondCharacterPage()));

    expect(find.byKey(const Key("dropdownGender")), findsOneWidget);

    await tester.tap(find.byKey(const Key("dropdownGender")));
    await tester.pump();

    // Let's assume the menu items are visible and select the first one
    await tester.tap(find.text('Male'));
    await tester.pump();

    // You may need to adjust the expectation based on your specific implementation
    expect(find.text('Male'), findsOneWidget);
  });

  testWidgets('AddSecondCharacterPage UI Test - Dropdown Role', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSecondCharacterPage()));

    expect(find.byKey(const Key("dropdownRole")), findsOneWidget);

    await tester.tap(find.byKey(const Key("dropdownRole")));
    await tester.pump();

    // Let's assume the menu items are visible and select the first one
    await tester.tap(find.text('Grandparent'));
    await tester.pump();

    // You may need to adjust the expectation based on your specific implementation
    expect(find.text('Grandparent'), findsOneWidget);
  });

  testWidgets('AddSecondCharacterPage UI Test - Icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSecondCharacterPage()));

    expect(find.byType(Icon), findsNWidgets(4));
  });

  testWidgets('AddSecondCharacterPage UI Test - Save Character', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSecondCharacterPage()));

    //..
  });
}
