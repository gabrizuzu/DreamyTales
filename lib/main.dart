import 'package:dreamy_tales/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _configureFirebaseMessaging();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const WidgetTree(),
    );
  }

  Future<void> _configureFirebaseMessaging() async {
    _firebaseMessaging.getToken().then((token) {
      print("Firebase Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
      // Qui puoi gestire la notifica ricevuta mentre l'app è in primo piano
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      // Qui puoi gestire la notifica quando l'app è in background o terminata
    });

    // Richiedi i permessi per le notifiche
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');
  }


}