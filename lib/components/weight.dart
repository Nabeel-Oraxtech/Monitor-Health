import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StackedHorizontalBarChart extends StatelessWidget {
  final List<charts.Series<Weight, String>> seriesList;
  final bool animate;

  const StackedHorizontalBarChart(this.seriesList,
      {super.key, required this.animate});

  factory StackedHorizontalBarChart.withSampleData() {
    return StackedHorizontalBarChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Weight Tracking',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: charts.BarChart(
            seriesList,
            animate: animate,
            barGroupingType: charts.BarGroupingType.stacked,
            vertical: false,
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
    );
  }

  static List<charts.Series<Weight, String>> _createSampleData() {
    final weightData = [
      Weight('March', 20),
      Weight('February', 30),
      Weight('January', 40),
      Weight('December', 30),
    ];

    return [
      charts.Series<Weight, String>(
        id: 'Weight',
        domainFn: (Weight kg, _) => kg.month,
        measureFn: (Weight number, _) => number.percentage,
        data: weightData,
      ),
    ];
  }
}

class Weight {
  final String month;
  final int percentage;

  Weight(this.month, this.percentage);
}
