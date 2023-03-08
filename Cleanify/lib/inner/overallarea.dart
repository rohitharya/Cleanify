import 'package:flutter/material.dart';
import 'package:sortapp/drawer/menu1.dart';
import 'package:sortapp/inner/displaybar.dart';
import 'package:sortapp/inner/displaybar1.dart';

class OverallArea extends StatefulWidget {
  String email;
  OverallArea({required this.email});
  @override
  _OverallAreaState createState() => _OverallAreaState();
}

class _OverallAreaState extends State<OverallArea> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MenuBar1(email: widget.email),
        appBar: AppBar(
          backgroundColor: Color(0xff5ebcd6),
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'AREA DISPOSAL',
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
          DisplayBar(email: widget.email),
          DisplayBar1(email: widget.email),
        ]),
      ),
    );
  }
}
