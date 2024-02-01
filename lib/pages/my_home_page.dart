import 'package:dreamy_tales/pages/add_main_character_page.dart';
import 'package:dreamy_tales/pages/add_second_character_page.dart';
import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:dreamy_tales/utils/settings_story.dart';
import 'package:flutter/material.dart';
import 'package:dreamy_tales/pages/analitics_page.dart';
import 'package:dreamy_tales/utils/myStories.dart';
import 'package:dreamy_tales/pages/settings_page.dart';
import 'myDrawer.dart';
import 'app_category.dart';
import 'package:dreamy_tales/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_character.dart';
import 'edit_second_character.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppCategory _currentCategory = AppCategory.home;
  bool? color = false;
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void _exitApp() {
    Navigator.pop(context); // Chiudi il Drawer
    signOut();
    _logout();
  }

  void _changeCategory(AppCategory category) {
    setState(() {
      _currentCategory = category;
    });
    Navigator.pop(context); // Chiudi il Drawer
  }

  String _getTitleForCurrentCategory() {
    switch (_currentCategory) {
      case AppCategory.home:
        return "Dreamy Tales";
      case AppCategory.myStories:
        return "My Stories";
      case AppCategory.analytics:
        return "Analytics";
      case AppCategory.settings:
        return "Settings";
      default:
        return "Dreamy Tales";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.amber),
        title: Text(
          _getTitleForCurrentCategory(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Comic Sans MS',
            color: Colors.amber,
          ),
        ),
        elevation: 10,
      ),
      body: _buildBody(),
      drawer: MyDrawer(
        currentCategory: _currentCategory,
        onCategorySelected: _changeCategory,
        onLogout: _logout,
        onExit: _exitApp,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentCategory) {
      case AppCategory.home:
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/sfondo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 50.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            key: const Key("mainCharacters"),
                            'Main Characters:',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                shadows: List.generate(
                                    1,
                                    (index) => const Shadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 45.0),
                      child: SizedBox(
                        height: 160,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('characters')
                              .where('userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }

                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                String imagePath = data['avatar'];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditCharacterPage(
                                                characterId: document.id,
                                              ),
                                            ),
                                          );
                                        },
                                        onLongPress: () async {
                                          bool? shouldDelete =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirm'),
                                                content: const Text(
                                                  'Are you sure you want to delete this character?',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (shouldDelete == true) {
                                            FirebaseFirestore.instance
                                                .collection('characters')
                                                .doc(document.id)
                                                .delete();
                                          }
                                        },
                                        child: ClipOval(
                                          child: Image.asset(
                                            imagePath,
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: data['name'] != null &&
                                                      data['name'].isNotEmpty
                                                  ? data['name']![0]
                                                      .toUpperCase()
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                decoration: TextDecoration.none,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    // Colore dell'ombra
                                                    offset: Offset(1.0,
                                                        1.0), // Offset dell'ombra rispetto al testo
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextSpan(
                                              text: data['name'] != null &&
                                                      data['name'].length > 1
                                                  ? data['name']!
                                                      .substring(1)
                                                      .toLowerCase()
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.none,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    // Colore dell'ombra
                                                    offset: Offset(1.0,
                                                        1.0), // Offset dell'ombra rispetto al testo
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()
                                ..add(
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            key: const Key("addMainCharacter"),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 50.0,
                                            ),
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddMainCharacterPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 45.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            key: const Key("secondCharacters"),
                            'Second Characters:',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                                shadows: List.generate(
                                    1,
                                    (index) => const Shadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: Offset(1, 1)))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 45.0),
                      child: SizedBox(
                        height: 160,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('second_characters')
                              .where('userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                String imagePath = data['avatar'];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditSecondCharacterPage(
                                                characterId: document.id,
                                              ),
                                            ),
                                          );
                                        },
                                        onLongPress: () async {
                                          bool? shouldDelete =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirm'),
                                                content: const Text(
                                                  'Are you sure you want to delete this character?',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (shouldDelete == true) {
                                            FirebaseFirestore.instance
                                                .collection('second_characters')
                                                .doc(document.id)
                                                .delete();
                                          }
                                        },
                                        child: ClipOval(
                                          child: Image.asset(
                                            imagePath,
                                            width: 100.0,
                                            height: 100.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: data['name'] != null &&
                                                      data['name'].isNotEmpty
                                                  ? data['name']![0]
                                                      .toUpperCase()
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                decoration: TextDecoration.none,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    // Colore dell'ombra
                                                    offset: Offset(1.0,
                                                        1.0), // Offset dell'ombra rispetto al testo
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextSpan(
                                              text: data['name'] != null &&
                                                      data['name'].length > 1
                                                  ? data['name']!
                                                      .substring(1)
                                                      .toLowerCase()
                                                  : '',
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.none,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    // Colore dell'ombra
                                                    offset: Offset(1.0,
                                                        1.0), // Offset dell'ombra rispetto al testo
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()
                                ..add(
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              size: 50.0,
                                            ),
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddSecondCharacterPage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 60.0,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
                child: TextButton.icon(
                  key: const Key("startMagic"),
                  icon: const Icon(Icons.star),
                  label: const Text("Let's start the magic"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsStoryPage(),
                    ));
                  },
                ),
              ),
            ],
          ),
        );
      case AppCategory.myStories:
        return const MyStories();
      case AppCategory.analytics:
        return const Analytics();
      case AppCategory.settings:
        return const SettingsScreen();
      default:
        return Container();
    }
  }
}
