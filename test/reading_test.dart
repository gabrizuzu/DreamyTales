import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('My App', () {
    final readingPageFinder = find.byValueKey('ReadingPage');

    FlutterDriver driver;

    // Connetti il driver prima di eseguire i test
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Chiudi il driver dopo l'esecuzione dei test
    tearDownAll(() async {
      FlutterDriver driver;

      if (driver != null) {
        driver.close();
      }
    });

    test('check reading page', () async {
      // Verifica che la ReadingPage sia presente
      expect(await driver.getText(readingPageFinder), 'ReadingPage');
    });
  });
}