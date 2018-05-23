import 'package:flutter/material.dart';
import '../database/category_database_provider.dart';
import '../database/modal/category.dart';
import './category/category_new.dart';

class CategoryWidget extends StatefulWidget {
  final String databaseFullPath;

  CategoryWidget(String _databaseFullPath)
      : this.databaseFullPath = _databaseFullPath;

  @override
  createState() => new CategoryState(this.databaseFullPath);
}

class CategoryState extends State<CategoryWidget> {
  List<Category> categories = new List();
  CategoryDatabaseProvider categoryDatabaseProvider;

  CategoryState(String _databaseFullPath)
      : this.categoryDatabaseProvider = new CategoryDatabaseProvider(_databaseFullPath);

  @override
  void initState() {
    super.initState();
    this.categoryDatabaseProvider.initialSetUp().then((res) {
      print('initial setup complete.');
      this.categoryDatabaseProvider.get().then((res_1) {
        print('get complete. ' + res_1.toString());
        setState(() {
          this.categories = res_1;
        });
      });
    });
  }
/*
  void _categoryView(Category category) {
    Navigator
        .push(
        context,
        new MaterialPageRoute(
            builder: (context) => new NoteView(
                category, this.categoryDatabaseProvider.databaseFullPath)))
        .then((result) {
      if (result != null && result is int && result > 0) {
        this.categoryDatabaseProvider.getNote(result).then((res) {
          if (res != null && res is Category && res.message.length > 0) {
            bool _found = false;
            int a;
            for (a = 0; a < this.categorys.length; a++) {
              if (this.categorys[a].id == res.id) {
                print("SelfNoteSuccess. NoteWidgetState. _categoryView. category: [" +
                    result.toString() +
                    "] found in this.categorys list.");
                _found = true;
                setState(() {
                  this.categorys[a].message = res.message;
                });
              }
            }
            if (a >= this.categorys.length && !_found) {
              print("SelfNoteError. NoteWidgetState. _categoryView. category: [" +
                  result.toString() +
                  "] not found in this.categorys list.");
            }
          } else if (res == null) {
            for (int a = 0; a < this.categorys.length; a++) {
              if (this.categorys[a].id == result) {
                setState(() {
                  this.categorys.removeAt(a);
                });
              }
            }
          } else {
            print(
                "SelfNoteError. NoteWidgetState. _categoryView. Invalid res received. res: " +
                    result.toString() +
                    ".");
          }
        }).catchError((e) {});
      } else if (result == -1) {
        /* Cancelled in NoteView */
      } else {
        print(
            "SelfNoteError. NoteWidgetState. _categoryView. Invalid result received. result: " +
                result +
                ". category: " +
                category.toString());
      }
    });
  }
*/

  void _newCategory() {
    Navigator
        .push(
        context,
        new MaterialPageRoute(
            builder: (context) => new NewCategoryWidget(
                this.categoryDatabaseProvider.databaseFullPath)))
        .then((result) {
      if (result != null && result is Category && result.title.length > 0) {
        if (this.categories.length > 0) {
          bool contains = false;
          for (int a = 0; a < this.categories.length; a++) {
            if (this.categories[a].id == result.id) {
              setState(() {
                this.categories[a].title = result.title;
              });
              contains = true;
            }
            if (a >= (this.categories.length - 1) && !contains) {
              setState(() {
                this.categories.add(result);
              });
            }
          }
        } else {
          setState(() {
            this.categories.add(result);
          });
        }
      }
    });
  }

  Widget _buildRow(Category _category, BoxDecoration boxDecoration) {
    return new Container(
        decoration: boxDecoration,
        child: new ListTile(
          /*onTap: () {
            this._categoryView(_category);
          },*/
          dense: true,
          title: new Text(
            ((_category.title != null && _category.title.isNotEmpty)
                ? _category.title
                : "Undefined"),
            maxLines: 5,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          BoxDecoration boxDecoration;
          if (index % 2 == 0) {
            boxDecoration = new BoxDecoration(color: Colors.grey[200]);
          } else {
            boxDecoration = new BoxDecoration(color: Colors.transparent);
          }
          return _buildRow(categories[index], boxDecoration);
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _newCategory();
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
