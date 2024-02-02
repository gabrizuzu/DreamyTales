import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/pages/add_main_character_page.dart';
import 'mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('AddMainCharacterPage UI Test - Name Field', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddMainCharacterPage()));

    expect(find.byKey(const Key("name")), findsOneWidget);

    // Enter some text in the name field
    await tester.enterText(find.byKey(const Key("name")), 'TestName');

    // You may need to adjust the expectation based on your specific implementation
    expect(find.text('TestName'), findsOneWidget);
  });

  testWidgets('AddMainCharacterPage UI Test - Dropdown Gender', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddMainCharacterPage()));

    expect(find.byKey(const Key("dropDownGender")), findsOneWidget);

    await tester.tap(find.byKey(const Key("dropDownGender")));
    await tester.pump();

    // Let's assume the menu items are visible and select the first one
    await tester.tap(find.text('Male'));
    await tester.pump();

    // You may need to adjust the expectation based on your specific implementation
    expect(find.text('Male'), findsOneWidget);
  });

  testWidgets('AddMainCharacterPage UI Test - Age Slider', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddMainCharacterPage()));

    expect(find.byKey(const Key("age")), findsOneWidget);
    expect(find.byKey(const Key("slider")), findsOneWidget);

  });

  testWidgets('AddMainCharacterPage UI Test - Avatar Selection', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddMainCharacterPage()));

    // Assuming there are 15 avatars, adjust the number based on your implementation
    expect(find.byType(AvatarPreview), findsNWidgets(14));

  });

}
