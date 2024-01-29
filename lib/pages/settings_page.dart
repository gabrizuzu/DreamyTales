import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../auth.dart';
import 'login_register_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool receiveNotifications = true; // Add this variable
  late SharedPreferences _preferences;
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage =
          _preferences.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveLanguage(String language) async {
    await _preferences.setString('selectedLanguage', language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Opzione 1: Lingua
            InkWell(
              onTap: () {
                _showLanguageSelectionDialog(context);
              },
              child: const ListTile(
                title: Text('Language',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Select the language of the stories'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            const Divider(),

            // Opzione 2: Notifiche
            InkWell(
              onTap: () {
                _showNotificationsDialog(context);
              },
              child: const ListTile(
                title: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Enable or disable app notifications'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            const Divider(),

            // Opzione 4: Feedback
            ListTile(
              title: const Text('Feedback',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Send feedback or report issues'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                _showFeedbackDialog(context);
              },
            ),
            const Divider(),

            // Opzione 5: Informazioni sull'app
            InkWell(
              onTap: () {
                _showAppInformationDialog(context);
              },
              child: const ListTile(
                title: Text('App Information',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('View information about the app'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            const Divider(),

            // Opzione 6: Privacy
            InkWell(
              onTap: () {
                _showPrivacyDialog(context);
              },
              child: const ListTile(
                title: Text('Privacy',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('View our privacy policy'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            const Divider(),

            // Opzione 7: Esci dall'account
            ListTile(
              title: const Text('Sign Out',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Sign out from your account'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            const Divider(),
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
          title: const Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Send feedback or report issues to:'),
              GestureDetector(
                onTap: () {
                  // Aprire l'app di posta predefinita con la mail di destinazione
                  launchUrlString('mailto:dreamytales@flutter.com');
                },
                child: const Text(
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
                      // Implementa qui la logica per inviare il feedback
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
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
              title: const Text(
                  'In which Language do you want to generate the Stories?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Italiano'),
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
                    title: const Text('English'),
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
                        onPressed: () async {
                          // Salva la lingua selezionata e chiudi la finestra
                          await _saveLanguage(selectedLanguage);
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
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
              title: const Text('Notification Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Do you want to receive notifications?'),
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
                          // Salvare le impostazioni delle notifiche e chiudere la finestra
                          Navigator.pop(context);
                          // Implementa qui la logica per salvare le impostazioni delle notifiche
                        },
                        child: const Text('Ok'),
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
          title: const Text('App Information'),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const [
                  TextSpan(
                    text: 'Dreamy Tales is a bedtime story app for children. ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Our app uses AI to personalize bedtime stories, creating a magical experience for your child every night. ',
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
              child: const Text('OK'),
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
                children: const <TextSpan>[
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
                    text:
                        '- We collect personal information you voluntarily provide, such as your name and email.\n',
                  ),
                  TextSpan(
                    text:
                        '- We automatically collect usage data to improve and customize your app experience.\n\n',
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
                    text:
                        '- Any changes to our privacy policy will be reflected on this page.\n\n',
                  ),
                  TextSpan(
                    text:
                        'By using our app, you agree to the terms outlined in this Privacy Policy.\n\n',
                  ),
                  TextSpan(
                    text:
                        'For questions or concerns, please contact us at [dreamytales@gmail.com].',
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }
}
