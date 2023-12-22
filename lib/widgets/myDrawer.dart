
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/app_category.dart';

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

              ),
              child: DrawerHeader(
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
                child: FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SharedPreferences> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      String? email = FirebaseAuth.instance.currentUser!.email;;
                      return RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Welcome back!\n\n',
                            ),
                            TextSpan(
                              text: (email ?? 'Guest'),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.amber,
                              ),
                            ),

                          ],
                        ),
                      );

                    } else {
                      return const CircularProgressIndicator(); // mostra un indicatore di caricamento mentre attende
                    }
                  },
                ),
              ),
            ),
            _buildDrawerButton('Home', AppCategory.home, Icons.home),
            _buildDrawerButton(
                'My Stories', AppCategory.myStories, FontAwesomeIcons.book),
            _buildDrawerButton(
                'Analytics', AppCategory.analytics, FontAwesomeIcons.chartBar),
            _buildDrawerButton(
                'Settings', AppCategory.settings, FontAwesomeIcons.gear),
            _buildDrawerButton('EXIT', AppCategory.logout, Icons.exit_to_app,
                onPressed: onExit),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerButton(String title, AppCategory category, IconData icon,
      {void Function()? onPressed}) {
    final isSelected = currentCategory == category;
    final tileColor =
    isSelected ? Colors.deepPurple.withOpacity(0.4) : Colors.transparent;

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
                color: isSelected ? Colors.white : Colors.amber,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.amber,
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