import 'package:flutter/material.dart';

class AddMainCharacterPage extends StatefulWidget {
  const AddMainCharacterPage({Key? key}) : super(key: key);

  @override
  State<AddMainCharacterPage> createState() => _AddMainCharacterPageState();
}

class _AddMainCharacterPageState extends State<AddMainCharacterPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? gender;
  double age = 0;
  String? tastes;

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
              labelText: 'Tastes',
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
                style: TextStyle(
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
        ElevatedButton(
        child: Text('Save'),
        onPressed: () {

            // Salva i dati nel database o in un'altra posizione

            // Ritorna alla pagina my_home_page.dart
            Navigator.pop(context);
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