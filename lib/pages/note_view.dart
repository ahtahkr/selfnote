import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';

class NoteView extends StatefulWidget {
  final Note _note;

  NoteView(Note note)
    : this._note = note {
    print('NoteView Constructor');
  }

  @override
  createState() => new NoteViewState(this._note);
}

class NoteViewState extends State<NoteView> {

  Note _note;
  TextEditingController _textEditingController;

  NoteViewState(Note note) {
    print('NoteViewState Constructor start.');
    this._note = note;
    this._textEditingController = new TextEditingController();
    print('NoteViewState Constructor end.');
  }
  
  @override
  void initState() {
    print('NoteViewState initState start.');
    super.initState();
    this._textEditingController.text = this._note.message.toString();
    print('NoteViewState initState end.');
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Note"),
        automaticallyImplyLeading: false,
      ),
      body: new Center(
          child: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new TextField(
          maxLines: null,
          enabled: false,
          controller: _textEditingController,
        ),
      )
      ),
    );
  }
}