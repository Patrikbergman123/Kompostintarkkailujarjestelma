import 'package:flutter/material.dart';
import 'widgets/gauge_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kompostintarkkailu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kompostintarkkailujärjestelmä"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              GaugeCard(
                title: "Lämpötila",
                value: 45.3,
                unit: "°C",
                icon: Icons.thermostat,
              ),
              GaugeCard(
                title: "Kosteus",
                value: 68,
                unit: "%",
                icon: Icons.water_drop,
              ),
              GaugeCard(
                title: "Kompostoituminen",
                value: 82,
                unit: "%",
                icon: Icons.eco,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
