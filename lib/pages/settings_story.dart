import 'package:dreamy_tales/pages/fantasy_plot.dart';
import 'package:dreamy_tales/pages/plot_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('storyPreference', 'Fantasy');
                Navigator.push(context, MaterialPageRoute(builder: (context) => FantasyPlotPage()));
              },
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset('assets/storie_fantasy.jpg', fit: BoxFit.cover),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Fantasy', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color:Colors.amber,shadows: List.generate(1, (index) => Shadow(color: Colors.black, blurRadius: 10, offset: Offset(1, 1)))),))
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('storyPreference', 'Classic');
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlotChoice()));
              },
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset('assets/storie_classiche.png', fit: BoxFit.cover),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text('Classic', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color:Colors.amber,shadows: List.generate(1, (index) => Shadow(color: Colors.black, blurRadius: 10, offset: Offset(1, 1))))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}