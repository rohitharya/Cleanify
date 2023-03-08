import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sortapp/inner/bar.dart';
import 'package:sortapp/model/collecm1.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisplayBar extends StatefulWidget {
  String email;
  DisplayBar({required this.email});

  @override
  _DisplayBarState createState() => _DisplayBarState();
}

class _DisplayBarState extends State<DisplayBar> {
  List<Subchart> mode = [];
  var electrical = 0;
  var recycle = 0;
  var organic = 0;
  var counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
  }

  _getdata() async {
    await FirebaseFirestore.instance
        .collection("collector")
        .doc(widget.email)
        .get()
        .then((doc) {
      var s1 = doc.data();
      s1!['members'].forEach((element) {
        FirebaseFirestore.instance
            .collection("disposer")
            .doc(element)
            .get()
            .then((d1) {
          var temp1 = d1.data();
          setState(() {
            this.organic = this.organic + temp1!['ORGANIC WASTE'] as int;
            this.recycle = this.recycle + temp1['RECYCLABLE WASTE'] as int;
            this.electrical =
                this.electrical + temp1['ELECTRICAL WASTE'] as int;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: SubscriberChart(data: [
        Subchart(
            color: charts.ColorUtil.fromDartColor(Colors.green),
            name: "Organic Waste",
            value: organic),
        Subchart(
            color: charts.ColorUtil.fromDartColor(Colors.orange),
            name: "Recyclable Waste",
            value: recycle),
        Subchart(
            color: charts.ColorUtil.fromDartColor(Colors.red),
            name: "Electrical Waste",
            value: electrical),
      ], msg: "OverAll Disposal")),
    );
  }
}
