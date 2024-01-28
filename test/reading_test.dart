import 'package:dreamy_tales/pages/reading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ReadingPage Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ReadingPage(
          storyText: 'Test story text',
          language: 'Italiano',
        ),
      ),
    );

    // Verifica che la pagina sia stata costruita correttamente
    expect(find.text('Reading Page'), findsOneWidget);
    expect(find.byType(Markdown), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);

    // Accedi a _ReadingPageState usando tester.state
    final state = tester.state<ReadingPageState>(find.byType(ReadingPage));

    // Verifica che il Text-to-Speech (TTS) sia inizializzato correttamente
    expect(state._flutterTts, isNotNull);

    // Verifica che il TTS sia inizializzato con la lingua corretta
    expect(
      state._flutterTts.getLanguage,
      state.widget.language == 'Italiano' ? 'it-IT' : 'en-US',
    );

    // Verifica che il Toggle TTS funzioni correttamente
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();
    expect(state._isPlaying, isTrue);

    await tester.tap(find.byIcon(Icons.pause));
    await tester.pump();
    expect(state._isPlaying, isFalse);

    // Verifica che il Reset TTS funzioni correttamente
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(state._isPlaying, isFalse);

    // Verifica che la pagina si chiuda correttamente
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(state._isPlaying, isFalse);
  });
}
