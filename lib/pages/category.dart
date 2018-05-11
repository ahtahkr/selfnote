import 'package:flutter/material.dart';
import '../database/database.dart';

class CategoryPage extends StatelessWidget {
  final String pageText = "CategoriesPage";
  final AppDatabase appDatabase;

  CategoryPage(String _databaseDirectory, String _databaseName)
      : appDatabase = new AppDatabase(_databaseDirectory, _databaseName);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new Text(
              pageText + " " + this.appDatabase.getDatabaseFullPath())),
    );
  }
}
