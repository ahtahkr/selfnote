import 'package:flutter/material.dart';
import '../database/database.dart';

class NotePage extends StatelessWidget
{
  final String pageText = "NotePage";
  final AppDatabase appDatabase;

  NotePage(String _databaseDirectory, String _databaseName)
      : this.appDatabase = new AppDatabase(_databaseDirectory, _databaseName);

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
        body: new Center(
          child: new Text(pageText + " " + this.appDatabase.getDatabaseFullPath())
        ),
    );
  }
}