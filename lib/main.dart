import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'widgets/gauge_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kompostintarkkailujärjestelmä',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Vaihda tähän Arduinon IP-osoite
  static const String arduinoIp = "-";

  double temperature = 0;
  double humidity = 0;
  double compost = 0;

  bool connected = false;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    loadSensorData();

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => loadSensorData(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
/// Lataa anturidata Arduinolta ja päivittää tilan.
  Future<void> loadSensorData() async {
    try {
      final response = await http.get(
        Uri.parse("http://$arduinoIp/data"), // Tähän ei tarvitse koskea!
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          temperature = (data["temperature"] as num).toDouble();
          humidity = (data["humidity"] as num).toDouble();
          compost = (data["compost"] as num).toDouble();

          connected = true;
        });
      }
    } catch (e) {
      setState(() {
        connected = false;
      });
    }
  }
/// Palauttaa kompostin tilan värin lämpötilan ja kosteuden perusteella.
  Color getCompostColor() {
    if (temperature < 30) {
      return Colors.red;
    }

    if (humidity < 50) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String getCompostStatus() {
    if (temperature < 30) {
      return "Komposti liian kylmä";
    }

    if (humidity < 50) {
      return "Lisää kosteutta";
    }

    return "Kompostoituminen käynnissä";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Kompostintarkkailujärjestelmä"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/tausta.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                connected
                    ? "Yhteys Arduinoon muodostettu"
                    : "Ei yhteyttä Arduinoon",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: connected ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      GaugeCard(
                        title: "Lämpötila",
                        value: temperature,
                        unit: "°C",
                        icon: Icons.thermostat,
                        gaugeColor: Colors.red,
                      ),
                      GaugeCard(
                        title: "Kosteus",
                        value: humidity,
                        unit: "%",
                        icon: Icons.water_drop,
                        gaugeColor: Colors.blue,
                      ),
                      GaugeCard(
                        title: "Kompostoituminen",
                        value: compost,
                        unit: "%",
                        icon: Icons.eco,
                        gaugeColor: getCompostColor(),
                      ),
                    ],
                  ),  
                ),
              ),

              const SizedBox(height: 20),

              Text(
                getCompostStatus(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: getCompostColor(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: loadSensorData,
                icon: const Icon(Icons.refresh),
                label: const Text("Päivitä mittaukset"),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
