import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import './new_note.dart';

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
        this.noteDatabaseProvider.setUpDatabase().then((res_1){
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

  void _updateNote() {
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new NewNoteWidget(this.noteDatabaseProvider)))
    .then((result) {
      if (result != null && result is Note && result.message.length > 0) {
        setState(() {
          this.notes.add(result);
        });
      }
    });
  }

  Widget _buildRow(Note _note, BoxDecoration boxDecoration) {
    return new Container(
      decoration: boxDecoration,
        child: new ListTile(
      dense: true,
      title: new Text(

        ((_note.message != null && _note.message.isNotEmpty)
            ? _note.message
            : "Undefined"),
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: notes.length,

              itemBuilder: (BuildContext context, int index) {
                BoxDecoration boxDecoration;
                if (index%2 == 0) {
                  boxDecoration = new BoxDecoration(color: Colors.grey[200]);
                } else {
                  boxDecoration = new BoxDecoration(color: Colors.transparent);
                }
                return _buildRow(notes[index], boxDecoration);
              },
            )
            ,
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateNote,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
