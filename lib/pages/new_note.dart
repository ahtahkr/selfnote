import 'package:flutter/material.dart';

class NewNoteWidget extends StatefulWidget {

  @override
  createState() => new NewNoteWidgetState();
}


class NewNoteWidgetState extends State<NewNoteWidget> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("This is the new note widget."),
      ),
    );
  }
}