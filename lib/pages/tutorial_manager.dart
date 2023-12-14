import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialManager {
  static Future<void> showTutorialIfNeeded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialSeen = prefs.getBool('tutorial_seen') ?? false;

    if (!tutorialSeen) {
      // Se il tutorial non è stato ancora visto, mostra il tutorial.
      await _showTutorial(context);
      prefs.setBool('tutorial_seen', true);
    }
  }

  static Future<void> _showTutorial(BuildContext context) async {
    // Puoi personalizzare la logica del tutorial qui. Ad esempio, utilizzare un Dialog o Navigator.
    // In questo esempio, stiamo usando un semplice showDialog.
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Benvenuto al Tutorial!'),
          content: Text('Questo è il tutorial della tua app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Chiudi'),
            ),
          ],
        );
      },
    );
  }
}
