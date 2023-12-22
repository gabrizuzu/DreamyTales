import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditCharacterPage extends StatefulWidget {
  final String characterId;

  const EditCharacterPage({Key? key, required this.characterId})
      : super(key: key);

  @override
  State<EditCharacterPage> createState() => _EditCharacterPageState();
}

class _EditCharacterPageState extends State<EditCharacterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? name;
  String? gender;
  double age = 0;
  String? tastes;
  String avatarDefault = 'assets/avatar_M1.png';
  String? selectedAvatar;
  late TextEditingController _nameController;

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
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchCharacterData();
  }

  void _fetchCharacterData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('characters')
          .doc(widget.characterId)
          .get();

      Map<String, dynamic> data =
      documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['name'] ?? '';
        gender = data['gender'] ?? '';
        tastes = data['taste'] ?? '';
        age = data['age']?.toDouble() ?? 0;
        selectedAvatar = data['avatar'] ?? '';
      });
    } catch (e) {
      print('Error fetching character data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Character',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sfondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
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
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: tastes,
                  decoration: InputDecoration(
                    labelText: 'Tastes',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: <String>[
                    'Marvel',
                    'Disney',
                    'Hogwarts',
                    'Star Wars',
                    'Others'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      tastes = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select tastes';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
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
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
                      GestureDetector(
                        onTap: () {
                          _showAllAvatarsDialog();
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
                const SizedBox(height: 16),
                Expanded(
                  child: Container(),
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
        ),
      ),
    );
  }

  void _showAllAvatarsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
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

      if (tastes != null && tastes!.isNotEmpty) {
        existingData['taste'] = tastes;
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
      print('Error updating character: $e');
    }
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
      ),
    );
  }
}
