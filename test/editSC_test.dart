import 'package:dreamy_tales/pages/edit_second_character.dart';
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

  testWidgets('EditSecondCharacterPage Widget Test', (WidgetTester tester) async {
    // Mock data for the character
    Map<String, dynamic> characterData = {
      'name': 'Jane Doe',
      'gender': 'Female',
      'role': 'Friend',
      'avatar': 'assets/avatar_F2.png',
    };


    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: EditSecondCharacterPage(characterId: characterData['name']),
      ),
    );

    // Wait for the widget to settle.
    await tester.pumpAndSettle();

    // Verify that the elements are found using their keys
    expect(find.byKey(const Key('editSecondCharacterAppBar')), findsOneWidget);
    expect(find.byKey(const Key('editSecondCharacterBody')), findsOneWidget);
    expect(find.byKey(const Key('editSecondCharacterNameField')), findsOneWidget);
    expect(find.byKey(const Key('editSecondCharacterGenderField')), findsOneWidget);
    expect(find.byKey(const Key('editSecondCharacterRoleField')), findsOneWidget);
    expect(find.byKey(const Key('editSecondCharacterAvatarField')), findsOneWidget);


    final List<String> allAvatars = [
      'assets/avatar_M1.png',
      'assets/avatar_M3.png',
      'assets/avatar_M4.png',
      'assets/avatar_M5.png',
      'assets/avatar_M6.png',
      'assets/avatar_M8.png',
      'assets/avatar_M7.png',
      'assets/avatar_F1.png',
      'assets/avatar_F2.png',
      'assets/avatar_F3.png',
      'assets/avatar_F4.png',
      'assets/avatar_F5.png',
      'assets/avatar_F6.png',
      'assets/avatar_F7.png',
    ];
    // Verify that the avatar previews are found using their keys
    for (String avatarPath in allAvatars) {
      expect(find.byKey(Key(avatarPath)), findsOneWidget);
    }

  });
}
