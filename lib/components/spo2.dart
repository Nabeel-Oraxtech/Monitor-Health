import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedVerticalBarChart extends StatelessWidget {
  final List<charts.Series<Weight, String>> seriesList;
  final bool animate;

  const StackedVerticalBarChart(this.seriesList,
      {super.key, required this.animate});

  factory StackedVerticalBarChart.withSampleData() {
    return StackedVerticalBarChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Set a fixed height or adjust as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'SPO2 Tracking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Change color to green
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: charts.BarChart(
              seriesList,
              animate: animate,
              barGroupingType: charts.BarGroupingType.stacked,
              vertical: true,
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: const charts.GridlineRendererSpec(
                  labelAnchor: charts.TickLabelAnchor.after,
                  labelJustification: charts.TickLabelJustification.inside,
                ),
                tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                  desiredTickCount: 5,
                ),
                tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                  (value) => '${(value!.toInt() * 1).toString()}%',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static List<charts.Series<Weight, String>> _createSampleData() {
    final weightData = [
      Weight('Numb1', 20),
      Weight('Numb2', 30),
      Weight('Numb3', 40),
      Weight('Numb4', 30),
    ];

    return [
      charts.Series<Weight, String>(
        id: 'Weight',
        domainFn: (Weight kg, _) => kg.month,
        measureFn: (Weight number, _) => number.percentage,
        data: weightData,
        colorFn: (_, __) =>
            charts.MaterialPalette.green.shadeDefault, // Change color to green
      ),
    ];
  }
}

class Weight {
  final String month;
  final int percentage;

  Weight(this.month, this.percentage);
}
