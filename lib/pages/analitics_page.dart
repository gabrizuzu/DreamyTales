import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_home_page.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

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
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/sfondo.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  // Altezza extra per far sì che il contenuto non vada sotto la barra di stato
                  height: 24.0,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stories')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        color: Colors.deepPurpleAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Generated Stories: ${snapshot.data!.docs.length}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    // Caso in cui non ci sono storie presenti
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'No stories available yet',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('Top 5 stories',
                    style: TextStyle(fontSize: 24, color: Colors.deepPurple)),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stories')
                      .where('userId', isEqualTo: userId)
                      .orderBy('rating', descending: true)
                      .limit(5)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.docs.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      child: Text('${index + 1}'),
                                    ),
                                    title: Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: const TextStyle(fontSize: 18)),
                                    subtitle: Text(
                                        'Rating: ${snapshot.data!.docs[index]['rating']}',
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                );
                              },
                            )
                          : const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No stories available yet',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
