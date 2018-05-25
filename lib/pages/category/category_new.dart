import 'package:flutter/material.dart';
import '../../database/category_database_provider.dart';
import '../../database/modal/category.dart';
import 'dart:math' as math;

class NewCategoryWidget extends StatefulWidget {
  final String _databaseFullPath;

  NewCategoryWidget(String databaseFullPath)
      : this._databaseFullPath = databaseFullPath;

  @override
  createState() => new NewCategoryWidgetState(this._databaseFullPath);
}

class NewCategoryWidgetState extends State<NewCategoryWidget>
    with TickerProviderStateMixin {
  TextEditingController _textEditController;
  CategoryDatabaseProvider _categoryDatabaseProvider;
  Category category;

  NewCategoryWidgetState(String databaseFullPath) {
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
    this.category = new Category();
  }

  void _save() {
    print(_textEditController.value.text.toString());
    this.category.title = _textEditController.value.text.toString();

    this._categoryDatabaseProvider.open().then((_bool) {
      if (_bool) {
        this
            ._categoryDatabaseProvider
            .insert(this.category)
            .then((newCategory) {
          print("_save" + newCategory.toString());
          if (newCategory.id == -1) {
            Navigator.pop(context, null);
          } else {
            Navigator.pop(context, newCategory);
          }
        });
      } else {
        print(
            "SelfCategoryError. CategoryEditState. _save. database open failed. _bool: " +
                _bool.toString());
      }
    }).catchError((e) {
      print(
          "SelfCategoryError. NewCategoryWidgetState. _save. database open failed (in catch). e: " +
              e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration;
    if (category.title != null && category.title.length > 0) {
      this._textEditController.text = category.title.toString();
    } else {
      inputDecoration = new InputDecoration(hintText: 'Enter Description');
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("New Category"),
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
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              this._save();
            },
            child: new Icon(Icons.save),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white));
  }
}
