import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import '../database/category_database_provider.dart';
import '../database/modal/category.dart';
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
  CategoryDatabaseProvider _categoryDatabaseProvider;
  Category _category;
  NoteViewState(Note note, String databaseFullPath) {
    print('NoteViewState Constructor start.');
    this._note = note;
    this._textEditingController = new TextEditingController();
    this._noteDatabaseProvider = new NoteDatabaseProvider(databaseFullPath);
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
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
    this._categoryDatabaseProvider.initialSetUp().then((res) {
      print('initial setup complete.');
      _getCategory();
    });
    print('NoteViewState initState end.');
  }

  _getCategory() {
    this
        ._categoryDatabaseProvider
        .getCategory(this._note.categoryId)
        .then((resOne) {
      setState(() {
        this._category = resOne;
      });
    }).catchError((e) {});
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
  _editNote() {
    Navigator
        .push(
            context,
            new MaterialPageRoute(
                builder: (context) => new NoteEditWidget(
                    this._note, this._noteDatabaseProvider.databaseFullPath)))
        .then((res) {
      if (res != null && res is int && (res > 0 || res == -1)) {
        if (res == -1) {/* If cancelled in NoteEdit, then do nothing. */} else {
          this._noteDatabaseProvider.open().then((result) {
            if (result != null && result is bool && result) {
              this._noteDatabaseProvider.getNote(res).then((result_one) {
                setState(() {
                  this._note = result_one;
                  this._getCategory();
                  this._textEditingController.text = result_one.message;
                });
              }).catchError((e) {
                print(
                    "SelfNoteError. NoteViewState. _function. _editNote. database getNote failed. e: " +
                        e.toString());
              });
            } else {
              print(
                  "SelfNoteError. NoteViewState. _function. _editNote. database open failed. _bool: " +
                      result.toString());
            }
          }).catchError((e) {
            print(
                "SelfNoteError. NoteViewState. _function. _editNote. database open failed (in catch). e: " +
                    e.toString());
          });
        }
      } else {
        print(
            "SelfNoteError. NoteViewState. _function. invalid result received from navigator. result: " +
                res.toString());
      }
    }).catchError((e) {});
  }

  _deleteNote() {
    this._noteDatabaseProvider.open().then((result) {
      if (result != null && result is bool && result) {
        this._noteDatabaseProvider.delete(this._note.id).then((result_one) {
          if (result_one != null && result_one is int) {
            Navigator.pop(context, result_one);
          } else {
            print(
                "SelfNoteError. NoteViewState. _deleteNote. database delete failed. result_one: " +
                    result_one.toString());
          }
        }).catchError((e) {
          print(
              "SelfNoteError. NoteViewState. _deleteNote. database delete failed. e: " +
                  e.toString());
        });
      } else {
        print(
            "SelfNoteError. NoteViewState. _deleteNote. database open failed. _bool: " +
                result.toString());
      }
    }).catchError((e) {
      print(
          "SelfNoteError. NoteViewState. _deleteNote. database open failed (in catch). e: " +
              e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Note"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.delete),
                splashColor: Colors.red,
                onPressed: () {
                  this._deleteNote();
                },
                tooltip: 'Delete')
          ],
        ),
        body: new Column(
          children: <Widget>[
            new Row(children: <Widget>[
              new Chip(
                avatar: new CircleAvatar(
                  child: new Icon(Icons.category),
                ),
                label: new Text(((this._category != null &&
                        this._category is Category &&
                        this._category.title.length > 0)
                    ? this._category.title
                    : '')),
              )
            ]),
            new Expanded(
                child: new SingleChildScrollView(
                    padding: new EdgeInsets.all(8.0),
                    child: new TextField(
                      maxLines: null,
                      enabled: false,
                      controller: _textEditingController,
                    )))
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              this._editNote();
            },
            child: new Icon(Icons.edit),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue));
  }
}
