import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortapp/authentication/dlogin.dart';
import 'package:sortapp/main.dart';
import 'package:transition/transition.dart';

class DSignUp extends StatefulWidget {
  const DSignUp({Key? key}) : super(key: key);

  @override
  _DSignUpState createState() => _DSignUpState();
}

class _DSignUpState extends State<DSignUp> {
  String email = "";
  String password = "";
  String repassword = "";
  String aadhar = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  bool selected = false;
  Icon eye = Icon(Icons.visibility_off);
  bool selected1 = false;
  Icon eye1 = Icon(Icons.visibility_off);
  int counter1 = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      email = '';
      password = '';
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

  myselection1() {
    selected1 = !selected1;
    if (selected1 == true) {
      setState(() {
        eye1 = Icon(Icons.visibility);
      });
    } else if (selected == false) {
      setState(() {
        eye1 = Icon(Icons.visibility_off);
      });
    }
  }

  String dropdownvalue = 'Valasar Colony,DPI';

  var items = ['Valasar Colony,DPI', 'KGP Street,DPI'];

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
            Navigator.pushReplacement(
                context,
                Transition(
                    child: DSignIn(),
                    transitionEffect: TransitionEffect.LEFT_TO_RIGHT));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Disposer's",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5ebcd6),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5ebcd6),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sign Up to register Disposer account",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              SizedBox(
                height: 30,
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
                height: 15,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    obscureText: !selected1,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            myselection1();
                          },
                          icon: eye1),
                      hintText: 'ReEnter Password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        repassword = value.trim();
                      });
                    },
                  )),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.perm_identity),
                    hintText: 'Aadhar Number:',
                  ),
                  onChanged: (value) {
                    setState(() {
                      aadhar = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Area Selection:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
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
                          "REGISTER",
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
                        onPressed: () async {
                          if (password == repassword) {
                            FirebaseFirestore.instance
                                .collection("disposer")
                                .doc(email)
                                .get()
                                .then((DocumentSnapshot dc) {
                              if (dc.exists) {
                                dis2(context, "User Exists Already!");
                              } else {
                                FirebaseFirestore.instance
                                    .collection("requests")
                                    .doc(email)
                                    .set({
                                  "email": email,
                                  "password": password,
                                  "repassword": repassword,
                                  "aadhar": aadhar,
                                  "area": dropdownvalue,
                                }).then((value) {
                                  dis2(context, "Request Sent Successfully!");
                                });
                              }
                            });
                          } else {
                            dis1(context,
                                "Password And Repassword are not same");
                          }
                        }),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  MaterialButton(
                    splashColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          Transition(
                              child: DSignIn(),
                              transitionEffect:
                                  TransitionEffect.LEFT_TO_RIGHT));
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
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
            onPressed: () {
              Navigator.pop(context);
            },
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

  void dis2(
    BuildContext context,
    String msg,
  ) {
    var alertDialog = AlertDialog(
        title: Text(
          'Successful',
          style: TextStyle(
              color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                email = "";
                password = "";
                repassword = "";
                aadhar = "";
                dropdownvalue = "Valasar Colony,DPI";
              });
            },
            child: Text(
              'OK',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
