import 'package:dreamy_tales/auth.dart';
import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:dreamy_tales/pages/tutorial_screen.dart';
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
          if(snapshot.hasData) {
            return const MyHomePage(title: 'Dreamy Tales',);
          } else {
            return const TutorialScreen();
          }
        },
    );
  }
}
