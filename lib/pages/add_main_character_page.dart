import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMainCharacterPage extends StatefulWidget {
  const AddMainCharacterPage({Key? key}) : super(key: key);

  @override
  State<AddMainCharacterPage> createState() => _AddMainCharacterPageState();
}

class _AddMainCharacterPageState extends State<AddMainCharacterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? name;
  String? gender;
  double age = 0;
  String? tastes;
  String avatarDefault = 'assets/avatar_M1.png';
  String? selectedAvatar; // avatar default



  // Lista completa di avatar
  final List<String> allAvatars = [
    'assets/avatar_M1.png',
    'assets/avatar_M2.png',
    'assets/avatar_M3.png',
    'assets/avatar_M4.png',
    'assets/avatar_M5.png',
    'assets/avatar_M6.png',
    'assets/avatar_M8.png',
    'assets/avatar_M7.png',
    'assets/avatar_F1.png',
    'assets/avatar_F2.png',
    'assets/avatar_F3.png',
    'assets/avatar_F4.png',
    'assets/avatar_F5.png',
    'assets/avatar_F6.png',
    'assets/avatar_F7.png',
    // Aggiungi gli avatar desiderati
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Add a new main character",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Comic Sans MS',
            color: Colors.amber,
          ),
        ),
        elevation: 10,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sfondo.jpg"),
            fit: BoxFit.fill,
          ),
        ),
       child: Column(
        children:[
        Form(
          key: _formKey,
          child: Expanded(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 120, left: 16.0, right: 16.0, bottom: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: <String>['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  onSaved: (String? value) {
                    gender = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Età: ${age.toInt()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: age,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: age.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          age = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Metti l'avatar selezionato come primo tra i quattro
                      if (selectedAvatar != null)
                        AvatarPreview(
                          imagePath: selectedAvatar!,
                          onPressed: () {
                            setState(() {
                              selectedAvatar = avatarDefault;
                            });
                          },
                          isSelected: true,
                        ),
                      // Anteprima delle prime 6 immagini (escludendo l'avatar selezionato)
                      for (int i = 0; i < 6; i++)
                        if (allAvatars[i] != selectedAvatar)
                          AvatarPreview(
                            imagePath: allAvatars[i],
                            onPressed: () {
                              setState(() {
                                selectedAvatar = allAvatars[i];
                              });
                            },
                          ),
                      // Bottone per visualizzare altri avatar
                      GestureDetector(
                        onTap: () {
                          _showAllAvatarsDialog(); // Chiamata alla tua funzione esistente
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            'Show all',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
                              Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    height: 60.0, // Imposta l'altezza del pulsante
                    decoration: const BoxDecoration(
                      color: Colors
                          .amber, // Imposta il colore di sfondo del pulsante
                    ),
                    child: TextButton.icon(
                      icon: const Icon(Icons.check), // Imposta l'icona del pulsante
                      label: const Text("Save"), // Imposta il testo del pulsante
                      onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (selectedAvatar == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Text('Please select an avatar'),
                              );
                            },
                          );
                        } else {
                          _formKey.currentState?.save();
                          saveData();
                          Navigator.pop(context);
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Text('Please fill all the fields'),
                            );
                          },
                        );
                      }
                      },
                    ),
                  );
                },
              ),
        ]

      ),
      ),
    );
  }

  void _showAllAvatarsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0, // Altezza fissa dello slider orizzontale
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _sortedAvatarList().length,
            itemBuilder: (BuildContext context, int index) {
              String avatarPath = _sortedAvatarList()[index];
              return AvatarPreview(
                imagePath: avatarPath,
                onPressed: () {
                  setState(() {
                    selectedAvatar = avatarPath;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }


  List<String> _sortedAvatarList() {
    List<String> sortedList = List.from(allAvatars);
    if (selectedAvatar != null) {
      sortedList.remove(selectedAvatar);
      sortedList.insert(0, selectedAvatar!);
    }
    return sortedList;
  }

  void saveData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    await _firestore.collection('characters').add({
      'userId': userId,
      'name': name,
      'gender': gender,
      'age': age.toInt(),
      'taste': tastes,
      'avatar': selectedAvatar,
    });
  }
}

class AvatarPreview extends StatefulWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final bool isSelected;

  AvatarPreview({
    Key? key,
    required this.imagePath,
    required this.onPressed,
    this.isSelected = false,
  }) : super(key: key);

  @override
  _AvatarPreviewState createState() => _AvatarPreviewState();
}


class _AvatarPreviewState extends State<AvatarPreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isSelected) {
          widget.onPressed();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: Container(
            width: 70.0,
            height: 70.0,
            color: widget.isSelected ? Colors.amber : Colors.transparent,
            child: FittedBox(
              fit: BoxFit.contain, // Imposta il tipo di adattamento
              child: Image.asset(
                widget.imagePath,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
