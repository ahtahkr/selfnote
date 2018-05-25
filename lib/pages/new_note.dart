import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import '../database/category_database_provider.dart';
import '../database/modal/category.dart';

class NewNoteWidget extends StatefulWidget {
  final String _databaseFullPath;
  NewNoteWidget(String databaseFullPath)
      : this._databaseFullPath = databaseFullPath;
  @override
  createState() => new NewNoteWidgetState(this._databaseFullPath);
}

class NewNoteWidgetState extends State<NewNoteWidget>
    with TickerProviderStateMixin {
  TextEditingController _textEditController;
  NoteDatabaseProvider _noteDatabaseProvider;
  CategoryDatabaseProvider _categoryDatabaseProvider;
  List<Category> categories;
  Category selectedCategory;
  Note note;
  int characterCount;
  NewNoteWidgetState(String databaseFullPath) {
    this._noteDatabaseProvider = new NoteDatabaseProvider(databaseFullPath);
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
    this.note = new Note();
    this.categories = new List();
    this.characterCount = 1500;
  }
  /*void _cancel() {
    Navigator.pop(context, false);
  }*/

  void _save() {
    print(_textEditController.value.text.toString());
    this.note.message = _textEditController.value.text.toString();
    this.note.categoryId = this.selectedCategory.id;
    this._noteDatabaseProvider.open().then((_bool) {
      if (_bool) {
        this._noteDatabaseProvider.insertUpdate(this.note).then((new_note) {
          print("_save" + new_note.toString());
          if (new_note.id == -1) {
            Navigator.pop(context, null);
          } else {
            Navigator.pop(context, new_note);
          }
        });
      } else {
        print(
            "SelfNoteError. NoteEditState. _save. database open failed. _bool: " +
                _bool.toString());
      }
    }).catchError((e) {
      print(
          "SelfNoteError. NewNoteWidgetState. _save. database open failed (in catch). e: " +
              e.toString());
    });
  }

  @override
  void initState() {
    print('NewNoteWidgetState initState start.');
    super.initState();
    _textEditController = new TextEditingController();
    _textEditController.addListener(onChange);
    this._categoryDatabaseProvider.initialSetUp().then((res) {
      print('initial setup complete.');
      this._categoryDatabaseProvider.get().then((res_1) {
        print('get complete. ' + res_1.toString());
        setState(() {
          this.categories = res_1;
          this.selectedCategory = this.categories[0];
          print('NewNoteWidgetState initState assigning selectedCategory. ' +
              this.selectedCategory.toString());
        });
      });
    });
    print('NewNoteWidgetState initState end.');
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
      characterCount = 1500 - _textEditController.text.toString().length;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('NewNoteWidgetState build start.');
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('New Note'),
        ),
        body: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new DropdownButton(
                        value: this.selectedCategory,
                        items: this.categories.map((Category category) {
                          return new DropdownMenuItem(
                              value: category, child: new Text(category.title));
                        }).toList(),
                        onChanged: (Category category) {
                          _categorySelected(category);
                        })),
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
                          controller: _textEditController,
                          decoration: new InputDecoration(
                            hintText: 'Enter Description',
                          ),
                        )))
              ],
            ))
          ],
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.save),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: _save));
  }
}
