import 'package:flutter/material.dart';

class GaugeCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final IconData icon;

  const GaugeCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: SizedBox(
        width: 250,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const Spacer(),

              // Tähän tulee myöhemmin varsinainen mittari
              const Placeholder(
                fallbackHeight: 120,
                fallbackWidth: 120,
              ),


              const Spacer(),

              Text(
                "$value $unit",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          )
        )
      )
    );
  }  
}  