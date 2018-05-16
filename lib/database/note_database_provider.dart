import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert';

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

  String toString() {
    return "{id:$id, message:$message, createdOn:$createdOn, updatedOn:$updatedOn, notification:$notification, notificationTime:$notificationTime";
  }

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
    //print("Note. from Map.");
    //map.forEach((k, v) => print("Note. from Map. " + k + ":" + v.toString()));
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
    print("NoteDBProvider. SetUpDatabase.");
    return this.get().then((res) {
      if (res != null) {
        if (res.length == 0) {
          print("NoteDBProvider. SetUpDatabase. Note Table is empty.");
          Note note = new Note();
          return this.insert(note).then((note) {
            print("NoteDBProvider. SetUpDatabase. Insert successful.");
            return true;
          }).catchError((e) {
            print(e.toString());
            return false;
          });
        } else {
          print("NoteDBProvider. SetUpDatabase. Note Table is not empty");
          return true;
        }
      } else {
        print("NoteDBProvider. SetUpDatabase. Get() returned null." +
            res.toString());
        return false;
      }
    });
  }

  Future<bool> open() {
    print("NoteDBProvider. Open.");
    if (this.databaseFullPath != null && this.databaseFullPath.isNotEmpty) {
      return openDatabase(this.databaseFullPath, version: 1,
          onCreate: (Database database, int version) {
        db = database;
        db.execute(this.getCreateTableQuery().toString()).then((_) {
          print("NoteDBProvider. Open. Create table Successful.");
        }).catchError((e) {
          print("NoteDBProvider. Open. Error: " + e.toString());
        });
      }).then((database) {
        db = database;
        print("NoteDBProvider. Open. database assigned. db.path: " + db.path);
        return true;
      }).catchError((e) {
        print("NoteDBProvider. Open. Error: " + e.toString());
        return false;
      });
    } else {
      print("NoteDBProvider. Open. DatbaseFullPath variable not assigned yet.");
      return new Future(() {
        return false;
      });
    }
  }

  Future<List<Note>> get() {
    print("Note db provider");
    print("Note db provider. get.");
    return db.query(tableNote, columns: [
      columnId,
      columnMessage,
      columnCreatedOn,
      columnUpdatedOn,
      columnNotificationTime,
      columnNotification
    ]).then((res) {
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
      print("Note db provider. get. catchError. " + e.toString());
      return new List<Note>();
    });
  }

  Future<Note> insert(Note note) {
    print("NoteDBProvider. Insert. note: " + note.toString());
    return db.insert(tableNote, note.toMap()).then((res) {
      note.id = res;
      print("NoteDBProvider. Insert. Successful. " + note.toString());
      return note;
    }).catchError((e) {
      print("NoteDBProvider. Insert. Unsuccessful. Error: " + e.toString());
      return note;
    });
  }

  Future<Note> getNote(int id) async {
    if (id != null) {
      print("NoteDBProvider. getNote. id: " + id.toString());
      return db.query(tableNote,
          columns: [columnId, columnMessage, columnCreatedOn, columnUpdatedOn, columnNotification, columnNotificationTime],
          where: "$columnId = ?",
          whereArgs: [id]).then((result) {
            print(result.toString());
        if (result.length > 0) {
          return new Note.fromMap(result.first);
        } else {
          return null;
        }
      });
    } else {
      print("NoteDBProvider. getNote. id is null. id: " + id.toString());
      return null;
    }
  }

  Future<int> update(Note note) {
    print("NoteDBProvider. update. got: " + note.toString());
    return db.update(tableNote, note.toMap(),
        where: "$columnId = ?", whereArgs: [note.id])
    .then((res) { /*res = 1. if update successful.*/ print("NoteDBProvider. update. after update: " + res.toString()); return res;})
    .catchError((e) {print(e.toString()); return -1;});
  }

  Future<Note> insertUpdate(Note note) {
    return this.getNote(note.id).then((res) {
      print("NoteDBProvider. insertUpdate. got: " + res.toString());
      if (res != null && res is Note) {
        return this.update(note).then((res_1) {
          print("NoteDBProvider. insertUpdate. update: " + res_1.toString());

          return note;
        }).catchError((e) {
          print(e.toString());
          note.id = -1;
          return note;
        });
      } else {
        this.insert(note).then((res_one) {
          print("NoteDBProvider. insertUpdate. insert: " + res_one.toString());
          return res_one;
        }).catchError((e) {
          print(e.toString());
          return null;
        });
      }
    }).catchError((e) {print(e.toString()); return null;});
  }
}

/*

Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();

*/
