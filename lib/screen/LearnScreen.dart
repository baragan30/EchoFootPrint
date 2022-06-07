import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  static const routeName = '/learn';
  const LearnScreen({Key key}) : super(key: key);

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('LearnScreen'),
    );
  }
}
