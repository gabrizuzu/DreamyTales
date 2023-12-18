import 'package:flutter/material.dart';

class Analytics extends StatelessWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sfondo.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Numero totale di storie lette:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                '25', // Sostituire con il dato dinamico
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              SizedBox(height: 24),
              Text(
                'Tempo medio di lettura:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                '10 minuti', // Sostituire con il dato dinamico
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
              SizedBox(height: 24),
              Text(
                'Storie preferite:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Storia A, Storia B, Storia Cccccccccc', // Sostituire con il dato dinamico
                style: TextStyle(fontSize: 30, color: Colors.orange),
              ),
              SizedBox(height: 24),
              // Aggiungi altri dati e grafici come necessario...
            ],
          ),
        ),
      ),
    );
  }
}
