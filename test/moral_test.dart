import 'package:dreamy_tales/widgets/moral_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  /* MORAL STORY DA SSISTEMARE



  testWidgets('MoralChoice Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MoralChoice(),
      ),
    );

    // Verifying the presence of components without checking dynamic content

    // Verifying the presence of the AppBar
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Moral Choice'), findsOneWidget);

    // Verifying the presence of the Container and GridView
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    // Verifying the presence of a Card in the GridView
    expect(find.byType(Card), findsOneWidget);

    // Verifying the presence of a FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

   */
}
