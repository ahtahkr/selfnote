import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
    );
  }
}
