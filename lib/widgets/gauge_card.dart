import 'dart:ui';

import 'package:flutter/material.dart';

class GaugeCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final IconData icon;
  final Color gaugeColor;

  const GaugeCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.gaugeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 8,
          sigmaY: 8,
        ),
        child: Container(
          width: 250,
          height: 300,
          decoration: BoxDecoration(
            // Hieman läpikuultava valkoinen "lasipinta"
            color: Colors.white.withValues(alpha: 0.72),

            borderRadius: BorderRadius.circular(18),

            // Hieno vaalea lasireunus
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1.2,
            ),

            // Pehmeä varjo
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: gaugeColor,
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: gaugeColor,
                      width: 5,
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  "$value $unit",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}