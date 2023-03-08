import 'package:charts_flutter/flutter.dart' as charts;

class Subchart {
  final String name;
  final int value;
  final charts.Color color;

  Subchart({required this.color, required this.name, required this.value});
}
