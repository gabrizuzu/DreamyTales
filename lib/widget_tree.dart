import 'package:dreamy_tales/auth.dart';
import 'package:dreamy_tales/pages/home_page.dart';
import 'package:dreamy_tales/pages/tutorial_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context,snapshot) {
          // ignore: avoid_print
          print(snapshot.hasData);
          if(snapshot.hasData) {
            return HomePage();
          } else {
            return const TutorialScreen();
          }
        },
    );
  }
}
