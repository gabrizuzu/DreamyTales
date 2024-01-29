import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCharacterPage extends StatefulWidget {
  final String characterId;

  const EditCharacterPage({super.key, required this.characterId});

  @override
  State<EditCharacterPage> createState() => _EditCharacterPageState();
}

class _EditCharacterPageState extends State<EditCharacterPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? gender;
  double age = 0;
  String avatarDefault = 'assets/avatar_M1.png';
  String? selectedAvatar;
  late TextEditingController _nameController;

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
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchCharacterData();
  }

  void _fetchCharacterData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('characters')
          .doc(widget.characterId)
          .get();

      Map<String, dynamic> data =
      documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['name'] ?? '';
        gender = data['gender'] ?? '';
        age = data['age']?.toDouble() ?? 0;
        selectedAvatar = data['avatar'] ?? '';
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching character data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Character',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sfondo.jpg"),
            fit: BoxFit.cover,
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
                        controller: _nameController,
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
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DropdownButtonFormField<String>(
                        value: gender,
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
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a gender';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age: ${age.toInt()}',
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
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Swipe right to explore avatars',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontStyle: FontStyle.italic,
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
            Container(
              width: double.infinity,
              height: 60.0,
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: TextButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Save"),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    updateCharacter(widget.characterId);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  void updateCharacter(String characterId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('characters')
          .doc(characterId)
          .get();

      Map<String, dynamic> existingData =
      documentSnapshot.data() as Map<String, dynamic>;

      if (_nameController.text.isNotEmpty) {
        existingData['name'] = _nameController.text;
      }

      if (gender != null && gender!.isNotEmpty) {
        existingData['gender'] = gender;
      }

      existingData['age'] = age.toInt();

      if (selectedAvatar != null) {
        existingData['avatar'] = selectedAvatar;
      }

      await FirebaseFirestore.instance
          .collection('characters')
          .doc(characterId)
          .update(existingData);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating character: $e');
      }
    }
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
                  fit: BoxFit.contain,
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
