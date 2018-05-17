import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import './new_note.dart';
import './note_view.dart';

class NoteWidget extends StatefulWidget {
  final String databaseFullPath;

  NoteWidget(String _databaseFullPath)
      : this.databaseFullPath = _databaseFullPath;

  @override
  createState() => new NoteWidgetState(this.databaseFullPath);
}

class NoteWidgetState extends State<NoteWidget> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  List<Note> notes = List();
  NoteDatabaseProvider noteDatabaseProvider;

  NoteWidgetState(String _databaseFullPath)
      : this.noteDatabaseProvider = new NoteDatabaseProvider(_databaseFullPath);

  @override
  void initState() {
    super.initState();
    this.noteDatabaseProvider.open().then((res) {
      if (res) {
        this.noteDatabaseProvider.setUpDatabase().then((res_1) {
          if (res_1) {
            this.noteDatabaseProvider.get().then((res) {
              setState(() {
                this.notes = res;
              });
            });
          }
        });
      }
    });
  }

  void _noteView(Note note) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new NoteView(note)))
        .then((result) {
          if (result != null && result is int && result > 0) {
            this.noteDatabaseProvider.getNote(result)
                .then((res) {
                  if (res != null && res is Note && res.message.length > 0) {
                    bool _found = false;
                    int a;
                    for (a = 0; a < this.notes.length; a++) {
                      if (this.notes[a].id == res.id) {
                        print("SelfNoteSuccess. NoteWidgetState. _noteView. note: [" + result.toString() + "] found in this.notes list.");
                        _found = true;
                        setState(() {
                          this.notes[a].message = res.message;
                        });
                      }
                    }
                    if (a >= this.notes.length && !_found) {
                      print("SelfNoteError. NoteWidgetState. _noteView. note: [" + result.toString() + "] not found in this.notes list.");
                    }
                  } else {
                    print("SelfNoteError. NoteWidgetState. _noteView. Invalid res received. res: " + result.toString() + ".");
                  }
            })
                .catchError((e) {});
          } else if (result == -1) {
            // Cancelled in NoreView
          }else {
            print("SelfNoteError. NoteWidgetState. _noteView. Invalid result received. result: " + result + ". note: " + note.toString());
          }
    });
  }

  void _updateNote(Note note) {
    print('_updateNote. ' + note.toString());
    Navigator
        .push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new NewNoteWidget(this.noteDatabaseProvider, note)))
        .then((result) {
      if (result != null && result is Note && result.message.length > 0) {
        setState(() {

          bool contains = false;
          for (int a = 0; a < this.notes.length; a++) {
            if (this.notes[a].id == result.id) {
              print("updatenote. id found. id:" + this.notes[a].id.toString() + " : " + result.id.toString());
              this.notes[a].message = result.message;
              contains = true;
            }
            if (a >= (this.notes.length-1) && !contains) {
              print("updatenote. id not found.");
                  this.notes.add(result);
            }
          }
        });
      }
    });
  }

  Widget _buildRow(Note _note, BoxDecoration boxDecoration) {
    return new Container(
        decoration: boxDecoration,
        child: new ListTile(
          onTap: () { this._noteView(_note); },
          dense: true,
          title: new Text(
            ((_note.message != null && _note.message.isNotEmpty)
                ? _note.message
                : "Undefined"),
            maxLines: 5,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          BoxDecoration boxDecoration;
          if (index % 2 == 0) {
            boxDecoration = new BoxDecoration(color: Colors.grey[200]);
          } else {
            boxDecoration = new BoxDecoration(color: Colors.transparent);
          }
          return _buildRow(notes[index], boxDecoration);
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () { _updateNote(new Note()); },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
