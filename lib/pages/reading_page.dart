import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReadingPage extends StatefulWidget {
  final String storyText;

  ReadingPage({required this.storyText});

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column( 
          children: [
            Expanded(
              child: Scrollbar(
               child: Markdown(data: widget.storyText),
            ),
           ),
        ]
      ),
      ),
    );
  }
}