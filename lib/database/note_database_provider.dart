import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tableNote = "note";
final String columnId = "id";
final String columnMessage = "message";
final String columnCreatedOn = "createdOn";
final String columnUpdatedOn = "updatedOn";
final String columnNotification = "notification";
final String columnNotificationTime = "notificationTime";

class Note {
  int id;
  String message;
  DateTime createdOn, updatedOn, notificationTime;
  bool notification;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnMessage: message.toString(),
      columnCreatedOn: createdOn.toString(),
      columnUpdatedOn: updatedOn.toString(),
      columnNotificationTime: notificationTime.toString(),
      columnNotification: notification == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Note() {
    this.message = "This is a Sample Note.";
    this.createdOn = new DateTime.now();
    this.updatedOn = new DateTime.now();
    this.notificationTime = new DateTime.now();
    this.notification = false;
  }

  Note.fromMap(Map map) {
    print("Note. from Map.");
    map.forEach((k,v) => print("Note. from Map. " + k + ":" + v.toString()));
    id = map[columnId];
    message = map[columnMessage];
    createdOn = DateTime.parse(map[columnCreatedOn]);
    updatedOn = DateTime.parse(map[columnUpdatedOn]);
    notificationTime = DateTime.parse(map[columnNotificationTime]);
    notification = map[columnNotification] == 1;
  }
}

class NoteDatabaseProvider {
  Database db;
  String databaseFullPath;

  NoteDatabaseProvider(String _databaseFullPath) {
    this.databaseFullPath = _databaseFullPath;
  }

  String getCreateTableQuery() {
    return '''
      create table $tableNote ( 
        $columnId integer primary key autoincrement, 
        $columnMessage text not null,
        $columnCreatedOn date not null,
        $columnUpdatedOn date not null,
        $columnNotificationTime date not null,
        $columnNotification integer not null)
      ''';
  }

  Future<bool> setUpDatabase() {
    return this.open(this.databaseFullPath).then((res) {
      if (res) {
        Note note = new Note();
        this.insert(note)
                      .then((note) {
           return true;
        }).catchError((e) {
          print(e.toString());
          return false;
        });
      } else {
        print("setUpDatabase. Open Database returned false.");
        return false;
      }
    }).catchError((e) {
      print(e.toString());
      return false;
    });
  }

  Future<bool> open(String path) {
    if (this.databaseFullPath != null && this.databaseFullPath.isNotEmpty) {
      return openDatabase(path, version: 1,
          onCreate: (Database database, int version) {
            db = database;
            db.execute(this.getCreateTableQuery().toString()).then((_) {
              return true;
            }).catchError((e) {
              print(e.toString());
              return false;
            });
          }).then((database) {
        db = database;
        return true;
      }).catchError((e) {
        print(e.toString());
        return false;
      });
    } else {
      return new Future(() { return false; });
    }
  }



  Future<List<Note>> get() {
    print("Note db provider");
    print("Note db provider. get.");
    try {
      return db.query(tableNote,
          columns: [
            columnId,
            columnMessage,
            columnCreatedOn,
            columnUpdatedOn,
            columnNotificationTime,
            columnNotification
          ]
      ).then((res) {
        print("Note db provider. get. then " + res.length.toString());
        if (res.length > 0) {
          List<Note> notes = new List<Note>();
          for (int a = 0; a < res.length; a++) {
            notes.add(new Note.fromMap(res[a]));
          }
          return notes;
        } else {
          return new List<Note>();
        }
      }).catchError((e) {
        print("Note db provider. get. catch. " + e.toString());
        print(e.toString());
        return new List<Note>();
      });
    } catch (e) {
      Note _note = new Note();
      _note.message = "database get failed.";
      return new Future(() { return List<Note>(); });
    }
  }

  Future<Note> insert(Note note) {
    return db.insert(tableNote, note.toMap())
              .then((res) {
                note.id = res;
                return note;
    }).catchError((e) {
      print(e.toString());
      return note;
    });
  }

  /*
    Future get() {
    return db.query(tableNote,
        columns: [columnId, columnMessage, columnCreatedOn, columnUpdatedOn, columnNotificationTime, columnNotification]
    ).then((res) {
      if (res.length > 0) {
        List<Map> maps = new List<Map>();
        return new Note.fromMap(maps.first);
      } else {
        return new List<Map>();
      }
    }).catchError((e) {
      print(e.toString());
      return new List<Map>();
    });
  }
  */
}
