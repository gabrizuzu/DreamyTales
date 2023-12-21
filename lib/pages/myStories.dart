import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyStories extends StatelessWidget {
  const MyStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentUserId = currentUser != null ? currentUser.uid : '';
    CollectionReference stories = FirebaseFirestore.instance.collection('stories');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding:const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: stories.where('userId', isEqualTo: currentUserId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Connection Error');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String text = data['text'];
                // ignore: prefer_interpolation_to_compose_strings
                String shortText = text.length > 20 ? text.substring(0, 20) + '...' : text;
                return ListTile(
                  title: Text(data['title']),
                  subtitle: Text('Data: ${data['date']}\n Text: $shortText'),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class Story {
  final String title;
  final String date;
  final String text;

  Story({required this.title, required this.text, required this.date});
}

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.6),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          story.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Author: ${story.text}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4.0),
            Text(
              'Date: ${story.date}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onTap: () {
          // Implementa la navigazione alla pagina della storia completa
          // Puoi utilizzare Navigator.push per spostarti a una nuova pagina
        },
      ),
    );
  }
}
