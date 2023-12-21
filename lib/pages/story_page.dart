import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
class StoryPage extends StatefulWidget {
  

  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  String _story = '';
  String? _title;
  bool _isGenerating = false;
  DocumentReference? docRef;
  bool _isPlaying = false;
  double? _currentRating;
  final FlutterTts _flutterTts = FlutterTts();
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
      var userMessage = 'Generate a bedtime story for children setted in the world of $plotPreference and where the protagonists are: $characters, with the following secondary characters $secondaryCharacters. The story should contain the moral $moralPreference.The should have a title and should be divided into chapters, the title and the chapter must be written in bold.';
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
        RegExp titleExp = RegExp(r'Title: (.*?)\*\*');
        RegExpMatch? titleMatch = titleExp.firstMatch(_story);
        _title = titleMatch != null ? titleMatch.group(1)?.trim() : "";
        _isGenerating = false;
      });
      var firestore = FirebaseFirestore.instance;
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      docRef = await firestore.collection('stories').add({
        'userId': currentUserId,
        'text': _story,
        'title': _title,
        'characters': await _getCharacters(),
        'date': DateTime.now(),
        'rating': null,
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
    body:_isGenerating
        ? Stack(
            children: <Widget>[
              // Immagine di sfondo animata
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/sfondo.jpg'), // sostituisci con il percorso della tua immagine animata
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Indicatore di progresso al centro
              Center(
                child: CircularProgressIndicator(),
              ),
              // Testo di attesa
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Good things take time...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ) : 
           Stack(
    children: <Widget>[
      // Immagine di sfondo
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo.jpg'), 
            fit: BoxFit.cover,
          ),
        ),
      ),
      // ListView e bottone Magic Reader
      Column(
        children: <Widget>[
          Expanded(
            child: ListView(
                                padding: const EdgeInsets.all(8.0),
                  children: [
                    // CircleAvatar
                    const CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('assets/female.png'), // sostituisci con il percorso della tua immagine
                    ),
                    // Storia divisa per capitoli
                    ..._story.split('\n\n').map((chapter) {
                      // Trova tutte le parti del capitolo che devono essere in grassetto
                      final boldParts = RegExp(r'\*\*(.+?)\*\*').allMatches(chapter);
                      // Crea una lista di TextSpan per ogni parte del capitolo
                      final spans = <TextSpan>[];
                      var start = 0;
                      for (final match in boldParts) {
                        // Aggiungi il testo normale prima della parte in grassetto
                        if (match.start > start) {
                          spans.add(TextSpan(
                            text: chapter.substring(start, match.start),
                          ));
                        }
                        // Aggiungi la parte in grassetto
                        spans.add(TextSpan(
                          text: match.group(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ));
                        start = match.end;
                      }
                      // Aggiungi il testo normale dopo l'ultima parte in grassetto
                      if (start < chapter.length) {
                        spans.add(TextSpan(
                          text: chapter.substring(start),
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                            children: spans,
                          ),
                        ),
                      );
                    }).toList(),
                    // Pulsante per tornare a my_home_page.dart
Padding(
  padding: const EdgeInsets.only(top: 20.0),
  child: ElevatedButton(
    onPressed: () async {
      // Mostra un dialogo per chiedere all'utente di valutare la storia
      final rating = await showDialog<double>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rate this story :)'),
          content: RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _currentRating = rating;
            },
          ),
          actions: [
             TextButton(
          child: const Text('Conferma'),
          onPressed: () async {        
            await docRef?.update({'rating': _currentRating});
            // Torna a my_home_page.dart
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
        ),
            TextButton(
              child: const Text('Skip'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
              },
            ),
          ],
        ),
      );
  if (rating != null) {
    await docRef?.update({'rating': rating});
  }
      // Torna a my_home_page.dart
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    },
    child: const Text('Torna alla Home Page'),
  ),
),
                  ],
            ),
          ),
              if (_isPlaying)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () async {
                        await _flutterTts.pause();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () async {
                        await _flutterTts.stop();
                        setState(() {
                          _isPlaying = false;
                        });
                      },
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: () async {
                    await _flutterTts.speak(_story);
                    setState(() {
                      _isPlaying = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    color: Colors.amber,
                    child: const Center(
                      child: Text(
                        'Magic Reader',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                        ),
                      ),
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