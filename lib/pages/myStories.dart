import 'package:flutter/material.dart';

class MyStories extends StatelessWidget {
  const MyStories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulazione di storie statiche salvate
    List<Story> stories = [
      Story(
        title: 'The Adventure in Wonderland',
        author: 'Alice',
        date: 'Jan 1, 2023',
      ),
      Story(
        title: 'The Mysterious Island',
        author: 'Jules Verne',
        date: 'Feb 15, 2023',
      ),
      Story(
        title: 'Magic Spells and Potions',
        author: 'Merlin',
        date: 'Mar 20, 2023',
      ),
      // Aggiungi altre storie se necessario
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: stories.length,
          itemBuilder: (context, index) {
            return StoryCard(story: stories[index]);
          },
        ),
      ),
    );
  }
}

class Story {
  final String title;
  final String author;
  final String date;

  Story({required this.title, required this.author, required this.date});
}

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.7),
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
              'Author: ${story.author}',
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
