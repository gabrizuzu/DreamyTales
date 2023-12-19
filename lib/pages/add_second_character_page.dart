import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSecondCharacterPage extends StatefulWidget {
  const AddSecondCharacterPage({Key? key}) : super(key: key);

  @override
  State<AddSecondCharacterPage> createState() => _AddMainCharacterPageState();
}

class _AddMainCharacterPageState extends State<AddSecondCharacterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? name;
  String? gender;
  String? role;
  String? taste;

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
          ),
        ),
        elevation: 10,
      ),

       body:
       Container( decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sfondo.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
  key: _formKey,
  child: Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Name',
            fillColor: Colors.grey,
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
              fillColor: Colors.grey,
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
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Taste',
              fillColor: Colors.grey,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: <String>['Marvel', 'Disney', 'Hogwarts', 'Star Wars', 'Others'].map((String value) {
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
                taste = newValue;
              });
            },
            onSaved: (String? value) {
              taste = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Role',
              fillColor: Colors.grey,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: <String>['Grandparent', 'Parent', 'Sibling', 'Friend', 'Other'].map((String value) {
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
                role = newValue;
              });
            },
            onSaved: (String? value) {
              role = value;
            },
          ),
        ),
ElevatedButton(
  child: const Text('Save'),
  onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      saveData();
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

    ],
    
  ),
  
      ),
    ),
    ),
    );
  }
  void saveData() async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  await _firestore.collection('second_characters').add({
    'userId': userId,
    'name': name,
    'gender': gender,
    'role': role,
    'taste': taste,
  });
}
}