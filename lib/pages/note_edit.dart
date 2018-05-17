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
  AnimationController _controller;

  NoteEditState(Note note) {
    this._note = note;
    this._textEditingController = new TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    this._textEditingController.text = this._note.message.toString();
    this._controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  static const List<IconData> _icons = const [
    Icons.save,
    Icons.cancel
  ];
  static const List<Color> _backgroundColor = const [
    Colors.green,
    Colors.orange
  ];
  Color _foregroundColor = Colors.white;
  _function(int index) {
    if (index != null) {
      if (index == 0) {
        //Navigator.push(context, new MaterialPageRoute(builder: (context) => new NoteEditWidget(this._note)));
      } else if (index == 1) {
        Navigator.pop(context, -1);
      }
    }
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
        ),
        floatingActionButton: new Column(
            mainAxisSize: MainAxisSize.min,
            children: new List.generate(_icons.length, (int index) {
              Widget child = new Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: new ScaleTransition(
                  scale: new CurvedAnimation(
                    parent: _controller,
                    curve: new Interval(0.0, 1.0 - index / _icons.length / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: new FloatingActionButton(
                    heroTag: "Y${_icons[index]}",
                    backgroundColor: _backgroundColor[index],
                    mini: true,
                    child: new Icon(_icons[index], color: _foregroundColor),
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
              )
        )
    );
  }
}