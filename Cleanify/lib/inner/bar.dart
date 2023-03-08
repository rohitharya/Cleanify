import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sortapp/model/collecm1.dart';

class SubscriberChart extends StatelessWidget {
  final List<Subchart> data;
  var msg;
  SubscriberChart({required this.data, required this.msg});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Subchart, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (Subchart series, _) => series.name,
          measureFn: (Subchart series, _) => series.value,
          colorFn: (Subchart series, _) => series.color)
    ];
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(msg),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
