import 'dart:io';

import 'package:echofootprint2/model/DUMMY_DATA.dart';
import 'package:echofootprint2/screen/LearnScreen.dart';
import 'package:echofootprint2/screen/company_screen.dart';
import 'package:echofootprint2/screen/main_screen.dart';
import 'package:echofootprint2/screen/progress_screen.dart';
import 'package:echofootprint2/screen/reward_screen.dart';
import 'package:echofootprint2/screen/vouchers_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({@required this.child});

  Widget child;

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final double _floatingSize = 80;
  final double _floatingIconSize = 45;
  final String modelname1 = 'borsecVSredbull';
  final String modelname2 = 'waste';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/$modelname1.tflite", labels: "assets/$modelname1.txt"));
  }

  Future imageClassification(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    File image = File(pickedFile.path);
    List recognition1 = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    companies
        .firstWhere((element) => element.id == recognition1.first['index'])
        .t = false;
    ////////////////////////////////////////////////////////////////////////////////
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/$modelname2.tflite", labels: "assets/$modelname2.txt"));

    List recognition2 = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    var l = ['Aluminium', 'Pet', 'Glass', 'HDPEM-Plastic'];
    print(recognition1.first);

    if (recognition1.first['index'] == 1 &&
        recognition1.first['confidence'] < 0.6) {
      Navigator.of(context).pushNamed(RewardScreen.routeName,
          arguments: Myclass(0, l[recognition2.first['index']]));
    } else {
      Navigator.of(context).pushNamed(RewardScreen.routeName,
          arguments: Myclass(
              recognition1.first['index'], l[recognition2.first['index']]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.green, title: const Text('CO2-LESS')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpeg"),
            fit: BoxFit.cover,
            alignment: Alignment.topRight,
          ),
        ),
        child: widget.child /* add child content here */,
      ),
      floatingActionButton: Container(
        height: _floatingSize,
        width: _floatingSize,
        child: FloatingActionButton(
          onPressed: () {
            imageClassification(context);
          },
          child: Icon(
            Icons.add,
            size: _floatingIconSize,
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.

        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Center(child: Text('Menu')),
            ),
            ListTile(
              title: const Text('Home Page'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(MainScreen.routeName);
              },
            ),
            ListTile(
              title: const Text('Progress'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ProgressScreen.routeName);
              },
            ),
            ListTile(
              title: const Text('Vouchers'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(VouchersScreen.routeName);
              },
            ),
            ListTile(
              title: const Text('Learning'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(LearnScreen.routeName);
              },
            ),
            ListTile(
              title: const Text('Company'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(CompanyScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
