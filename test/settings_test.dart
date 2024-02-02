import 'package:dreamy_tales/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsScreen UI Tests', () {
    testWidgets('Contains Language Title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('Contains Notifications Option', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      expect(find.text('Notifications'), findsOneWidget);
    });


    testWidgets('Open Notifications Dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      expect(find.text('Do you want to receive notifications?'), findsOneWidget);
    });

    testWidgets('Disable Notifications in Dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(find.byType(Switch)).value, false);
    });

    testWidgets('Close Notifications Dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));


      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ok'));
      await tester.pumpAndSettle();

      expect(find.text('Do you want to receive notifications?'), findsNothing);
    });

    testWidgets('Change Language in Dialog', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('In which Language do you want to generate the Stories?'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });



  });
}
