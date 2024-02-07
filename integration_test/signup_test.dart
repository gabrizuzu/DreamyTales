import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:dreamy_tales/pages/profiling_page.dart'; // Import the ChildProfilePage class

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Register Page Test', () {
    testWidgets('Should register a user', (WidgetTester tester) async {
      // Avvia l'app
      await tester.pumpWidget(MaterialApp(home:LoginPage()));

      // Trova i widget
      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final registerButton = find.text('Register instead');

      // Simula l'input dell'utente
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      await tester.tap(registerButton);

      final register = find.text('Register');

      // Simula il tap sul pulsante di registrazione
  
      await tester.tap(register);
      await tester.pumpAndSettle();

      expect(find.byType(ChildProfilePage), findsOneWidget);
            
    });
  });
}