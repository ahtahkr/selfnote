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
  AnimationController _controller;
  Category category;

  static const List<IconData> icons = const [Icons.save, Icons.cancel];
  static const List<Color> _backgroundColor = const [
    Colors.green,
    Colors.orange
  ];

  NewCategoryWidgetState(String databaseFullPath) {
    this._categoryDatabaseProvider =
        new CategoryDatabaseProvider(databaseFullPath);
    this.category = new Category();
  }

  void _cancel() {
    Navigator.pop(context, false);
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
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = Colors.white;

    InputDecoration inputDecoration;
    if (category.title != null && category.title.length > 0) {
      this._textEditController.text = category.title.toString();
    } else {
      inputDecoration = new InputDecoration(hintText: 'Enter Description');
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("This is the new category widget."),
          automaticallyImplyLeading: false,
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
