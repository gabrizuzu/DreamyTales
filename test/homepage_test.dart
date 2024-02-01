import 'package:dreamy_tales/auth.dart';
import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

class MockAuth extends Mock implements Auth {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('MyHomePage Widget Test', (WidgetTester tester) async {
    // Fornisci il mock di Auth al widget
    await tester.pumpWidget(
      const MaterialApp(
        home: MyHomePage(),
      ),
    );

    // Verifica che il widget sia stato creato correttamente
    expect(find.byType(MyHomePage), findsOneWidget);

    // Verifica che il titolo della categoria corrente sia visualizzato correttamente
    expect(find.text('Dreamy Tales'), findsOneWidget);
  });

  testWidgets('Find "Second Characters" Text Widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: MyHomePage(),
        ),
      ),
    );

    expect(find.byKey(const Key("secondCharacters")), findsOneWidget);
  });

  testWidgets('Find "Main Characters" Text Widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: MyHomePage(),
        ),
      ),
    );

    expect(find.byKey(const Key("mainCharacters")), findsOneWidget);
  });

  testWidgets('Find "Start Magic" TextButton Widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: MyHomePage(),
        ),
      ),
    );

    expect(find.byKey(const Key("startMagic")), findsOneWidget);
  });


}
