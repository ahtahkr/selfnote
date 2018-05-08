import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget
{
  final String pageText = "CategoryPage";

  CategoryPage();

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