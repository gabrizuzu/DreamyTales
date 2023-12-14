import 'package:flutter/material.dart';

class SettingsStoryPage extends StatefulWidget {
  const SettingsStoryPage({Key? key}) : super(key:key);

  @override
  State<SettingsStoryPage> createState() => _SettingsStoryPageState();
}

class _SettingsStoryPageState extends State<SettingsStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Image.asset('assets/sfondo_fanatsy.jpg', fit: BoxFit.cover), // Inserisci il percorso della tua immagine fantasy qui
                Text('Fantasy', style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Image.asset('storie_classiche.png', fit: BoxFit.cover), // Inserisci il percorso della tua immagine classic qui
                Text('Classic', style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}