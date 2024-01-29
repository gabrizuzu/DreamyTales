import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditSecondCharacterPage extends StatefulWidget {
  final String characterId;

  const EditSecondCharacterPage({super.key, required this.characterId});

  @override
  State<EditSecondCharacterPage> createState() =>
      _EditSecondCharacterPageState();
}

class _EditSecondCharacterPageState extends State<EditSecondCharacterPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? gender;
  String? role;
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
          .collection('second_characters')
          .doc(widget.characterId)
          .get();

      Map<String, dynamic> data =
      documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['name'] ?? '';
        gender = data['gender'] ?? '';
        role = data['role'] ?? '';
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
          'Edit Second Character',
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
                      child: DropdownButtonFormField<String>(
                        value: role,
                        decoration: InputDecoration(
                          labelText: 'Role',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: <String>[
                          'Grandparent',
                          'Parent',
                          'Sibling',
                          'Friend',
                          'Other'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            role = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
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
                        ],
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
                    _formKey.currentState?.save();
                    updateCharacter(widget.characterId);
                    Navigator.pop(context);
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
            ),
          ],
        ),
      ),
    );
  }

  void updateCharacter(String characterId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('second_characters')
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

      if (role != null && role!.isNotEmpty) {
        existingData['role'] = role;
      }

      if (selectedAvatar != null) {
        existingData['avatar'] = selectedAvatar;
      }

      await FirebaseFirestore.instance
          .collection('second_characters')
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
