import 'package:flutter/material.dart';
import 'package:monitor_health/components/blood_pressure.dart';
import 'package:monitor_health/components/spo2.dart';
import 'package:monitor_health/components/weight.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vitals Tracking')),
      body: Column(
        children: [
          // First portion
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: const Center(
                child: BloodPressureChart(),
              ),
            ),
          ),
          // Second portion
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Center(
                child: StackedHorizontalBarChart.withSampleData(),
              ),
            ),
          ),
          // Third portion
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Center(
                child: StackedVerticalBarChart.withSampleData(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
