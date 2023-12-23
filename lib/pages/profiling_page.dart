import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChildProfilePage extends StatefulWidget {
  @override
  _ChildProfilePageState createState() => _ChildProfilePageState();
}

class _ChildProfilePageState extends State<ChildProfilePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Map<String, dynamic> profileData = {
    'name': '',
    'gender': '',
    'age': 0,
    'avatar': '',
  };

  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'What\'s your child\'s name?',
      'type': 'text',
      'key': 'name',
      'image': 'logo_profilazione.jpeg',
    },
    {
      'title': 'Select your child\'s gender',
      'type': 'radio',
      'key': 'gender',
      'options': [
        {'label': 'Male', 'image': 'male.png'},
        {'label': 'Female', 'image': 'female.png'},
        // Add more options if needed
      ],
    },
    {
      'title': 'How old is your child?',
      'type': 'numeric',
      'key': 'age',
      'image': 'logo_profilazione.jpeg',
    },
    {
      'title': 'Select your Avatar',
      'type': 'checkbox',
      'key': 'avatar',
      'options': [
        {'label': 'Hero 1', 'image': 'assets/avatar_F3.png'},
        {'label': 'Hero 2', 'image': 'assets/avatar_M4.png'},
        {'label': 'Hero 3', 'image': 'assets/avatar_M8.png'},
        {'label': 'Hero 4', 'image': 'assets/avatar_F1.png'},
        // Add more options if needed
      ],
    },
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: profileOptions.length,
            itemBuilder: (context, index) {
              return buildProfileSlide(context, profileOptions[index]);
            },
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
          ),

          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          Positioned(
            bottom: 40.0,
            left: 16.0,
            right: 16.0, // Imposta il margine destro
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Allineato spazialmente tra gli elementi
              children: [
                if (_currentPage > 0 && _currentPage != 0)
                  IconButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.amber,
                  ),
                  if (_currentPage == 0)
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.amber,
                        ),
                      ),
                    ),
                if (_currentPage < profileOptions.length - 1 && _currentPage != 0)
                  IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.amber,
                  ),
                if (_currentPage == profileOptions.length - 1)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        saveProfileData();
                        // Puoi navigare a una nuova pagina o fare altre operazioni qui
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.amber,
                      ),
                      child: const Text("Save"),
                    ),
                  ),
              ],
            ),
          ),






        ],
      ),
    );
  }

  Widget buildProfileSlide(BuildContext context, Map<String, dynamic> option) {

    return Container(
      //color: Colors.amber,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/cornice_1.png'),
          fit: BoxFit.fill,
        ),

      ),

      child: Padding(
        padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
            top: 0.0,
            bottom: 0.0    ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 5),
              

              child: Image.asset('assets/logo_profilazione.jpeg', width: 100, height: 100),
              
            ),
            if (option['type'] == 'text')

              TextField(
                controller: option['key'] == 'name' ? nameController : ageController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  setState(() {
                    profileData[option['key']] = value;
                  });
                },
                onSubmitted: (value) {
                  // Conferma l'input e passa alla pagina successiva
                  _pageController.nextPage(
                    duration:const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                decoration: InputDecoration(
                  labelText: option['title'],
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.5),
                ),
              ),
            if (option['type'] == 'numeric')
              TextField(
                controller : ageController,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    profileData[option['key']] = int.tryParse(value) ?? 0;
                  });
                },
                onSubmitted: (value) {
                // Conferma l'input e passa alla pagina successiva
                  _pageController.nextPage(
                  duration:const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  );
                },
                decoration: InputDecoration(
                  labelText: option['title'],
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                ),
              ),
            if (option['type'] == 'radio')
              Column(
                children: (option['options'] as List<Map<String, dynamic>>).map((genderOption) {
                  bool isSelected = profileData[option['key']] == genderOption['label'];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            profileData[option['key']] = genderOption['label'];
                          });
                              _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.deepPurple : Colors.transparent,
                              width: 4.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/${genderOption['image']}',
                                width: 100,
                                height: 100,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                genderOption['label'],
                                style: TextStyle(
                                  color: isSelected ? Colors.deepPurple : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),

            if (option['type'] == 'checkbox')
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: (option['options'] as List<Map<String, dynamic>>).map((avatarOption) {
                  bool isSelected = profileData[option['key']].contains(avatarOption['image']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        profileData[option['key']] = avatarOption['image'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple : Colors.transparent,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(isSelected ? 20.0 : 20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            '${avatarOption['image']}',
                            width: 90,
                            height: 90,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              avatarOption['label'],
                              style: TextStyle(
                                color: isSelected ? Colors.deepPurple : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < profileOptions.length; i++) {
      indicators.add(_buildPageIndicatorItem(i == _currentPage));
    }
    return indicators;
  }

  Widget _buildPageIndicatorItem(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.amber : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  void saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', profileData['name']);
    prefs.setString('gender', profileData['gender']);
    prefs.setInt('age', profileData['age']);
    prefs.setString('avatar', profileData['avatar']);

    final firestore = FirebaseFirestore.instance;
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    await firestore.collection('characters').add({
      'userId': userId,
      'name': profileData['name'],
      'gender': profileData['gender'],
      'age': profileData['age'],
      'avatar': profileData['avatar'],
    });
   
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ),
    );
  }

}
