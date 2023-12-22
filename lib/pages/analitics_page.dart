import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Analytics extends StatelessWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Container(
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
                        child: Text('Generated Stories: ${snapshot.data!.docs.length}', style: const TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 20),
              const Text('Top 5 stories', style: TextStyle(fontSize: 24, color: Colors.deepPurple)),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stories')
                    .where('userId', isEqualTo: userId)
                    .orderBy('rating', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                            title: Text(snapshot.data!.docs[index]['title'], style: const TextStyle(fontSize: 18)),
                            subtitle: Text('Rating: ${snapshot.data!.docs[index]['rating']}', style: const TextStyle(fontSize: 16)),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}