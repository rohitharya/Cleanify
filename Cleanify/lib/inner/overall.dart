import 'package:flutter/material.dart';
import 'package:sortapp/drawer/menu.dart';
import 'package:sortapp/over/pie1.dart';
import 'package:sortapp/over/pie.dart';

class Overall extends StatefulWidget {
  String email;
  Overall({required this.email});
  @override
  _OverallState createState() => _OverallState();
}

class _OverallState extends State<Overall> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MenuBar(email: widget.email, c1: Color(0xff5ebcd6)),
        appBar: AppBar(
          backgroundColor: Color(0xff5ebcd6),
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'ANALYTICS',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Container(
                height: 30,
                child: Tab(
                  child: Text(
                    "OVERALL",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                height: 30,
                child: Tab(
                  child: Text(
                    "TODAY",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Pie(email: widget.email),
          Pie1(email: widget.email),
        ]),
      ),
    );
  }
}
