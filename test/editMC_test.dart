//EDIT MAIN CHARACTER TEST

import 'package:dreamy_tales/pages/edit_character.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('EditCharacterPage Widget Test', (WidgetTester tester) async {
    // Mock data for the character
    Map<String, dynamic> characterData = {
      'name': 'John Doe',
      'gender': 'Male',
      'age': 25,
      'avatar': 'assets/avatar_M1.png',
    };

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: EditCharacterPage(characterId: characterData['name']),
      ),
    );

    // Wait for the widget to settle.
    await tester.pumpAndSettle();


    // Verify that the elements are found using their keys
    expect(find.byKey(const Key('nameField')), findsOneWidget);
    expect(find.byKey(const Key('genderField')), findsOneWidget);
    expect(find.byKey(const Key('ageField')), findsOneWidget);
    expect(find.byKey(const Key('ageSlider')), findsOneWidget);
    expect(find.byKey(const Key('swipeIcon')), findsOneWidget);

  });
}

