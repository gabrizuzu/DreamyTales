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
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset('assets/sfondo_fanatsy.jpg', fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Fantasy', style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset('assets/storie_classiche.png', fit: BoxFit.cover),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Classic', style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}