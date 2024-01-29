// tutorial_screen_state.dart

import 'package:dreamy_tales/pages/tutorial_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/app_large_text.dart';
import '../widgets/app_text.dart';
import 'login_register_page.dart';

class TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  int get currentPage => _currentPage;

  List images = [
    'welcome1.jpg',
    'welcome2.jpg',
    'welcome3.jpg',
  ];
  List largetext = [
    'Dreamy Tales',
    'Original Stories',
    "Educational",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Stack(
        children: [
          PageView.builder(
            physics: const ClampingScrollPhysics(),
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
                if (_currentPage > 0 && _currentPage != 0)
                  IconButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                if (_currentPage == 0)
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (_currentPage < images.length - 1 && _currentPage != 0)
                  IconButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    color: Colors.white,
                  ),
                if (_currentPage == images.length - 1)
                  ElevatedButton(
                    key: const Key('beginButton'),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/' + images[index]),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/cornice_1.png',
            fit: BoxFit.fill,
            colorBlendMode: BlendMode.overlay,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppLargeText(
                    text: largetext[index], size: 40, color: Colors.white),
                AppText(text: text[index], size: 20, color: Colors.white54),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      description[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < images.length; i++) {
      indicators.add(_buildPageIndicatorItem(i == _currentPage, i));
    }
    return indicators;
  }

  Widget _buildPageIndicatorItem(bool isActive, int index) {
    return Container(
      key: Key('pageIndicator_$index'),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.amber : Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}
