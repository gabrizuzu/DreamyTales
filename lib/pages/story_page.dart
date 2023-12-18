import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  final String moral;

  const StoryPage({Key? key, required this.moral}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('Selected Moral: ${widget.moral}'),
      ),
    );
  }
}