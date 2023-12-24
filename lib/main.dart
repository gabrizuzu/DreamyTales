/**
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

**/

import 'package:flutter/material.dart';
import 'package:dreamy_tales/pages/testImages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestImages(),
    );
  }
}

class TestImages extends StatefulWidget {
  @override
  _TestImagesState createState() => _TestImagesState();
}

class _TestImagesState extends State<TestImages> {
  TextEditingController _textInputController = TextEditingController();
  String imageUrl = ''; // Inizializzato a una stringa vuota

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textInputController,
              decoration: InputDecoration(labelText: 'Enter Text'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String text = _textInputController.text;
                if (text.isNotEmpty) {
                  print("\nTEXT WRITTEN: $text\n");
                  var result = await Api.generateImages(text);

                  // Verifica che l'URL sia presente prima di assegnarlo a imageUrl
                  if (result != null) {
                    setState(() {
                      imageUrl = result;
                    });
                  } else {
                    print('URL dell\'immagine non presente nella risposta API.');
                  }
                } else {
                  print('Inserisci del testo prima di effettuare la chiamata API.');
                }
              },
              child: Text('Test API'),
            ),
            SizedBox(height: 16.0),
            // Widget Image per visualizzare l'immagine
            imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              height: 200.0, // Regola l'altezza a tuo piacimento
              fit: BoxFit.contain,
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
