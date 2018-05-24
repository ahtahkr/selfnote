import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import '../database/category_database_provider.dart';
import '../database/modal/category.dart';
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
  NoteDatabaseProvider _noteDatabaseProvider;
  CategoryDatabaseProvider _categoryDatabaseProvider;
  List<Category> categories;
  Category selectedCategory;
  int characterCount;

  NoteEditState(Note note, String databaseFullPath) {
    this._note = note;
    this._textEditingController = new TextEditingController();
    this._noteDatabaseProvider = new NoteDatabaseProvider(databaseFullPath);
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
    this.categories = new List();
  }
  _categorySelected(Category category) {
    setState(() {
      this.selectedCategory = category;
      print('categorySelected a: ' + category.toString());
      print('categorySelected b: ' + this.selectedCategory.toString());
    });
  }

  void onChange() {
    setState(() {
      characterCount = 1500 - _textEditingController.text.toString().length;
    });
  }

  @override
  void initState() {
    super.initState();
    this._textEditingController.text = this._note.message.toString();
    this.characterCount = 1500 - _textEditingController.text.toString().length;
    this._textEditingController.addListener(onChange);
    this._categoryDatabaseProvider.initialSetUp().then((res) {
      print('initial setup complete.');
      this._categoryDatabaseProvider.get().then((res_1) {
        print('get complete. ' + res_1.toString());
        setState(() {
          this.categories = res_1;
        });
        for (int a = 0; a < this.categories.length; a++) {
          if (this.categories[a].id == this._note.categoryId) {
            setState(() {
              this.selectedCategory = this.categories[a];
            });
            print('NewNoteWidgetState initState assigning selectedCategory. ' +
                this.selectedCategory.toString());
          }
        }
      });
    });
  }

  _updateNote() {
    this._note.message = this._textEditingController.value.text.toString();
    this._note.categoryId = this.selectedCategory.id;
    this._noteDatabaseProvider.open().then((_bool) {
      if (_bool) {
        this._noteDatabaseProvider.update(this._note).then((res) {
          if (res != null && res is int && res > 0) {
            Navigator.pop(context, res);
          } else {
            print(
                "SelfNoteError. NoteEditState. _function. _updateNote. databaseupdate returned error. res: " +
                    res.toString());
          }
        }).catchError((e) {
          print(
              "SelfNoteError. NoteEditState. _function. _updateNote. databaseupdate returned error (in catch). e: " +
                  e.toString());
        });
      } else {
        print(
            "SelfNoteError. NoteEditState. _function. _updateNote. database open failed. _bool: " +
                _bool.toString());
      }
    }).catchError((e) {
      print(
          "SelfNoteError. NoteEditState. _function. _updateNote. database open failed (in catch). e: " +
              e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Note Edit"),
        ),
        body: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new DropdownButton(
                        isDense: true,
                        value: this.selectedCategory,
                        items: this.categories.map((Category category) {
                          return new DropdownMenuItem(
                              value: category, child: new Text(category.title));
                        }).toList(),
                        onChanged: (Category category) {
                          _categorySelected(category);
                        })),
                new Expanded(
                    child: new Chip(
                  avatar: new CircleAvatar(
                    child: new Text('#'),
                  ),
                  label:
                      new Text(characterCount.toString() + ' characters left.'),
                ))
              ],
            ),
            new Expanded(
                child: new Column(
              children: <Widget>[
                new Expanded(
                    child: new Padding(
                        padding: new EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 25.0),
                        child: new TextField(
                          maxLines: null,
                          maxLength: 1500,
                          controller: _textEditingController,
                          decoration: new InputDecoration(
                            hintText: 'Enter Description',
                          ),
                        )))
              ],
            ))
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              this._updateNote();
            },
            child: new Icon(Icons.save),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white));
  }
}
