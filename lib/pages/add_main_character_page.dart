import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMainCharacterPage extends StatefulWidget {
  const AddMainCharacterPage({super.key});

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
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 120, left: 16.0, right: 16.0, bottom: 16.0),
                      child: TextFormField(
                        key: const Key("name"),
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
                          } else if (value.length < 3 || value.length > 20) {
                            return 'Name should be between 3 and 20 characters';
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
                        key: const Key("dropDownGender"),
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
                            key : const Key("age"),
                            'Age: ${age.toInt()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Slider(
                            key : const Key("slider"),
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
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Swipe right to explore avatars',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Anteprima di tutti gli avatar nello slider
                            for (String avatarPath in allAvatars)
                              AvatarPreview(
                                key: ValueKey(avatarPath),
                                imagePath: avatarPath,
                                onPressed: () {
                                  setState(() {
                                    selectedAvatar = avatarPath;
                                  });
                                },
                                isSelected: avatarPath == selectedAvatar,
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
                    icon: const Icon(Icons.check),
                    // Imposta l'icona del pulsante
                    label: const Text("Save"),
                    // Imposta il testo del pulsante
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (selectedAvatar == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an avatar'),
                            ),
                          );
                        } else {
                          _formKey.currentState?.save();
                          saveData();
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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

  const AvatarPreview({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.isSelected = false,
  });

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
        child: Column(
          children: [
            ClipOval(
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
            if (widget.isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.amber,
              ),
          ],
        ),
      ),
    );
  }
}
