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

  Widget _buildRow(Note _note) {
    return new ListTile(

      title: new Text(
        ((_note.message != null && _note.message.isNotEmpty)
            ? _note.message
            : "Undefined"),
        style: _biggerFont,
      ),
    );
  }
  int _counter = 0;

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("You have pressed the button $_counter times."),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(notes[index]);
              },
            ))
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateNote,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
