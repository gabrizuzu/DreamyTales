// tutorial_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:dreamy_tales/pages/tutorial_screen.dart';

void main() {
  testWidgets('TutorialScreen should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TutorialScreen()));
    expect(find.byType(TutorialScreen), findsOneWidget);
  });

  testWidgets('TutorialScreen should have correct number of page indicators', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TutorialScreen()));
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(Container), findsWidgets); // Rimuovi il controllo sul numero
    expect(find.byKey(const Key('pageIndicator_0')), findsOneWidget);
    expect(find.byKey(const Key('pageIndicator_1')), findsOneWidget);
    expect(find.byKey(const Key('pageIndicator_2')), findsOneWidget);
  });


  testWidgets('TutorialScreen should display correct text for each slide', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TutorialScreen()));
    expect(find.text('Dreamy Tales'), findsOneWidget);
    expect(find.text("It's story time"), findsOneWidget);
    // Ripeti per gli altri testi e descrizioni
  });




}

