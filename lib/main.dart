import 'dart:async';
import 'dart:convert';
import 'dart:ui';

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
        Uri.parse("http://$arduinoIp/data"),
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,

      
      // Yläpalkki
    

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 12,
              sigmaY: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF245B2A).withValues(alpha: 0.72),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,

                title: const Text(
                  "Kompostintarkkailujärjestelmä",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),


      body: Stack(
        children: [

          // Taustakuva
          Positioned.fill(
            child: Image.asset(
              "assets/tausta2.jpg",
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
          ),

          // Kevyt tumma kerros taustakuvan päällä.
        
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.22),
                  ],
                ),
              ),
            ),
          ),

          // SISÄLTÖ
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                78,
                20,
                20,
              ),
              child: Column(
                children: [

                  
                  // Yhteystila Arduinon kanssa
                  

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: connected
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: connected
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          connected
                              ? "Yhteys Arduinoon muodostettu"
                              : "Ei yhteyttä Arduinoon",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  
                  // Mittarit
                  

                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [

                          // GaugeCardia ei muutettu
                          GaugeCard(
                            title: "Lämpötila",
                            value: temperature,
                            unit: "°C",
                            icon: Icons.thermostat,
                            gaugeColor: Colors.red,
                          ),

                          // GaugeCardia ei muutettu
                          GaugeCard(
                            title: "Kosteus",
                            value: humidity,
                            unit: "%",
                            icon: Icons.water_drop,
                            gaugeColor: Colors.blue,
                          ),

                          // GaugeCardia ei muutettu
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

                  // KOMPOSTIN TILA
                  

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.48),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Icon(
                          Icons.eco_rounded,
                          size: 18,
                          color: getCompostColor(),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          getCompostStatus(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: getCompostColor(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  
                  // Päivitä nappi sivun alareunassa
                  

                  ElevatedButton.icon(
                    onPressed: loadSensorData,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 17,
                    ),
                    label: const Text(
                      "Päivitä mittaukset",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF2E7D32).withValues(alpha: 0.92),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black.withValues(alpha: 0.35),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 19,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
