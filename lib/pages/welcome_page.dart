// ignore_for_file: library_private_types_in_public_api

import 'package:dreamy_tales/utils/colors.dart';
import 'package:dreamy_tales/widgets/app_large_text.dart';
import 'package:dreamy_tales/widgets/app_text.dart';
import 'package:dreamy_tales/widgets/responsive_button.dart';
import 'package:flutter/material.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key:key);

  @override
  
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    'welcome1.jpg',
    'welcome2.jpg',
    'welcome3.jpg',
  ];
  List largetext= [
    'Dreamy Tales',
    'Unique Stories',
    "Educational Purpose",
  ];
  List text = [
    "It's story time",
    "Original stories for your kids",
    "Grow your kids' imagination",
  ];
  List description = [
    "Dreamy Tales is a platform where you can generate and read stories. You can also share your stories with your friends and family.",
    "You can generate your own original story by selecting the characters, setting, and plot.",
    "You can chose also a moral lesson to teach to your kids for each story",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (_, index){
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                // ignore: prefer_interpolation_to_compose_strings
                image: AssetImage(
                  'img/'+images[index]
                ),
                fit: BoxFit.cover,
              ),

            ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centra i widget verticalmente
                  children: [
                    AppLargeText(text: largetext[index], size: 40,color: Colors.white),
                    AppText(text: text[index], size: 30,color: Colors.white54),
                    SizedBox(height: 20,),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: AppText(
                              text: description[index],
                              size: 18,
                              color: Colors.black87,
                          ),
                          ),
                      )
                    ),
                    SizedBox(height: 40,),
                    ResponsiveButton(width: 120),
                    Column(
                      
                    )                  
                  ],
                ),
              ),
          );
      }
      ),
    );
  }
}