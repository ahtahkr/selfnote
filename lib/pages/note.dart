import 'package:flutter/material.dart';

class NotePage extends StatelessWidget
{
  final String pageText = "NotePage";

  NotePage();

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
        body: new Center(
          child: new Text(pageText + " Body. Child.")
        ),
    );
  }
}