import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:sortapp/api/firebaseapi.dart';
import 'package:tflite/tflite.dart';

class user extends StatefulWidget {
  const user({Key? key}) : super(key: key);

  @override
  _userState createState() => _userState();
}

class _userState extends State<user> {
  XFile? _image;
  var url;
  var _output;

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

  Future upload(var image) async {
    File s = File(image.path);
    final filename = Timestamp.now();
    final destination = '19MIC0113/$filename';
    var task = FirebaseApi.uploadFile(destination, s);
    if (task == null) {
      return;
    } else {
      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        this._image = null;
        this.url = urlDownload;
      });
    }
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
    );
    print("predict = " + output.toString());
    setState(() {
      this._output = output![0]['label'];
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/tflite/rohit2.tflite",
        labels: "assets/tflite/rohit2.txt");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IMAGE PICKER"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        getimage(false);
                      },
                      icon: Icon(Icons.insert_drive_file_outlined)),
                  IconButton(
                      onPressed: () {
                        getimage(true);
                      },
                      icon: Icon(Icons.camera_alt_outlined)),
                ],
              ),
            ),
            (_image != null)
                ? Image.file(
                    File(_image!.path),
                    height: 300,
                    width: 300,
                  )
                : Container(),
            (_image != null)
                ? RaisedButton(
                    onPressed: () {
                      upload(this._image);
                    },
                    child: Text("UPLOAD"),
                    color: Colors.amber,
                  )
                : Container(),
            if (url != null)
              Image.network(
                url,
                height: 500,
                width: 300,
              ),
            if (_image != null)
              IconButton(
                  onPressed: () {
                    classifyImage(File(_image!.path));
                  },
                  icon: Icon(Icons.camera_alt_outlined)),
            if (_output != null) Text(_output)
          ],
        ),
      ),
    );
  }
}
