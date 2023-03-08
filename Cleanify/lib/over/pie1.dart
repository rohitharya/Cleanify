import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class Pie1 extends StatefulWidget {
  String email;
  Pie1({required this.email});
  @override
  _Pie1State createState() => _Pie1State();
}

class _Pie1State extends State<Pie1> {
  var organic;
  var electrical;
  var recycle;
  final colorList = <Color>[
    Colors.red,
    Colors.green,
    Colors.orange,
  ];

  _genearte() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    FirebaseFirestore.instance
        .collection("disposer")
        .doc(widget.email)
        .collection("wastes")
        .doc(formattedDate)
        .get()
        .then((element) {
      var x = element.data();
      setState(() {
        this.electrical = x!['ELECTRICAL WASTE'];
        this.organic = x["ORGANIC WASTE"];
        this.recycle = x['RECYCLABLE WASTE'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    _genearte();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: (electrical != null)
            ? PieChart(
                dataMap: {
                  "Electrical Waste": this.electrical.toDouble(),
                  "Organic Waste": this.organic.toDouble(),
                  "Recyclable Waste": this.recycle.toDouble(),
                },
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2 > 300
                    ? 300
                    : MediaQuery.of(context).size.width / 1.2,
                colorList: this.colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: "TODAYS DISPOSAL",
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendPosition: LegendPosition.bottom,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        margin: EdgeInsets.symmetric(
          vertical: 32,
        ),
      )),
    );
  }
}
