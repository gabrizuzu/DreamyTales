// tutorial_test.dart

import 'package:dreamy_tales/widgets/app_large_text.dart';
import 'package:dreamy_tales/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:dreamy_tales/pages/tutorial_screen.dart';

void main() {
  testWidgets('TutorialScreen should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TutorialScreen()));
    expect(find.byType(TutorialScreen), findsOneWidget);
  });

  testWidgets('TutorialScreen should have correct number of page indicators', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TutorialScreen()));
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.byKey(const Key('pageIndicator_0')), findsOneWidget);
    expect(find.byKey(const Key('pageIndicator_1')), findsOneWidget);
    expect(find.byKey(const Key('pageIndicator_2')), findsOneWidget);
  });

  testWidgets('TutorialScreen should display correct text for each slide', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TutorialScreen()));
    expect(find.text('Dreamy Tales'), findsOneWidget);
    expect(find.text("It's story time"), findsOneWidget);
    // Ripeti per gli altri testi e descrizioni
  });


  testWidgets('Tutorial Screen State Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: TutorialScreen(),
    ));

    // Verify that there are 3 TutorialSlides (content of the slides)
    expect(find.byType(AppLargeText), findsOneWidget);
    expect(find.byType(AppText), findsOneWidget);

    // Swipe right
    await tester.drag(find.byType(PageView), const Offset(-600.0, 0.0));
    await tester.pumpAndSettle();

    // Verify that if swipe right, the index of the pages increments (unless on the last slide)
    expect(find.byKey(const Key('pageIndicator_1')), findsOneWidget); // Adjust this based on your actual slide content

    // Swipe left
    await tester.drag(find.byType(PageView), const Offset(600.0, 0.0));
    await tester.pumpAndSettle();

    // Verify that if swipe left, the index of the pages decrements (unless on the first slide)
    expect(find.byKey(const Key('pageIndicator_0')), findsOneWidget); // Adjust this based on your actual slide content
  });

  testWidgets('Elevated Button should navigate to LoginPage on last slide', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: TutorialScreen(),
    ));

    // Swipe to the last slide
    await tester.drag(find.byType(PageView), const Offset(-600.0, 0.0));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-600.0, 0.0));
    await tester.pumpAndSettle();

    // Verify that the Elevated Button is present
    expect(find.byKey(const Key('beginButton')), findsOneWidget);

    // Tap the Elevated Button
    await tester.tap(find.byKey(const Key('beginButton')));
    await tester.pumpAndSettle();

    // Verify that the navigation to LoginPage occurred
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('IconButton should navigate to next and previous slide', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: TutorialScreen(),
    ));

    // Swipe to the second slide
    await tester.drag(find.byType(PageView), const Offset(-600.0, 0.0));
    await tester.pumpAndSettle();

    // Verify that we are on the second slide
    expect(find.byKey(const Key('pageIndicator_1')), findsOneWidget);

    // Tap the forward IconButton
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();

    // Verify that we are on the third slide
    expect(find.byKey(const Key('pageIndicator_2')), findsOneWidget);

    // Tap the backward IconButton
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify that we are back on the second slide
    expect(find.byKey(const Key('pageIndicator_1')), findsOneWidget);
  });

}

