import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamy_tales/pages/reading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share/share.dart';

import '../pages/my_home_page.dart';

class MyStories extends StatelessWidget {
  const MyStories({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String currentUserId = currentUser != null ? currentUser.uid : '';
    CollectionReference stories =
        FirebaseFirestore.instance.collection('stories');

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage()), // Replace with your homepage
        );
        return false; // Return false to prevent default behavior
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sfondo.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                stories.where('userId', isEqualTo: currentUserId).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Connection Error');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              List<DocumentSnapshot> docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Center(
                  child: Text("You haven't written any stories yet"),
                );
              } else {
                return ListView(
                  children: docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String title = data['title'];

                    var story = data['storyId'];

                    List<String> protagonists;
                    double? rating;
                    var protagonistsData = data['characters'];

                    if (protagonistsData is String) {
                      protagonists = protagonistsData.split(
                          ', '); // separa la stringa in una lista utilizzando la virgola come separatore
                    } else if (protagonistsData is List) {
                      protagonists = List<String>.from(protagonistsData);
                    } else {
                      throw Exception('Unexpected data type for protagonists');
                    }
                    rating = data['rating'];

                    return Card(
                      color: Colors.black.withOpacity(0.6),
                      elevation: 5,
                      child: ListTile(
                        // elimina storia
                        onLongPress: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete story'),
                              content: const Text(
                                  'Do you want to delete this story?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'No'),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('stories')
                                            .where('storyId', isEqualTo: story)
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      querySnapshot.docs[0].reference.delete();
                                    }

                                    Navigator.pop(context, 'Confirm');
                                  },
                                  child: const Text('Confirm',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadingPage(
                                storyText: data['text'],
                                language: data['language'],
                              ),
                            ),
                          );
                        },

                        title: Row(children: [
                          Expanded(
                            child: title != ''
                                ? Text(
                                    title.replaceAll('*', ''),
                                    style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Amazing Story',
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              Share.share(
                                  'Look at my bedtime Storie generated with DreamyTales : ${data['text']}');
                            },
                          ),
                        ]),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Protagonists: ${protagonists.join(', ')}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Date: ${data['date']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(children: [
                              const Text(
                                'Rating:',
                                style: TextStyle(color: Colors.white),
                              ),
                              rating == null
                                  ? const Text(
                                      'No rating',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : RatingBarIndicator(
                                      rating: rating,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    )
                            ]),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
