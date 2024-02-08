import 'package:dreamy_tales/widgets/moral_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class PlotChoice extends StatefulWidget {
  const PlotChoice({super.key});

  @override
  State<PlotChoice> createState() => _PlotChoiceState();
}

class _PlotChoiceState extends State<PlotChoice> {
  List<Map<String, String>> plots = [
    {
      'image': 'assets/cappuccettorosso.jpg',
      'description': 'Little Red Riding Hood',
      'trama':
          'Little Red Riding Hood sets out to visit her grandmother. Along the way, she encounters a cunning wolf who tricks her and devours her grandmother. Little Red Riding Hood outsmarts the wolf with the help of a woodcutter, saving her grandmother and learning to be cautious of strangers.',
    },
    {
      'image': 'assets/bellaaddormentata.jpg',
      'description': 'Sleeping Beauty',
      'trama':
          'A wicked fairy curses a princess to die on her 16th birthday. A good fairy softens the curse, so the princess will fall into a deep sleep instead. The princess is awakened by a prince and they live happily ever after.'
    },
    {
      'image': 'assets/cenerentola.jpg',
      'description': 'Cinderella',
      'trama':
          'Cinderella is mistreated by her stepmother and stepsisters. With the help of her fairy godmother, she attends a royal ball and meets the prince. The prince searches for her with a glass slipper, and they live happily ever after.'
    },
    {
      'image': 'assets/treporcellini.jpg',
      'description': 'The Three Little Pigs',
      'trama':
          'Three pigs build houses out of different materials. The first two pigs are eaten by a wolf, but the third pig outsmarts the wolf and lives happily ever after.'
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
                                padding: const EdgeInsets.all(6.0),
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
                    ? 1.3
                    : 1, 
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
