import 'package:flutter/material.dart';
import 'package:sortapp/over/pie1.dart';
import 'package:sortapp/over/pie.dart';

class ov1 extends StatefulWidget {
  String email;
  String name;
  ov1({required this.email, required this.name});
  @override
  _ov1State createState() => _ov1State();
}

class _ov1State extends State<ov1> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff5ebcd6),
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              widget.name.toUpperCase(),
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
