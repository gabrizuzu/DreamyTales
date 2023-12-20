import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoryPage extends StatefulWidget {
  final String moral;

  const StoryPage({Key? key, required this.moral}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  String _story = '';

  @override
  void initState() {
    super.initState();
    _generateStory();
  }

  Future<void> _generateStory() async {
    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
      },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'Once upon a time, there was a story with a moral.'},
            {'role': 'user', 'content': '${widget.moral}'},
          ],
        }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _story = data['choices'][0]['message']['content'];
      });
    } else {
      print('Failed to generate story: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('Generated Story: $_story'),
      ),
    );
  }
}