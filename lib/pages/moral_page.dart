import 'package:dreamy_tales/pages/story_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoralChoice extends StatefulWidget {
  const MoralChoice({Key? key}) : super(key: key);

  @override
  State<MoralChoice> createState() => _MoralChoiceState();
}

class _MoralChoiceState extends State<MoralChoice> {
  int? selectedCardIndex;
  List<Map<String, String>> morals = [
    {'title': 'Kindness Matters:', 'description': 'Treat others the way you want to be treated. Kindness makes the world a better place. 🌍❤️'},
    {'title': 'Never Give Up:', 'description': 'Even when things are tough, keep trying. Perseverance leads to success. 🌈👊'},
    {'title': 'Sharing is Caring:', 'description': 'Sharing with others shows you care. It makes everyone happy. 🤝😊'},
    {'title': 'Honesty:', 'description': 'Always tell the truth. Honesty builds trust and strong friendships. 🤞🗣️'},
    {'title': 'Be Grateful:', 'description': 'Appreciate what you have. Gratitude brings joy into your life. 🙏😊'},
    {'title': 'Teamwork Works:','description': 'Working together with others achieves more than working alone. 🤝🚀'},
    {'title': 'Respect Differences:','description': 'Everyone is unique. Respect and celebrate differences. It makes the world colorful. 🌈🤝'},
    {'title': 'Forgive and Forget:','description': 'Forgiving others is a gift to yourself. Let go of grudges and move forward with a happy heart. 🎁❤️'},
    {'title': 'Be Responsible:', 'description': "Take responsibility for your actions. It's a sign of maturity and builds trust. ⚖️👍"},
    {'title': 'Believe in Yourself:', 'description': 'You are capable of amazing things. Believe in yourself, and others will too. 🌟🙌'}
  ];
  String? selectedMoral;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moral Choice'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sfondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: morals.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('moralPreference', morals[index]['title']!);
                setState(() {
                  selectedMoral = morals[index]['title'];
                  selectedCardIndex = index;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You selected ${morals[index]['title']}')),
                );
              },
              child: Card(
                color: Colors.black.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: selectedCardIndex == index ? Colors.deepPurple : Colors.transparent,
                      width: 5.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        morals[index]['title']!,
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color:Colors.amber),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        morals[index]['description']!,
                        style: TextStyle(fontSize: 12.0,color:Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      )
      ),
      floatingActionButton: selectedMoral != null ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoryPage(moral: selectedMoral!)),
          );
        },
        label: const Text('Confirm'),
        backgroundColor: Colors.deepPurple,
      ) : null,
    );
  }
}