import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoryPage extends StatefulWidget {
  final String moral;

  const StoryPage({Key? key, required this.moral}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  String _story = '';
  bool _isGenerating = false;
  bool error = false;
  @override
  void initState() {
    super.initState();
    _generateStory();
  }

  Future<void> _generateStory() async {
      setState(() {
        _isGenerating = true;
      });
      var characters = await _getCharacters();
      var secondaryCharacters = await _getSecondaryCharacters();
      var plotPreference = await _getPlotPreference();
      var moralPreference = await _getMoralPreference();

      // Costruisci il messaggio dell'utente
      var userMessage = 'Generate a bedtime story for children setted in the world of $plotPreference and where the protagonists are: $characters, with the following secondary characters $secondaryCharacters. The story should contain the moral $moralPreference and should have a title and should be divided into chapters.';
      print(userMessage);
      var url = Uri.parse('https://api.openai.com/v1/chat/completions');
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer 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',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'max_tokens': 1000,
          'messages': [
            {'role': 'system', 'content': 'Once upon a time, there was a story with a moral.'},
            {'role': 'user', 'content': userMessage},
          ],
        }),
      );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _story = data['choices'][0]['message']['content'];
        _isGenerating = false;
      });
    } else {
      print('Failed to generate story: ${response.statusCode}');
      setState(() {
      _isGenerating = false;
    });
    }
  }
Future<String> _getCharacters() async {
  var firestore = FirebaseFirestore.instance;
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var characters = await firestore.collection('characters').where('userId', isEqualTo: currentUserId).get();
  return characters.docs.map((doc) => doc['name'].toString()).join(', ');
}

Future<String> _getSecondaryCharacters() async {
  var firestore = FirebaseFirestore.instance;
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var secondaryCharacters = await firestore.collection('second_characters').where('userId', isEqualTo: currentUserId).get();
  return secondaryCharacters.docs.map((doc) => '${doc['name']} (${doc['role']})').join(', ');
}

Future<String> _getPlotPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('plotPreference') ?? '';
}

Future<String> _getMoralPreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('moralPreference') ?? '';
}
  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Story Page'),
      backgroundColor: Colors.deepPurple,
    ),
    body:_isGenerating
        ? const Center(child: CircularProgressIndicator()) : 
            Stack(
              children: [
                // Immagine di sfondo
                Positioned.fill(
                  child: Image.asset(
                    'assets/sfondo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                // Contenuto scorrevole
                ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    Center(
                      child: Text(
                        'Generated Story: $_story',
                        style: TextStyle(
                          backgroundColor: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}