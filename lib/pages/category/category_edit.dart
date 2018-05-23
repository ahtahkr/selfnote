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
  createState() => new CategoryEditState(this._category, this._databaseFullPath);
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
    this._categoryDatabaseProvider = new CategoryDatabaseProvider(databaseFullPath);
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

  static const List<IconData> _icons = const [Icons.save, Icons.delete, Icons.cancel];
  static const List<Color> _backgroundColor = const [
    Colors.green , Colors.red, Colors.orange
  ];
  Color _foregroundColor = Colors.white;
  _function(int index) {
    if (index != null) {
      if (index == 1) {
        this._categoryDatabaseProvider.open().then((result) {
          if (result != null && result is bool && result) {
            this._categoryDatabaseProvider.delete(this._category.id).then((result_one) {
              if (result_one != null && result_one is int) {
                Navigator.pop(context, result_one);
              } else {
                print("SelfcategoryError. categoryViewState. _function. index[" +
                    index.toString() +
                    "] database delete failed. result_one: " +
                    result_one.toString());
              }
            }).catchError((e) {
              print("SelfcategoryError. categoryViewState. _function. index[" +
                  index.toString() +
                  "] database delete failed. e: " +
                  e.toString());
            });
          } else {
            print("SelfcategoryError. categoryViewState. _function. index[" +
                index.toString() +
                "] database open failed. _bool: " +
                result.toString());
          }
        }).catchError((e) {
          print("SelfcategoryError. categoryViewState. _function. index[" +
              index.toString() +
              "] database open failed (in catch). e: " +
              e.toString());
        });
      }
      else if (index == 0) {
        this._category.title = this._textEditingController.value.text.toString();
        this._categoryDatabaseProvider.open().then((_bool) {
          if (_bool) {
            this._categoryDatabaseProvider.update(this._category).then((res) {
              if (res != null && res is int && res > 0) {
                Navigator.pop(context, res);
              } else {
                print("SelfCategoryError. CategoryEditState. _function. index[" +
                    index.toString() +
                    "] databaseupdate returned error. res: " +
                    res.toString());
              }
            }).catchError((e) {
              print("SelfCategoryError. CategoryEditState. _function. index[" +
                  index.toString() +
                  "] databaseupdate returned error (in catch). e: " +
                  e.toString());
            });
          } else {
            print("SelfCategoryError. CategoryEditState. _function. index[" +
                index.toString() +
                "] database open failed. _bool: " +
                _bool.toString());
          }
        }).catchError((e) {
          print("SelfCategoryError. CategoryEditState. _function. index[" +
              index.toString() +
              "] database open failed (in catch). e: " +
              e.toString());
        });
      } else if (index == 2) {
        Navigator.pop(context, -1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Category Edit"),
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
