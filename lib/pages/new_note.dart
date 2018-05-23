import 'package:flutter/material.dart';
import '../database/note_database_provider.dart';
import '../database/category_database_provider.dart';
import '../database/modal/category.dart';
import 'dart:math' as math;

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
  AnimationController _controller;
  Note note;
  static const List<IconData> icons = const [Icons.save, Icons.cancel];
  static const List<Color> _backgroundColor = const [
    Colors.green,
    Colors.orange
  ];
  NewNoteWidgetState(String databaseFullPath) {
    this._noteDatabaseProvider = new NoteDatabaseProvider(databaseFullPath);
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
    this.note = new Note();
    this.categories = new List();
  }
  void _cancel() {
    Navigator.pop(context, false);
  }

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
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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

  _dismissKeyboard() {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      String mes = this._textEditController.value.text;
      FocusScope.of(context).requestFocus(new FocusNode());
      this._textEditController.text = mes;
    }
  }

  _function(int index) {
    if (index != null) {
      if (index == 0) {
        this._save();
      } else if (index == 1) {
        this._cancel();
      }
    }
    print(index);
  }

  _categorySelected(Category category) {
    setState(() {
      this.selectedCategory = category;
      print('categorySelected a: ' + category.toString());
      print('categorySelected b: ' + this.selectedCategory.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print('NewNoteWidgetState build start.');
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
        body: new Column(children: <Widget>[
          new ListTile(
            leading: const Icon(Icons.category),
          title: const Text('Category'),
          trailing:
          new DropdownButton(
              isDense: true,
              value: this.selectedCategory,
              items: this.categories.map((Category category) {
                return new DropdownMenuItem(
                    value: category, child: new Text(category.title));
              }).toList(),
              onChanged: (Category category) {
                _categorySelected(category);
              })),
          new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new TextField(
                decoration: inputDecoration,
                maxLines: null,
                autofocus: true,
                controller: _textEditController,
              ))
        ]),
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
