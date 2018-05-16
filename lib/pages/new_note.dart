import 'package:flutter/material.dart';

class NewNoteWidget extends StatefulWidget {

  @override
  createState() => new NewNoteWidgetState();
}


class NewNoteWidgetState extends State<NewNoteWidget> {

  void _close()
  {
      Navigator.pop(context, false);
  }

  void _save()
  {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("This is the new note widget."),
        automaticallyImplyLeading: false,
      ),
      body:
      new SingleChildScrollView(
        scrollDirection: Axis.vertical,
      child: new TextField(
        decoration: new InputDecoration(
          hintText: 'Enter Description'
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
        autofocus: true,
      ))
    ,
        bottomNavigationBar: new BottomAppBar(
      child: new Row(
        children: <Widget>[
          new RaisedButton(onPressed: _save,
              child: const Text("Save"),
              color: Colors.green),
          new RaisedButton(onPressed: _close,
              child: const Text("Cancel"),
              color: Colors.red)
        ],
      ),
    )
    );
  }
}