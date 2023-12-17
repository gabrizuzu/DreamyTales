import 'package:flutter/material.dart';

import 'login_register_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
                // Implementa la gestione dell'opzione qui
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
              },
              child: ListTile(
                title: Text('Notifications'),
                subtitle: Text('Enable or disable app notifications'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
            Divider(),

            // Opzione 3: Tema dell'applicazione
            ListTile(
              title: Text('App Theme'),
              subtitle: Text('Choose between light and dark themes'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la gestione dell'opzione qui
              },
            ),
            Divider(),

            // Opzione 4: Feedback
            ListTile(
              title: Text('Feedback'),
              subtitle: Text('Send feedback or report issues'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la gestione dell'opzione qui
              },
            ),
            Divider(),

            // Opzione 5: Informazioni sull'app
            ListTile(
              title: Text('App Information'),
              subtitle: Text('View information about the app'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la gestione dell'opzione qui
              },
            ),
            Divider(),

            // Opzione 6: Privacy
            ListTile(
              title: Text('Privacy'),
              subtitle: Text('View our privacy policy'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Implementa la gestione dell'opzione qui
              },
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
}
