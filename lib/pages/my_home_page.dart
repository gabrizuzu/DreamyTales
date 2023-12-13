import 'package:dreamy_tales/pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:dreamy_tales/pages/analitics_page.dart';
import 'package:dreamy_tales/pages/myStories.dart';
import 'package:dreamy_tales/pages/settings_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'app_category.dart';
import 'package:dreamy_tales/auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AppCategory _currentCategory = AppCategory.home;

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  Future<void> signOut() async {
    await Auth().signOut();
  }
  void _exitApp() {
    Navigator.pop(context); // Chiudi il Drawer
    signOut();
    _logout();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _changeCategory(AppCategory category) {
    setState(() {
      _currentCategory = category;
    });
    Navigator.pop(context); // Chiudi il Drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Comic Sans MS',
          ),
        ),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      drawer: MyDrawer(
        currentCategory: _currentCategory,
        onCategorySelected: _changeCategory,
        onLogout: _logout,
        onExit: _exitApp,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentCategory) {
      case AppCategory.home:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text('$_counter', style: Theme.of(context).textTheme.headline6),
            ],
          ),
        );
      case AppCategory.myStories:
        return MyStories();
      case AppCategory.analytics:
        return Analytics();
      case AppCategory.settings:
        return SettingsScreen();
      default:
        return Container();
    }
  }
}

class MyDrawer extends StatelessWidget {
  final AppCategory currentCategory;
  final void Function(AppCategory) onCategorySelected;
  final void Function() onLogout;
  final void Function() onExit;

  MyDrawer({
    required this.currentCategory,
    required this.onCategorySelected,
    required this.onLogout,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.withOpacity(0.9),
              Colors.deepPurple.withOpacity(0.7),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.withOpacity(0.9),
                    Colors.deepPurple.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                'Bentornato !',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerButton('Home', AppCategory.home, Icons.home),
            _buildDrawerButton('My Stories', AppCategory.myStories, FontAwesomeIcons.book),
            _buildDrawerButton('Analytics', AppCategory.analytics, FontAwesomeIcons.chartBar),
            _buildDrawerButton('Settings', AppCategory.settings, FontAwesomeIcons.gear),
            _buildDrawerButton('EXIT', AppCategory.logout, Icons.exit_to_app, onPressed: onExit),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(String title, AppCategory category, IconData icon, {void Function()? onPressed}) {
    final isSelected = currentCategory == category;
    final tileColor = isSelected ? Colors.deepPurple.withOpacity(0.4) : Colors.transparent;

    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        } else {
          onCategorySelected(category);
        }
      },
      child: Container(
        color: tileColor,
        child: ListTile(
          title: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.deepPurple,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.deepPurple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
