import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sortapp/drawer/menu.dart';
import 'package:sortapp/main.dart';
import 'package:tflite/tflite.dart';
import 'package:transition/transition.dart';

class Displayer extends StatefulWidget {
  String email;
  Displayer({required this.email});

  @override
  _DisplayerState createState() => _DisplayerState();
}

class _DisplayerState extends State<Displayer> {
  XFile? _image;
  var _output;
  var message;
  var counter = 1;
  var electrical = ["batteries", "e-waste", "light blubs"];
  var organic = ["carrot", "potato", "rose", "tomato"];
  var recycle = [
    "clothes",
  ];
  Color c1 = Color(0xff5ebcd6);
  Color c2 = Colors.blueAccent;

  Future getimage(bool isCamera) async {
    XFile image;
    final imgpic = ImagePicker();
    if (isCamera) {
      image = (await imgpic.pickImage(source: ImageSource.camera))!;
    } else {
      image = (await imgpic.pickImage(source: ImageSource.gallery))!;
    }
    setState(() {
      _image = image;
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
    );
    print("predict = " + output.toString());
    setState(() {
      counter = 1;
      var x = output![0]['label'];
      if (electrical.contains(x)) {
        this._output = 'ELECTRICAL WASTE';
        c1 = Colors.redAccent;
        c2 = Colors.red;
      } else if (recycle.contains(x)) {
        this._output = "RECYCLABLE WASTE";
        c1 = Colors.orangeAccent;
        c2 = Colors.orange;
      } else if (organic.contains(x)) {
        this._output = "ORGANIC WASTE";
        c1 = Colors.greenAccent;
        c2 = Colors.green;
      }
    });
    update();
  }

  update() async {
    FirebaseFirestore.instance
        .collection("disposer")
        .doc(widget.email)
        .get()
        .then((element) {
      var x = element.data();
      var temp = x![_output];
      FirebaseFirestore.instance
          .collection("disposer")
          .doc(widget.email)
          .update({
        _output: temp + 1,
      });
    });
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
      var temp = x![_output];
      FirebaseFirestore.instance
          .collection("disposer")
          .doc(widget.email)
          .collection("wastes")
          .doc(formattedDate)
          .update({
        _output: temp + 1,
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/tflite/rohit2.tflite",
        labels: "assets/tflite/rohit2.txt");
  }

  model() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    await FirebaseFirestore.instance
        .collection("disposer")
        .doc(widget.email)
        .collection("wastes")
        .doc(formattedDate)
        .get()
        .then((doc) {
      if (!doc.exists) {
        FirebaseFirestore.instance
            .collection("disposer")
            .doc(widget.email)
            .collection("wastes")
            .doc(formattedDate)
            .set({
          'ELECTRICAL WASTE': 0,
          "RECYCLABLE WASTE": 0,
          "ORGANIC WASTE": 0,
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
    model();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuBar(
        email: widget.email,
        c1: c1,
      ),
      appBar: AppBar(
        backgroundColor: c1,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                    context,
                    Transition(
                        child: StartPage(),
                        transitionEffect: TransitionEffect.LEFT_TO_RIGHT)));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c1, c2],
          )),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'CLEANIFY',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Text(
                    'Start your Treasure Sorting',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            setState(() {
                              c1 = Color(0xff5ebcd6);
                              c2 = Colors.blueAccent;
                              _image = null;
                              _output = null;
                              counter = 1;
                            });
                            getimage(false);
                          },
                          icon: Icon(Icons.insert_drive_file_outlined)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              c1 = Color(0xff5ebcd6);
                              c2 = Colors.blueAccent;
                              _image = null;
                              _output = null;
                              counter = 1;
                            });
                            getimage(true);
                          },
                          icon: Icon(Icons.camera_alt_outlined)),
                    ],
                  ),
                ),
                if (_image != null)
                  SizedBox(
                    child: Center(
                      child: Container(
                        height: 300,
                        child: Image.file(
                          File(_image!.path),
                          height: 300,
                          width: 250,
                        ),
                      ),
                    ),
                  ),
                if (_output != null)
                  Column(children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CLASSIFIED",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Text(
                            ":",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Text(
                            _output,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.elliptical(400, 100)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20),
                        if (_image != null)
                          Center(
                            child: Column(
                              children: <Widget>[
                                MaterialButton(
                                    height: 40,
                                    minWidth: 100,
                                    child: (counter == 1)
                                        ? Text(
                                            "CLASSIFY",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Text(
                                            "LOADING..",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                    color: c1,
                                    splashColor: c2,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    onPressed: () {
                                      dis1(context,
                                          "Are you sure to Dispose this item?");
                                    }),
                                Padding(padding: EdgeInsets.only(top: 0)),
                              ],
                            ),
                          ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        if (_output != null)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "The Disposed Item is classified as ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                _output,
                                style: TextStyle(
                                    color: c1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 50),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void dis1(
    BuildContext context,
    String msg,
  ) {
    var alertDialog = AlertDialog(
        title: Text(
          'CONFIRMATION!',
          style: TextStyle(
              color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'NO',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                counter = 0;
              });
              classifyImage(File(_image!.path));
            },
            child: Text(
              'YES',
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
