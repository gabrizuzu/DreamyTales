import 'package:dreamy_tales/pages/reading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  testWidgets('ReadingPage Initial State Test', (WidgetTester tester) async {

    // Inject the fake Firestore instance into the ReadingPage
    await tester.pumpWidget(
      MaterialApp(
        home: ReadingPage(
          storyText: 'Your story text here',
          language: 'Italiano',
        ),
      ),
    );

    // Access the state of ReadingPage
    final readingPageState = tester.state<ReadingPageState>(
      find.byType(ReadingPage),
    );

    // Verify the initial state
    expect(readingPageState.isPlaying, false);
  });


  testWidgets('ReadingPage Reset TTS Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReadingPage(
          storyText: 'Your story text here',
          language: 'Italiano',
        ),
      ),
    );

    // Access the state of ReadingPage
    final readingPageState = tester.state<ReadingPageState>(
      find.byType(ReadingPage),
    );

    // Perform test: Reset TTS
    await tester.tap(find.byType(FloatingActionButton).last);
    await tester.pump(); // Rebuild the widget

    expect(readingPageState.isPlaying, false);
  });
}
