import 'package:dreamy_tales/pages/analitics_page.dart';
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

  testWidgets('Analytics Widget Test', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: Analytics(),
      ),
    );

    // Verifying the presence of components without checking dynamic content

    // Verifying the presence of the 'Generated Stories' card
    //expect(find.byKey(const Key("generatedStories")), findsOneWidget);

    // Verifying the presence of the 'Top 5 stories' text
    expect(find.byKey(const Key('topStories')), findsOneWidget);

    // Verifying the presence of the loading indicator (CircularProgressIndicator)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
