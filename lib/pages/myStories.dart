import 'package:flutter/material.dart';

class MyStories extends StatelessWidget {
  const MyStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History of all the generated stories'),
      ),
      body: const Center(
        child: Text('No stories yet'),
      ),

    );
  }
}
