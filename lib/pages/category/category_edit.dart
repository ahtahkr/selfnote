import 'package:flutter/material.dart';
import '../../database/category_database_provider.dart';
import '../../database/modal/category.dart';
import 'dart:math' as math;

class CategoryEditWidget extends StatefulWidget {
  final Category _category;
  final String _databaseFullPath;

  CategoryEditWidget(Category category, String databaseFullPath)
      : this._category = category,
        this._databaseFullPath = databaseFullPath {
    print('CategoryView Constructor');
  }

  @override
  createState() =>
      new CategoryEditState(this._category, this._databaseFullPath);
}

class CategoryEditState extends State<CategoryEditWidget>
    with TickerProviderStateMixin {
  Category _category;
  TextEditingController _textEditingController;
  AnimationController _controller;
  CategoryDatabaseProvider _categoryDatabaseProvider;

  CategoryEditState(Category category, String databaseFullPath) {
    this._category = category;
    this._textEditingController = new TextEditingController();
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
  }

  @override
  void initState() {
    super.initState();
    this._textEditingController.text = this._category.title.toString();
    this._controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  _delete() {
    this._categoryDatabaseProvider.open().then((result) {
      if (result != null && result is bool && result) {
        this
            ._categoryDatabaseProvider
            .delete(this._category.id)
            .then((result_one) {
          if (result_one != null && result_one is int) {
            Navigator.pop(context, result_one);
          } else {
            print(
                "SelfcategoryError. categoryViewState. _delete database delete failed. result_one: " +
                    result_one.toString());
          }
        }).catchError((e) {
          print(
              "SelfcategoryError. categoryViewState. _delete database delete failed. e: " +
                  e.toString());
        });
      } else {
        print(
            "SelfcategoryError. categoryViewState. _delete database open failed. _bool: " +
                result.toString());
      }
    }).catchError((e) {
      print(
          "SelfcategoryError. categoryViewState. _delete database open failed (in catch). e: " +
              e.toString());
    });
  }

  _save() {
    this._category.title = this._textEditingController.value.text.toString();
    this._categoryDatabaseProvider.open().then((_bool) {
      if (_bool) {
        this._categoryDatabaseProvider.update(this._category).then((res) {
          if (res != null && res is int && res > 0) {
            Navigator.pop(context, res);
          } else {
            print(
                "SelfCategoryError. CategoryEditState. _save. databaseupdate returned error. res: " +
                    res.toString());
          }
        }).catchError((e) {
          print(
              "SelfCategoryError. CategoryEditState. _save. databaseupdate returned error (in catch). e: " +
                  e.toString());
        });
      } else {
        print(
            "SelfCategoryError. CategoryEditState. _save. database open failed. _bool: " +
                _bool.toString());
      }
    }).catchError((e) {
      print(
          "SelfCategoryError. CategoryEditState. _save. database open failed (in catch). e: " +
              e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Category Edit"), actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.delete),
              splashColor: Colors.red,
              onPressed: () {
                this._delete();
              },
              tooltip: 'Delete')
        ]),
        body: new Center(
            child: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new TextField(
            maxLines: null,
            enabled: true,
            controller: _textEditingController,
          ),
        )),
        floatingActionButton: new FloatingActionButton(
            onPressed: () {
              this._save();
            },
            child: new Icon(Icons.save),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white));
  }
}
