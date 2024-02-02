import 'package:dreamy_tales/widgets/moral_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PlotChoice extends StatefulWidget {
  const PlotChoice({super.key});

  @override
  State<PlotChoice> createState() => _PlotChoiceState();
}

class _PlotChoiceState extends State<PlotChoice> {
  List<Map<String, String>> plots = [
    {
      'image': 'assets/cappuccettorosso.jpg',
      'description': 'Little Red Riding Hood'
    },
    {'image': 'assets/bellaaddormentata.jpg', 'description': 'Sleeping Beauty'},
    {'image': 'assets/cenerentola.jpg', 'description': 'Cinderella'},
    {
      'image': 'assets/treporcellini.jpg',
      'description': 'The Three Little Pigs'
    },
  ];
  String? selectedPlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('plotChoiceAppBar'),
        title: const Text('Classic Plot Choice'),
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
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio:
                    ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                        ? 3 / 2
                        : 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: plots.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString(
                        'plotPreference', plots[index]['description']!);
                    setState(() {
                      selectedPlot = plots[index]['description'];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'You selected ${plots[index]['description']}')),
                    );

                    // Nascondi la snack bar dopo 1 secondo
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    });
                  },
                  child: Column(
                    children: [
                      Card(
                        color: Colors.black.withOpacity(0.6),
                        child: Container(
                          height: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? MediaQuery.of(context).size.height * 0.2
                              : MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(plots[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: selectedPlot == plots[index]['description']
                                  ? Colors.deepPurple
                                  : Colors.transparent,
                              width: 5.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          plots[index]['description']!,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: selectedPlot == plots[index]['description']
                                ? Colors.deepPurple
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )),
      floatingActionButton: selectedPlot != null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoralChoice()),
                );
              },
              label: const Text('Confirm'),
              backgroundColor: Colors.deepPurple,
            )
          : null,
    );
  }
}
