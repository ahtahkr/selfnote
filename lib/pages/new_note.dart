import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';

class NewNoteWidget extends StatefulWidget {
  final NoteDatabaseProvider _noteDatabaseProvider;

  NewNoteWidget(NoteDatabaseProvider noteDatabaseProvider)
    : this._noteDatabaseProvider = noteDatabaseProvider;

  @override
  createState() => new NewNoteWidgetState(this._noteDatabaseProvider);
}


class NewNoteWidgetState extends State<NewNoteWidget> {
  TextEditingController _textEditController;
  NoteDatabaseProvider _noteDatabaseProvider;

  NewNoteWidgetState(NoteDatabaseProvider noteDatabaseProvider) {
    this._noteDatabaseProvider = noteDatabaseProvider;
  }

  void _close()
  {
      Navigator.pop(context, false);
  }

  void _save()
  {
    print(_textEditController.value.text.toString());
    Note note = new Note();
    note.message = _textEditController.value.text.toString();
    this._noteDatabaseProvider.insert(note).then((new_note) {
      Navigator.pop(context, new_note);
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditController = new TextEditingController();
  }

  _onTap() {
    print("tap down ");
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  /*_onTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap down " + x.toString() + ", " + y.toString());
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("This is the new note widget."),
        automaticallyImplyLeading: false,
      ),
      body:
          new ListView(
            children: <Widget>[

      new SingleChildScrollView(
        scrollDirection: Axis.vertical,
      child: new TextField(
        decoration: new InputDecoration(
          hintText: 'Enter Description'
        ),
        maxLines: null,
        autofocus: true,
        controller: _textEditController,
      ),
      ), new GestureDetector(
        onTap: () => _onTap(),
        /*onTapDown: (TapDownDetails details) => _onTapDown(details),*/
      )
            ],
          )
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