import 'package:flutter/material.dart';

class NewNoteWidget extends StatefulWidget {

  @override
  createState() => new NewNoteWidgetState();
}


class NewNoteWidgetState extends State<NewNoteWidget> {

  void _close()
  {
      Navigator.pop(context);
  }

  void _save()
  {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("This is the new note widget."),
      ),
      body: new Center(
      child: Column(
    children: <Widget>[
      new RaisedButton(onPressed: _save,
        child: const Text("Save"),
        color: Colors.green,),
        new RaisedButton(onPressed: _close,
          child: const Text("Cancel"),
          color: Colors.red,)
      ]))
    );
  }
}