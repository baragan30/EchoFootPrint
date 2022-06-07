import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({Key key}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  File _image;
  List _results;
  bool imageSelect = false;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/bottles.tflite", labels: "assets/labels_bottles.txt"));
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(recognitions.length);
    recognitions.forEach((element) {
      print(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: ListView(
        children: [
          (imageSelect)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.file(_image),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: const Opacity(
                    opacity: 0.8,
                    child: Center(
                      child: Text("No image selected"),
                    ),
                  ),
                ),
          SingleChildScrollView(
            child: Column(
              children: (imageSelect)
                  ? _results.map((result) {
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 20),
                          ),
                        ),
                      );
                    }).toList()
                  : [],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: "Pick Image",
        child: const Icon(Icons.image),
      ),
    );
  }

  Future pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    File image = File(pickedFile.path);
    imageClassification(image);
  }
}
