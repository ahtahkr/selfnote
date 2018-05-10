import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../database/note_database_provider.dart';

class NotePage extends StatelessWidget
{
  final String pageText = "NotePage";
  final NoteDatabaseProvider noteDatabaseProvider;

  NotePage(String _databaseDirectory, String _databaseName)
      : this.noteDatabaseProvider = new NoteDatabaseProvider(join(_databaseDirectory, _databaseName))
      {
        this.noteDatabaseProvider.setUpDatabase();
      }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new Text(pageText)
      ),
    );
  }
}