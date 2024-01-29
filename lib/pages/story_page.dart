import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

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

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String selectedLanguage = preferences.getString('selectedLanguage') ?? 'English';

    if (selectedLanguage == 'English') {
      _flutterTts.setLanguage('en-US');
    } else {
      _flutterTts.setLanguage('it-IT');
    }

    var characters = await _getCharacters();
    var secondaryCharacters = await _getSecondaryCharacters();
    var plotPreference = await _getPlotPreference();
    var moralPreference = await _getMoralPreference();
  

    String userMessage;
    if (selectedLanguage == 'Italiano') {
      userMessage =
      'Genera il titolo e una storia della buonanotte per bambini ambientata nel mondo di $plotPreference e dove i protagonisti sono: $characters, con i seguenti personaggi secondari $secondaryCharacters. La storia dovrebbe contenere la morale $moralPreference. Il titolo e il capitolo devono essere scritti in grassetto.';
    } else {
      userMessage =
      'Generate the title and a bedtime story for children set in the world of $plotPreference and where the protagonists are: $characters, with the following secondary characters $secondaryCharacters. The story should contain the moral $moralPreference. The title and the chapter must be written in bold.';
    }

    var url = Uri.parse('https://api.openai.com/v1/chat/completions');
    var response = await http.post(
      url,
      headers: {
        'Authorization':
        'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'max_tokens': 1000,
        'messages': [
          {
            'role': 'system',
            'content': 'Once upon a time, there was a story with a moral.'
          },
          {'role': 'user', 'content': userMessage},
        ],
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _story = data['choices'][0]['message']['content'];
        _title = _story.split('\n').first.trim();
        _isGenerating = false;
      });
      var firestore = FirebaseFirestore.instance;
      var currentUserId = FirebaseAuth.instance.currentUser!.uid;
      docRef = await firestore.collection('stories').add({
        'userId': currentUserId,
        'text': _story,
        'title': _title,
        'characters': await _getCharacters(),
        'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'moral': moralPreference,
        'rating': null,
        'language': selectedLanguage,
      });
    } else {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Future<String> _getCharacters() async {
    var firestore = FirebaseFirestore.instance;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var characters = await firestore
        .collection('characters')
        .where('userId', isEqualTo: currentUserId)
        .get();
    return characters.docs.map((doc) => doc['name'].toString()).join(', ');
  }
    Future<String> _getAvatar() async {
    var firestore = FirebaseFirestore.instance;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var characters = await firestore
        .collection('characters')
        .where('userId', isEqualTo: currentUserId)
        .get();
    return characters.docs.isNotEmpty
    ? characters.docs.first['avatar'].toString()
    : 'assets/avatar_M6.png';
  }
 
  Future<String> _getSecondaryCharacters() async {
    var firestore = FirebaseFirestore.instance;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    var secondaryCharacters = await firestore
        .collection('second_characters')
        .where('userId', isEqualTo: currentUserId)
        .get();
    return secondaryCharacters.docs
        .map((doc) => '${doc['name']} (${doc['role']})')
        .join(', ');
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isGenerating
          ? Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/sfondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Transform.scale(
              scale: 1.2, // Aumenta la scala dell'immagine del 20%
              child: Image.asset(
                'assets/picmix.com_406047.gif',
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Good things take time...',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/sfondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    FutureBuilder<String>(
                    future: _getAvatar(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // mostra un indicatore di caricamento mentre si attende
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return CircleAvatar(
                          radius: 200,
                          backgroundImage: AssetImage(snapshot.data ?? 'assets/avatar_M6.png'),
                        );
                      }
                    },
                  ),
                    ..._story.split('\n\n').map((chapter) {
                      final boldParts =
                      RegExp(r'\*\*(.+?)\*\*').allMatches(chapter);
                      final spans = <TextSpan>[];
                      var start = 0;
                      for (final match in boldParts) {
                        if (match.start > start) {
                          spans.add(TextSpan(
                            text: chapter.substring(start, match.start),
                          ));
                        }
                        spans.add(TextSpan(
                          text: match.group(1),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ));
                        start = match.end;
                      }
                      if (start < chapter.length) {
                        spans.add(TextSpan(
                          text: chapter.substring(start),
                        ));
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            children: spans,
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
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
                                itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
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
                                  child: const Text('Confirm'),
                                  onPressed: () async {
                                    await docRef?.update(
                                        {'rating': _currentRating});
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MyHomePage()),
                                          (route) => false,
                                    );
                                  },
                                ),
                                TextButton(
                                  child: const Text('Skip'),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MyHomePage()),
                                          (route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                          if (rating != null) {
                            await docRef?.update({'rating': rating});
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const MyHomePage()),
                                (route) => false,
                          );
                        },
                        child: const Text('Go back to Home Page'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (!_isPlaying)
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: _play,
                    ),
                  if (_isPlaying)
                    IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: _pause,
                    ),
                  if (_isPlaying)
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: _stop,
                    ),
                  if (!_isPlaying)
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _reset,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _play() async {
    await _flutterTts.speak(_story);
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() async {
    await _flutterTts.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  void _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _reset() async {
    await _flutterTts.stop();
    await _flutterTts.speak(_story);
    setState(() {
      _isPlaying = true;
    });
  }

  @override
  void deactivate() {
    if (_isPlaying) {
      _flutterTts.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_isPlaying) {
      _flutterTts.pause();
    }
    super.dispose();
  }
}
