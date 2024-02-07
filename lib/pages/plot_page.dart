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
    {'image': 'assets/cappuccettorosso.jpg', 'description': 'Little Red Riding Hood', 'trama': 'Little Red Riding Hood sets off through the forest to visit her grandmother, carrying a basket of goodies. Along the way, she encounters a charming but cunning wolf who tricks her into revealing her destination. The wolf races ahead, devours the grandmother, and disguises himself in her clothing. Little Red arrives at the cottage, unaware of the danger, and narrowly escapes the wolfs clutches with the help of a passing woodcutter.'},
    {'image': 'assets/bellaaddormentata.jpg', 'description': 'Sleeping Beauty', 'trama': 'Sleeping Beauty is a classic fairy tale about a princess who is cursed to sleep for a hundred years by an evil fairy, where she would be awakened by a handsome prince.'},
    {'image': 'assets/cenerentola.jpg', 'description': 'Cinderella', 'trama': 'Cinderella, mistreated by her stepfamily, dreams of attending the royal ball. With her fairy godmothers magic, she enchants the prince but must flee before midnight, leaving behind a glass slipper. The prince searches for her, and when the slipper fits Cinderella, they find their happily ever after.'},
    {'image': 'assets/treporcellini.jpg', 'description': 'The Three Little Pigs', 'trama': 'The Three Little Pigs is a fable about three pigs who build three houses of different materials. A Big Bad Wolf blows down the first two pigs houses, made of straw and sticks respectively, but is unable to destroy the third pigs house, made of bricks.'},

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
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                plots
                                    .firstWhere((element) =>
                                        element['description'] == selectedPlot)
                                    ['trama']!,
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
                            'Select a plot',
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
          childAspectRatio: MediaQuery.of(context).orientation == Orientation.portrait
              ? 1.5
              : 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
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
        SnackBar(content: Text('You selected ${plots[index]['description']}')),
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