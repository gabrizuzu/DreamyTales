import 'package:flutter/material.dart';

import 'login_register_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool receiveNotifications = true; // Add this variable
  String selectedLanguage = 'English'; // Impostazione predefinita
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Opzione 1: Lingua
            InkWell(
              onTap: () {
                _showLanguageSelectionDialog(context);
              },
              child: ListTile(
                title: Text('Language'),
                subtitle: Text('Select the language of the app'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Divider(),

            // Opzione 2: Notifiche
            InkWell(
              onTap: () {
                // Implementa la gestione dell'opzione qui
                // Ad esempio, mostra una modalità per abilitare/disabilitare le notifiche
                _showNotificationsDialog(context);
              },
              child: ListTile(
                title: Text('Notifications'),
                subtitle: Text('Enable or disable app notifications'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Divider(),

            // Opzione 4: Feedback
            ListTile(
              title: Text('Feedback'),
              subtitle: Text('Send feedback or report issues'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),
            Divider(),

            // Opzione 5: Informazioni sull'app
            InkWell(
              onTap: () {
                // Implementa la gestione dell'opzione qui
                // Ad esempio, mostra una modalità con informazioni sull'app
                _showAppInformationDialog(context);
              },
              child: ListTile(
                title: Text('App Information'),
                subtitle: Text('View information about the app'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Divider(),

            // Opzione 6: Privacy
            InkWell(
              onTap: () {
                // Implementa la gestione dell'opzione qui
                // Ad esempio, mostra una modalità con la politica sulla privacy
                _showPrivacyDialog(context);
              },
              child: ListTile(
                title: Text('Privacy'),
                subtitle: Text('View our privacy policy'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Divider(),

            // Opzione 7: Esci dall'account
            ListTile(
              title: Text('Sign Out'),
              subtitle: Text('Sign out from your account'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            Divider(),

            // Opzione 8: Resetta impostazioni
            ListTile(
              title: Text('Reset Settings'),
              subtitle: Text('Restore default app settings'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la gestione dell'opzione qui
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Send feedback or report issues to:'),
              GestureDetector(
                onTap: () {
                  // Aprire l'app di posta predefinita con la mail di destinazione
                  launch('mailto:dreamytales@flutter.com');
                },
                child: Text(
                  'dreamytales@flutter.com',
                  style: TextStyle(
                    color: Colors.blue, // Colore blu per indicare un link
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              // Altri widget per il feedback
            ],
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementa qui la logica per inviare il feedback
                      Navigator.pop(context);
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Language Selection'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Italiano'),
                    onTap: () {
                      setState(() {
                        selectedLanguage = 'Italiano';
                      });
                    },
                    leading: Radio(
                      value: 'Italiano',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('English'),
                    onTap: () {
                      setState(() {
                        selectedLanguage = 'English';
                      });
                    },
                    leading: Radio(
                      value: 'English',
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value as String;
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Salvare la lingua selezionata e chiudere la finestra
                          Navigator.pop(context);
                          // Implementa qui la logica per salvare la lingua selezionata
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Notification Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Do you want to receive notifications?'),
                  Switch(
                    value: receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        receiveNotifications = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Salvare le impostazioni delle notifiche e chiudere la finestra
                          Navigator.pop(context);
                          // Implementa qui la logica per salvare le impostazioni delle notifiche
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  // Funzione per mostrare una finestra modale di informazioni sull'app
  void _showAppInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Information'),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: 'Dreamy Tales is a bedtime story app for children. ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text: 'Our app uses AI to personalize bedtime stories, creating a magical experience for your child every night. ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  // Altri segmenti di testo per le informazioni sull'app
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  // Funzione per mostrare una finestra modale sulla privacy
  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy\n\n',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Last Updated: [01/01/2023]\n\n',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Information We Collect and How We Use It\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '- We collect personal information you voluntarily provide, such as your name and email.\n',
                  ),
                  TextSpan(
                    text: '- We automatically collect usage data to improve and customize your app experience.\n\n',
                  ),
                  TextSpan(
                    text: 'How We Use Your Information\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '- To provide and maintain our app.\n',
                  ),
                  TextSpan(
                    text: '- To improve and personalize app features.\n',
                  ),
                  TextSpan(
                    text: '- To analyze and understand app usage.\n\n',
                  ),
                  // Add more sections as needed...

                  TextSpan(
                    text: 'Updates to Our Privacy Policy\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '- Any changes to our privacy policy will be reflected on this page.\n\n',
                  ),
                  TextSpan(
                    text: 'By using our app, you agree to the terms outlined in this Privacy Policy.\n\n',
                  ),
                  TextSpan(
                    text: 'For questions or concerns, please contact us at [dreamytales@gmail.com].',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
