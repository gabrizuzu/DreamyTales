import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:dreamy_tales/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/tutorial_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Controlla se il tutorial è già stato visualizzato
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isTutorialSeen = prefs.getBool('isTutorialSeen') ?? false;

  runApp(MyApp(isTutorialSeen: isTutorialSeen));
}

class MyApp extends StatelessWidget {
  final bool isTutorialSeen;

  const MyApp({Key? key, required this.isTutorialSeen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Se il tutorial è già stato visto, vai direttamente alla LoginPage
    if (isTutorialSeen) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: WidgetTree(),
      );
    } else {
      // Se il tutorial non è stato ancora visto, avvia il tutorial
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: TutorialScreen(),
      );
    }
  }
}
