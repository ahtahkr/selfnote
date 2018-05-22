import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import 'dart:math' as math;

class NoteEditWidget extends StatefulWidget {
  final Note _note;
  final String _databaseFullPath;

  NoteEditWidget(Note note, String databaseFullPath)
      : this._note = note,
        this._databaseFullPath = databaseFullPath {
    print('NoteView Constructor');
  }

  @override
  createState() => new NoteEditState(this._note, this._databaseFullPath);
}

class NoteEditState extends State<NoteEditWidget>
    with TickerProviderStateMixin {
  Note _note;
  TextEditingController _textEditingController;
  AnimationController _controller;
  NoteDatabaseProvider _noteDatabaseProvider;

  NoteEditState(Note note, String databaseFullPath) {
    this._note = note;
    this._textEditingController = new TextEditingController();
    this._noteDatabaseProvider = new NoteDatabaseProvider(databaseFullPath);
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

  static const List<IconData> _icons = const [Icons.save, Icons.cancel];
  static const List<Color> _backgroundColor = const [
    Colors.green,
    Colors.orange
  ];
  Color _foregroundColor = Colors.white;
  _function(int index) {
    if (index != null) {
      if (index == 0) {
        this._note.message = this._textEditingController.value.text.toString();
        this._noteDatabaseProvider.open().then((_bool) {
          if (_bool) {
            this._noteDatabaseProvider.update(this._note).then((res) {
              if (res != null && res is int && res > 0) {
                Navigator.pop(context, res);
              } else {
                print("SelfNoteError. NoteEditState. _function. index[" +
                    index.toString() +
                    "] databaseupdate returned error. res: " +
                    res.toString());
              }
            }).catchError((e) {
              print("SelfNoteError. NoteEditState. _function. index[" +
                  index.toString() +
                  "] databaseupdate returned error (in catch). e: " +
                  e.toString());
            });
          } else {
            print("SelfNoteError. NoteEditState. _function. index[" +
                index.toString() +
                "] database open failed. _bool: " +
                _bool.toString());
          }
        }).catchError((e) {
          print("SelfNoteError. NoteEditState. _function. index[" +
              index.toString() +
              "] database open failed (in catch). e: " +
              e.toString());
        });
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
        )),
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
              )));
  }
}
