import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("test story generation", (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(MaterialApp(home:MyHomePage()));

    // Click on "Let's begin"
    await tester.tap(find.text("Let's begin"));
    await tester.pumpAndSettle();

    // Choose genre
    await tester.tap(find.text("Genre")); 
    await tester.pumpAndSettle();

    // Choose plot
    await tester.tap(find.text("Plot")); 
    await tester.pumpAndSettle();

    // Choose morale
    await tester.tap(find.text("Moral")); 
    await tester.pumpAndSettle();

    // Wait for the API response. 
    await Future.delayed(Duration(seconds: 45));

    // Check that the story is displayed
    expect(find.text("Title"), findsOneWidget); 
  });
}