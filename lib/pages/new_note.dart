import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import 'dart:math' as math;

class NewNoteWidget extends StatefulWidget {
  final NoteDatabaseProvider _noteDatabaseProvider;

  NewNoteWidget(NoteDatabaseProvider noteDatabaseProvider)
      : this._noteDatabaseProvider = noteDatabaseProvider;

  @override
  createState() => new NewNoteWidgetState(this._noteDatabaseProvider);
}

class NewNoteWidgetState extends State<NewNoteWidget>
    with TickerProviderStateMixin {
  TextEditingController _textEditController;
  NoteDatabaseProvider _noteDatabaseProvider;
  AnimationController _controller;

  static const List<IconData> icons = const [
    Icons.save,
    Icons.cancel,
    Icons.keyboard_hide
  ];

  NewNoteWidgetState(NoteDatabaseProvider noteDatabaseProvider) {
    this._noteDatabaseProvider = noteDatabaseProvider;
  }

  void _cancel() {
    Navigator.pop(context, false);
  }

  void _save() {
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
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  _function(int index) {
    if (index != null) {
      if (index == 2) {
        FocusScope.of(context).requestFocus(new FocusNode());
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
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("This is the new note widget."),
          automaticallyImplyLeading: false,
        ),
        body: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new TextField(
            decoration: new InputDecoration(hintText: 'Enter Description'),
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
                    backgroundColor: backgroundColor,
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
