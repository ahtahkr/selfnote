import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import 'dart:math' as math;

class NoteEditWidget extends StatefulWidget {
  final Note _note;

  NoteEditWidget(Note note)
      : this._note = note {
    print('NoteView Constructor');
  }

  @override
  createState() => new NoteEditState(this._note);
}

class NoteEditState extends State<NoteEditWidget> with TickerProviderStateMixin {

  Note _note;
  TextEditingController _textEditingController;

  NoteEditState(Note note) {
    this._note = note;
    this._textEditingController = new TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    this._textEditingController.text = this._note.message.toString();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Note Edit"),
          automaticallyImplyLeading: false,
        ),
        body: new Center(
            child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new TextField(
                maxLines: null,
                enabled: true,
                controller: _textEditingController,
              ),
            )
        )
    );
  }
}