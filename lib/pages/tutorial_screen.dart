import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_text.dart';
import 'login_register_page.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late SharedPreferences _prefs;

  List images = [
    'welcome1.jpg',
    'welcome2.jpg',
    'welcome3.jpg',
  ];
  List largetext = [
    'Dreamy Tales',
    'Original Stories',
    "Educational Purpose",
  ];
  List text = [
    "It's story time",
    "Unique stories for your kids",
    "Grow your kids' imagination",
  ];
  List description = [
    "Dreamy Tales is a platform where you can generate and read stories. You can also share your stories with your friends and family.",
    "You can generate your own original story by selecting the characters, setting, and plot.",
    "You can choose also a moral lesson to teach to your kids for each story",
  ];

  @override
  void initState() {
    super.initState();
    _checkIfFirstTime();
  }

  _checkIfFirstTime() async {
    _prefs = await SharedPreferences.getInstance();
    bool isFirstTime = _prefs.getBool('isFirstTime') ?? true;

    if (!isFirstTime) {
      // Se non è la prima volta, vai direttamente alla tua LoginPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  _setFirstTimeFlag() async {
    // Imposta il flag che indica che il tutorial è stato visto
    await _prefs.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return buildTutorialSlide(context, index);
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
                    color: Colors.white,
                  ),
                if (_currentPage < images.length - 1)
                  IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                    color: Colors.white,
                  ),
                if (_currentPage == images.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      // Imposta il flag che indica che il tutorial è stato visto
                      _setFirstTimeFlag();

                      // Vai alla tua LoginPage
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text("Let's Begin"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTutorialSlide(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('img/' + images[index]),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLargeText(text: largetext[index], size: 40, color: Colors.white),
            AppText(text: text[index], size: 30, color: Colors.white54),
            SizedBox(height: 20,),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: AppText(
                    text: description[index],
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < images.length; i++) {
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
        color: isActive ? Colors.amber : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
