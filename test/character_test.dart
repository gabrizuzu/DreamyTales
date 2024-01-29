import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dreamy_tales/pages/add_second_character_page.dart';

void main() {
  testWidgets('AddSecondCharacterPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: AddSecondCharacterPage()));


    // Verifica che i campi di input siano presenti
    //expect(find.byType(Widget), findsNWidgets(4));
    expect(find.byType(DropdownButtonFormField), findsNWidgets(2));

    // Verifica la presenza del pulsante di salvataggio
    expect(find.byType(Icon), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);

    // Inserisci testo nei campi di input
    await tester.enterText(find.byType(TextFormField).first, 'TestName');
    await tester.enterText(find.byType(DropdownButtonFormField).first, 'Male');
    await tester.enterText(find.byType(DropdownButtonFormField).last, 'Parent');

    // Tocca il pulsante di salvataggio
    await tester.tap(find.byType(TextButton));

    // Attendi il completamento della chiamata asincrona (simulando un salvataggio)
    await tester.pump();

    // Verifica che la pagina di inserimento del personaggio venga chiusa dopo il salvataggio
    expect(find.byType(AddSecondCharacterPage), findsNothing);
  });
}
