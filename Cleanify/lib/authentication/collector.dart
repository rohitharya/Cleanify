import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortapp/splash/splash2.dart';

class CSignIn extends StatefulWidget {
  const CSignIn({Key? key}) : super(key: key);

  @override
  _CSignInState createState() => _CSignInState();
}

class _CSignInState extends State<CSignIn> {
  String email = "";
  String password = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  bool selected = false;
  Icon eye = Icon(Icons.visibility_off);
  List array = [
    'assets/images/collector2.jpg',
    'assets/images/collector1.jpg',
  ];
  int counter1 = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      email = '';
      password = '';
    });
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted)
        setState(() {
          if (counter1 < 100) {
            counter1 += 1;
          } else {
            counter1 = 0;
          }
        });
    });
  }

  myselection() {
    selected = !selected;
    if (selected == true) {
      setState(() {
        eye = Icon(Icons.visibility);
      });
    } else if (selected == false) {
      setState(() {
        eye = Icon(Icons.visibility_off);
      });
    }
  }

  Widget Mywidget() {
    return (counter1 % 2 == 0)
        ? Image.asset(
            array[1],
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          )
        : Image.asset(
            array[0],
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Collector's",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5ebcd6),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5ebcd6),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Login to your Collector account",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                child: Mywidget(),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value.trim();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    obscureText: !selected,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            myselection();
                          },
                          icon: eye),
                      hintText: 'Password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value.trim();
                      });
                    },
                  )),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: MaterialButton(
                        height: 60,
                        minWidth: 200,
                        child: Text(
                          "SIGN-IN",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        color: Color(0xff5ebcd6),
                        splashColor: Colors.lightBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('collector')
                              .doc(email)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) async {
                            if (documentSnapshot.exists) {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password)
                                    .then((_) => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => SplashScreen2(
                                            email: email,
                                          ),
                                        )));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  dis1(context, 'No user found for $email.');
                                } else if (e.code == 'wrong-password') {
                                  dis1(context,
                                      'Wrong password provided for the $email.');
                                }
                              }
                            } else {
                              dis1(context, 'No user found for $email.');
                            }
                          });
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dis1(
    BuildContext context,
    String error,
  ) {
    var alertDialog = AlertDialog(
        title: Text(
          'ERROR!',
          style: TextStyle(
              color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(error),
        actions: [
          FlatButton(
            onPressed: () {},
            child: Text(
              'OK',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          )
        ]);
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
