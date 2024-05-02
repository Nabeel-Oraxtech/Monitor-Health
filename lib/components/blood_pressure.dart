import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BloodPressureChart extends StatelessWidget {
  const BloodPressureChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Blood Pressure Tracking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.white,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                    left: BorderSide(
                      color: Colors.grey,
                    ),
                    right: BorderSide(
                      color: Colors.transparent,
                    ),
                    top: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 5),
                      FlSpot(2, 20),
                      FlSpot(3, 50),
                      FlSpot(4, 45),
                      FlSpot(5, 60),
                    ],
                    isCurved: true,
                    colors: [Colors.blue],
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 5),
                      FlSpot(2, 30),
                      FlSpot(3, 45),
                      FlSpot(4, 65),
                      FlSpot(5, 70),
                    ],
                    isCurved: true,
                    colors: [Colors.red],
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                ],
                minY: 0,
                maxY: 100,
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      ],
    );
  }
}
