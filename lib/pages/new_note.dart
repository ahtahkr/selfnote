import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import 'dart:math' as math;

class NewNoteWidget extends StatefulWidget {
  final NoteDatabaseProvider _noteDatabaseProvider;
  final Note _note;

  NewNoteWidget(NoteDatabaseProvider noteDatabaseProvider, Note note)
      : this._noteDatabaseProvider = noteDatabaseProvider
        , this._note = note {

    print('new note widget. ' + this._note.toString());
  }


  @override
  createState() => new NewNoteWidgetState(this._noteDatabaseProvider, this._note);
}

class NewNoteWidgetState extends State<NewNoteWidget>
    with TickerProviderStateMixin {
  TextEditingController _textEditController;
  NoteDatabaseProvider _noteDatabaseProvider;
  AnimationController _controller;
  Note note;

  static const List<IconData> icons = const [
    Icons.save,
    Icons.cancel,
    Icons.delete
  ];
  static const List<Color> _backgroundColor = const [
    Colors.green,
    Colors.orange,
    Colors.red
  ];

  NewNoteWidgetState(NoteDatabaseProvider noteDatabaseProvider, Note note) {
    this._noteDatabaseProvider = noteDatabaseProvider;
    this.note = note;
    print('new note widget state. ' + this.note.toString());
  }

  void _cancel() {
    Navigator.pop(context, false);
  }

  void _save() {
    print(_textEditController.value.text.toString());
    this.note.message = _textEditController.value.text.toString();
    this._noteDatabaseProvider.insertUpdate(this.note).then((new_note) {
      print("_save" + new_note.toString());
      if (new_note.id == -1) {
        Navigator.pop(context, null);
      } else {
        Navigator.pop(context, new_note);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditController = new TextEditingController();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),

    );
  }

  _dismissKeyboard() {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      String mes = this._textEditController.value.text;
      FocusScope.of(context).requestFocus(new FocusNode());
      this._textEditController.text = mes;
    }
  }

  _function(int index) {
    if (index != null) {
      if (index == 2) {
        // place feature to delete.
      } else if (index == 0) {
        this._save();
      } else if (index == 1) {
        this._cancel();
      }
    }
    print(index);
  }

  @override
  Widget build(BuildContext context) {

    Color foregroundColor = Colors.white;

    InputDecoration inputDecoration;
    if (note.message != null && note.message.length > 0) {
      this._textEditController.text = note.message.toString();
    } else {
      inputDecoration = new InputDecoration(hintText: 'Enter Description');
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("This is the new note widget."),
          automaticallyImplyLeading: false,
        ),
        body: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new TextField(
            decoration: inputDecoration,
            maxLines: null,
            autofocus: true,
            controller: _textEditController,
          ),
        ),
        floatingActionButton: new Column(
            mainAxisSize: MainAxisSize.min,
            children: new List.generate(icons.length, (int index) {
              Widget child = new Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: new ScaleTransition(
                  scale: new CurvedAnimation(
                    parent: _controller,
                    curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: new FloatingActionButton(
                    heroTag: "Y${icons[index]}",
                    backgroundColor: _backgroundColor[index],
                    mini: true,
                    child: new Icon(icons[index], color: foregroundColor),
                    onPressed: () {
                      this._function(index);
                    },
                  ),
                ),
              );
              return child;
            }).toList()
              ..add(
                new FloatingActionButton(
                  child: new AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget child) {
                      return new Transform(
                        transform: new Matrix4.rotationZ(
                            _controller.value * 0.5 * math.pi),
                        alignment: FractionalOffset.center,
                        child: new Icon(_controller.isDismissed
                            ? Icons.share
                            : Icons.close),
                      );
                    },
                  ),
                  onPressed: () {
                    this._dismissKeyboard();
                    if (_controller.isDismissed) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                ),
              )));
  }
}
