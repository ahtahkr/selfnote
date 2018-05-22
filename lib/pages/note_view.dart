import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import 'dart:math' as math;
import './note_edit.dart';

class NoteView extends StatefulWidget {
  final Note _note;
  final String _databaseFullPath;

  NoteView(Note note, String databaseFullPath)
      : this._note = note,
        this._databaseFullPath = databaseFullPath {
    print('NoteView Constructor');
  }

  @override
  createState() => new NoteViewState(this._note, this._databaseFullPath);
}

class NoteViewState extends State<NoteView> with TickerProviderStateMixin {
  Note _note;
  TextEditingController _textEditingController;
  AnimationController _controller;
  NoteDatabaseProvider _noteDatabaseProvider;

  NoteViewState(Note note, String databaseFullPath) {
    print('NoteViewState Constructor start.');
    this._note = note;
    this._textEditingController = new TextEditingController();
    this._noteDatabaseProvider = new NoteDatabaseProvider(databaseFullPath);
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
    Icons.delete,
    Icons.cancel
  ];
  static const List<Color> _backgroundColor = const [
    Colors.blue,
    Colors.red,
    Colors.orange
  ];
  Color _foregroundColor = Colors.white;
  _function(int index) {
    if (index != null) {
      if (index == 0) {
        Navigator
            .push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new NoteEditWidget(this._note,
                        this._noteDatabaseProvider.databaseFullPath)))
            .then((res) {
          if (res != null && res is int && (res > 0 || res == -1)) {
            if (res == -1) {
              /* If cancelled in NoteEdit, then do nothing. */
            } else {
              this._noteDatabaseProvider.open().then((result) {
                if (result != null && result is bool && result) {
                  this._noteDatabaseProvider.getNote(res).then((result_one) {
                    setState(() {
                      this._note = result_one;
                      this._textEditingController.text = result_one.message;
                    });
                  }).catchError((e) {
                    print("SelfNoteError. NoteViewState. _function. index[" +
                        index.toString() +
                        "] database getNote failed. e: " +
                        e.toString());
                  });
                } else {
                  print("SelfNoteError. NoteViewState. _function. index[" +
                      index.toString() +
                      "] database open failed. _bool: " +
                      result.toString());
                }
              }).catchError((e) {
                print("SelfNoteError. NoteViewState. _function. index[" +
                    index.toString() +
                    "] database open failed (in catch). e: " +
                    e.toString());
              });
            }
          } else {
            print(
                "SelfNoteError. NoteViewState. _function. invalid result received from navigator. result: " +
                    res.toString());
          }
        }).catchError((e) {});
      } else if (index == 2) {
        Navigator.pop(context, this._note.id);
      } else if (index == 1) {
        this._noteDatabaseProvider.open().then((result) {
          if (result != null && result is bool && result) {
            this._noteDatabaseProvider.delete(this._note.id).then((result_one) {
              if (result_one != null && result_one is int) {
                Navigator.pop(context, result_one);
              } else {
                print("SelfNoteError. NoteViewState. _function. index[" +
                    index.toString() +
                    "] database delete failed. result_one: " +
                    result_one.toString());
              }
            }).catchError((e) {
              print("SelfNoteError. NoteViewState. _function. index[" +
                  index.toString() +
                  "] database delete failed. e: " +
                  e.toString());
            });
          } else {
            print("SelfNoteError. NoteViewState. _function. index[" +
                index.toString() +
                "] database open failed. _bool: " +
                result.toString());
          }
        }).catchError((e) {
          print("SelfNoteError. NoteViewState. _function. index[" +
              index.toString() +
              "] database open failed (in catch). e: " +
              e.toString());
        });
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
