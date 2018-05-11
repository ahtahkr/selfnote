import 'package:flutter/material.dart';
import './pages/home.dart';

void main() => runApp(new MaterialApp(home: new SelfNote()));

class SelfNote extends StatefulWidget {
  @override
  HomePage createState() => new HomePage();
}
