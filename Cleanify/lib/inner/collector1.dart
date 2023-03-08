import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sortapp/drawer/menu1.dart';
import 'package:sortapp/inner/ov1.dart';
import 'package:sortapp/inner/ov2.dart';
import 'package:sortapp/main.dart';
import 'package:intl/intl.dart';
import 'package:transition/transition.dart';

class Collector1 extends StatefulWidget {
  String email;

  Collector1({required this.email});

  @override
  _Collector1State createState() => _Collector1State();
}

class _Collector1State extends State<Collector1> {
  List<Tale> mode = [];
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
              Tale temp = Tale(
                  email: x!['mail'],
                  name: x['name'],
                  photo: x['photo'],
                  color: Colors.green,
                  present: 1);
              setState(() {
                mode.add(temp);
              });
            } else {
              Tale temp = Tale(
                  email: x!['mail'],
                  name: x['name'],
                  photo: x['photo'],
                  color: Colors.red,
                  present: 0);
              setState(() {
                mode.add(temp);
              });
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuBar1(email: widget.email),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Text("DISPOSAL STATUS"),
          backgroundColor: Color(0xff5ebcd6),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(
                          context,
                          Transition(
                              child: StartPage(),
                              transitionEffect:
                                  TransitionEffect.LEFT_TO_RIGHT)));
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
        ),
      ),
      body: (mode != null)
          ? Container(
              child: ListView.builder(
              itemCount: mode.length,
              itemBuilder: (BuildContext context, index) => GestureDetector(
                onTap: () {
                  if (mode[index].present == 1) {
                    Navigator.push(
                        context,
                        Transition(
                            child: ov1(
                                email: mode[index].email,
                                name: mode[index].name),
                            transitionEffect: TransitionEffect.FADE));
                  } else {
                    Navigator.push(
                        context,
                        Transition(
                            child: ov2(
                                email: mode[index].email,
                                name: mode[index].name),
                            transitionEffect: TransitionEffect.FADE));
                  }
                },
                child: Container(
                  child: new Column(
                    children: <Widget>[
                      if (index != 0)
                        Divider(
                          thickness: 0.5,
                        ),
                      ListTile(
                        leading: Container(
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(mode[index].photo),
                          ),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              mode[index].name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xff4d4d4d),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              mode[index].email,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: Colors.black),
                            )),
                        trailing: CircleAvatar(
                          child: Container(
                            height: 15,
                          ),
                          backgroundColor: mode[index].color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class Tale {
  String name;
  String email;
  String photo;
  Color color;
  int present;
  Tale(
      {required this.email,
      required this.name,
      required this.photo,
      required this.color,
      required this.present});
}
