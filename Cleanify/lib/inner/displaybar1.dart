import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sortapp/inner/bar.dart';
import 'package:sortapp/model/collecm1.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DisplayBar1 extends StatefulWidget {
  String email;
  DisplayBar1({required this.email});

  @override
  _DisplayBar1State createState() => _DisplayBar1State();
}

class _DisplayBar1State extends State<DisplayBar1> {
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
    FirebaseFirestore.instance
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
          var x = d1.data();
          var now = new DateTime.now();
          var formatter = new DateFormat('yyyy-MM-dd');
          String formattedDate = formatter.format(now);
          FirebaseFirestore.instance
              .collection("disposer")
              .doc(element)
              .collection("wastes")
              .doc(formattedDate)
              .get()
              .then((doc) {
            if (doc.exists) {
              setState(() {
                var temp1 = doc.data();
                organic = organic + temp1!['ORGANIC WASTE'] as int;
                recycle = recycle + temp1['RECYCLABLE WASTE'] as int;
                electrical = electrical + temp1['ELECTRICAL WASTE'] as int;
              });
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: SubscriberChart(
        data: [
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
        ],
        msg: "Today's Area Disposal",
      )),
    );
  }
}
