import 'package:flutter/material.dart';

void main() => runApp(new SelfNote());

class SelfNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter AppBar'),
        ),
        body: new Center(
          child: new Text('Hello World'),
        ),
      ),
    );
  }
}