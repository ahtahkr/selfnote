import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import 'dart:math' as math;

class NoteView extends StatefulWidget {
  final Note _note;

  NoteView(Note note)
    : this._note = note {
    print('NoteView Constructor');
  }

  @override
  createState() => new NoteViewState(this._note);
}

class NoteViewState extends State<NoteView> with TickerProviderStateMixin {

  Note _note;
  TextEditingController _textEditingController;
  AnimationController _controller;

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
    this._controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    print('NoteViewState initState end.');
  }

  static const List<IconData> _icons = const [
    Icons.edit,
    Icons.cancel
  ];
  static const List<Color> _backgroundColor = const [
    Colors.blue,
    Colors.orange
  ];
  Color _foregroundColor = Colors.white;
  _function(int index) {
    if (index != null) {
      if (index == 0) {
        print('edit');
      } else if (index == 1) {
        Navigator.pop(context, this._note.id);
      }
    }
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