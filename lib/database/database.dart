
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase
{
  String databaseName;
  String databaseDirectory;
  String databaseFullPath;

  AppDatabase(String _databaseDirectory, String _databaseName) {
    if (_databaseDirectory != null && _databaseDirectory.isNotEmpty) {
      this.databaseDirectory = _databaseDirectory;
    } else {
      // Error Logger
      return;
    }

    if (_databaseName != null && _databaseName.isNotEmpty) {
      this.databaseName = _databaseName;
    } else {
      // Error Logger
      return;
    }

    this.databaseFullPath = join(this.databaseDirectory, this.databaseName);
  }

  String getDatabaseFullPath() {
    return this.databaseFullPath.toString();
  }

}