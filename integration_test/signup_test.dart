import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dreamy_tales/auth.dart';
import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:firebase_core/firebase_core.dart';

class MockAuth extends Mock implements Auth {}

void main() {
  MockAuth mockAuth;
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Register test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Verify that we have the register button
    expect(find.text('Register instead'), findsOneWidget);

    // Tap the 'Register instead' button and trigger a frame
    await tester.tap(find.text('Register instead'));
    await tester.pumpAndSettle();

    // Verify that we have the register button
    expect(find.text('Register'), findsOneWidget);

    // Enter text in the email and password fields
    await tester.enterText(find.byKey(Key('emailField')), 'test@test.com');
    await tester.enterText(find.byKey(Key('passwordField')), 'password');
    // Initialize the mockAuth variable before using it
    mockAuth = MockAuth();
    when(mockAuth.createUserWithEmailAndPassword(email: 'test@test.com', password:'password'))
        .thenAnswer((_) async => {});

    // Tap the 'Register' button and trigger a frame
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();


  });
}