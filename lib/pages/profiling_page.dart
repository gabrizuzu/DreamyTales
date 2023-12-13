import 'package:dreamy_tales/pages/my_home_page.dart';
import 'package:flutter/material.dart';

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
    'favoriteGenres': <String>[],
  };

  final List<Map<String, dynamic>> profileOptions = [
    {
      'title': 'What\'s your child\'s name?',
      'type': 'text',
      'key': 'name',
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
    },
    {
      'title': 'Select your child\'s favorite genres',
      'type': 'checkbox',
      'key': 'favoriteGenres',
      'options': [
        {'label': 'Marvel', 'image': 'marvel_personaggi.png'},
        {'label': 'Star Wars', 'image': 'starwars_logo.png'},
        {'label': 'Disney', 'image': 'disney_logo.png'},
        {'label': 'Harry Potter', 'image': 'harrypotter_logo.png'},
        // Add more options if needed
      ],
    },
  ];

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
            top: 40.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Dreamy Tales',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                ),
              ),
            ),
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
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  IconButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.deepPurple,
                  ),
                if (_currentPage < profileOptions.length - 1)
                  IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.deepPurple,
                  ),
                if (_currentPage == profileOptions.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      saveProfileData();
                      // Puoi navigare a una nuova pagina o fare altre operazioni qui
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    child: Text("Save"),
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/cornice_2.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (option['type'] == 'text')
              TextField(
                onChanged: (value) {
                  setState(() {
                    profileData[option['key']] = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: option['title'],
                ),
              ),
            if (option['type'] == 'numeric')
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    profileData[option['key']] = int.tryParse(value) ?? 0;
                  });
                },
                decoration: InputDecoration(
                  labelText: option['title'],
                ),
              ),
            if (option['type'] == 'radio')
              Column(
                children: (option['options'] as List<Map<String, dynamic>>).map((genderOption) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            profileData[option['key']] = genderOption['label'];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/${genderOption['image']}',
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 8),
                              Text(
                                genderOption['label'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            if (option['type'] == 'checkbox')
              Column(
                children: (option['options'] as List<Map<String, dynamic>>).map((genreOption) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (profileData[option['key']].contains(genreOption['label'])) {
                              profileData[option['key']].remove(genreOption['label']);
                            } else {
                              profileData[option['key']].add(genreOption['label']);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/${genreOption['image']}',
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 8),
                              Text(
                                genreOption['label'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
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
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  void saveProfileData() {
    print('Profile Data Saved: $profileData');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: 'Dreamy Tales'),
      ),
    );
  }

}
