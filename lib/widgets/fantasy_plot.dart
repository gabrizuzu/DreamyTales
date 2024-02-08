import 'package:dreamy_tales/widgets/moral_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class FantasyPlotPage extends StatefulWidget {
  const FantasyPlotPage({super.key});

  @override
  State<FantasyPlotPage> createState() => _PlotChoiceState();
}

class _PlotChoiceState extends State<FantasyPlotPage> {
  List<Map<String, String>> plots = [
    {
      'image': 'assets/starWars.jpg',
      'description': 'Star Wars',
      'trama':
          'Star Wars is an American epic space opera media franchise created by George Lucas, which began with the eponymous 1977 film and quickly became a worldwide pop-culture phenomenon.'
    },
    {
      'image': 'assets/hogwarts.jpg',
      'description': 'Hogwarts',
      'trama':
          'Hogwarts School of Witchcraft and Wizardry is a fictional British boarding school of magic for students aged eleven to eighteen, and is the primary setting for the first six books in J.K. Rowling\'s Harry Potter series.'
    },
    {
      'image': 'assets/marvel.jpg',
      'description': 'Marvel',
      'trama':
          'Marvel Comics is the brand name and primary imprint of Marvel Worldwide Inc., formerly Marvel Publishing, Inc. and Marvel Comics Group, a publisher of American comic books and related media.'
    },
    {
      'image': 'assets/disney.jpg',
      'description': 'Disney',
      'trama':
          'The Walt Disney Company, commonly known as Disney, is an American diversified multinational mass media and entertainment conglomerate headquartered at the Walt Disney Studios complex in Burbank, California.'
    },
  ];
  String? selectedPlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: const Key('plotChoiceAppBar'),
        title: const Text('Fantasy Plot Choice'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Device.get().isTablet
          ? // Layout per iPad
          Row(
              children: [
                Expanded(
                  child: buildGridView(context),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    child: selectedPlot != null
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  selectedPlot!,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  plots.firstWhere((element) =>
                                      element['description'] ==
                                      selectedPlot)['trama']!,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: Text(
                              'Seleziona una trama',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            )
          : // Layout per iPhone
          buildGridView(context),
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

  Widget buildGridView(BuildContext context) {
    return Container(
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
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1.5
                    : MediaQuery.of(context).size.width / MediaQuery.of(context).size.height, // Aspect Ratio per l'orientamento orizzontale
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          itemCount: plots.length,
          itemBuilder: (context, index) {
            return buildPlotCard(context, index);
          },
        ),
      ),
    );
  }

  Widget buildPlotCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('plotPreference', plots[index]['description']!);
        setState(() {
          selectedPlot = plots[index]['description'];
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('You selected ${plots[index]['description']}')),
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
              height: MediaQuery.of(context).orientation == Orientation.portrait
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
  }
}
