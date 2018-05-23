import 'package:sqflite/sqflite.dart';
import 'dart:async';
import './modal/category.dart';

class CategoryDatabaseProvider {
  Database db;
  String databaseFullPath;

  CategoryDatabaseProvider(String _databaseFullPath) {
    this.databaseFullPath = _databaseFullPath;
//    this.initialSetUp().then((res) {
//      print('initial setup complete.');
//      this.get().then((res_1) {
//        print('get complete');
//        for (int a = 0; a < res_1.length; a++) {
//          print(res_1[a].toString());
//        }
//      });
//    });
  }

  Future<bool> initialSetUp() {
    print("CategoryDBProvider. initialSetUp.");
    return this.open().then((res) {
      if (res != null && res is bool && res) {
        print("CategoryDBProvider. initialSetUp. DB opened.");
        return this._checkIfTableExists().then((res_1) {
          if (res_1 != null && res_1 is bool) {
            if (res_1) {
              print("CategoryDBProvider. initialSetUp. Table exists.");
              return this._checkTableCount().then((res_3) {
                if (res_3 != null && res_3 is int && res_3 >= 0) {
                  if (res_3 == 0) {
                    print("CategoryDBProvider. initialSetUp. Table is Empty.");
                    Category category = new Category();
                    category.title = "UnCategorized";
                    return this.insert(category).then((res_4) {
                      print("CategoryDBProvider. initialSetUp. Insert. " + category.toString());
                      return new Future.value(true);
                    });
                  } else {
                    print("CategoryDBProvider. initialSetUp. Table is NotEmpty.");
                    return new Future.value(false);
                  }
                } else { return new Future.value(false);}
              });
            }else {
              print("CategoryDBProvider. initialSetUp. Table does not exists.");
              return this.createTable().then((res_2) {
                if (res_2 != null && res_2 is bool) {
                  print("CategoryDBProvider. initialSetUp. Table created.");
                  Category category = new Category();
                  category.title = "UnCategorized";
                  return this.insert(category).then((res_4) {
                    print("CategoryDBProvider. initialSetUp. Insert. " + category.toString());
                    return new Future.value(false);
                  });
                } else {
                  print("CategoryDBProvider. initialSetUp. Table create unsuccessful.");
                return new Future.value(false);
                }
              }).catchError((e) { return new Future.value(false);});
            }
          } else { return new Future.value(false);}
        });
      } else { return new Future.value(false);}
    });
  }

  Future<bool> open() {
    print("CategoryDBProvider. Open.");
    if (this.databaseFullPath != null && this.databaseFullPath.isNotEmpty) {
      return openDatabase(this.databaseFullPath, version: 1,
          onCreate: (Database database, int version) {
            print("CategoryDBProvider. Open. onCreate.");
          }).then((database) {
        db = database;
        print(
            "CategoryDBProvider. Open. database assigned. db.path: " + db.path);
        return new Future.value(true);
      }).catchError((e) {
        print("CategoryDBProvider. Open. Error: " + e.toString());
        return new Future.value(false);
      });
    } else {
      print(
          "CategoryDBProvider. Open. DatbaseFullPath variable not assigned yet.");
      return new Future.value(false);
    }
  }

  Future<bool> _checkIfTableExists() {
    print("CategoryDBProvider. _checkIfTableExists. query: [" +this._getCheckTableQuery()+ "]");

    return this.db.rawQuery(this._getCheckTableQuery()).then((result) {
        print("CategoryDBProvider. _checkIfTableExists. result:" +
            result.toString());
        if (result != null && result.toString().length > 0) {
          String abcd = result.toString();
          if (abcd.contains("$tableName")) {
            print("CategoryDBProvider. _checkIfTableExists. returning true.");
            return new Future.value(true);
          } else {
            print("CategoryDBProvider. _checkIfTableExists. returning false.");
            return new Future.value(false);
          }
        } else {
          print("CategoryDBProvider. _checkIfTableExists. returning false.");
          return new Future.value(false);
        }
      });
  }

  Future<bool> createTable() {
    print("CategoryDBProvider. CreateTable.");

          return this
              .db
              .execute(this._getCreateTableQuery().toString())
              .then((one) {
            print(
                "CategoryDBProvider. createTable. Create table Successful. Create Query: " +
                    this._getCreateTableQuery());
            return new Future.value(true);
          }).catchError((e) {
            print("CategoryDBProvider. createTable. Error: " + e.toString());
            return new Future.value(false);
          });

  }

  Future<int> _checkTableCount() {
    print("CategoryDBProvider. _checkTableCount.");
      return this.db.rawQuery(this._getCheckTableCountQuery()).then((result) {
        print("CategoryDBProvider. _checkTableCount. result:" +
            result.toString());
        if (result != null &&
            result.toString().length > 0 &&
            result.toString().contains(":")) {
          String count = result.toString().split(':')[1].split('}')[0].trim();
          int a = int.parse(count);
          return new Future.value(a);
          /*if (a == 0) {
            Category category = new Category();
            category.title = "UnCategorized";
            return this.insert(category).then((onValue) {
              return 1;
            }).catchError((e) {
              return -1;
            });
          } else {
            return a;
          }*/
        } else {
          return  new Future.value(0);
        }
      }).catchError((e) {
        print("CategoryDBProvider. _checkTableCount. Error: " + e.toString());
        return  new Future.value(-1);
      });
  }

  Future<Category> insert(Category category) {
    print("CategoryDBProvider. Insert. category: " + category.toString());
    return db.insert(tableName, category.toMap()).then((res) {
    category.id = res;
    print("CategoryDBProvider. Insert. Successful. " + category.toString());
    return category;
    }).catchError((e) {
    print("CategoryDBProvider. Insert. UnSuccessful. Error: " + e.toString());
    return category;
    });
  }

  Future<List<Category>> get() {
    print("Category db provider");
    print("Category db provider. get.");
    return db.query(tableName, columns: [columnId, columnTitle]).then((res) {
      print("Category db provider. get. then " + res.length.toString());
      if (res.length > 0) {
        List<Category> categories = new List<Category>();
        for (int a = 0; a < res.length; a++) {
          categories.add(new Category.fromMap(res[a]));
        }
        return new Future.value(categories);
      } else {
        return new Future.value(new List<Category>());
      }
    }).catchError((e) {
      print("Category db provider. get. catchError. " + e.toString());
      return new Future.value(new List<Category>());
    });
  }

  Future<int> update(Category category) {
    print("CategoryDBProvider. update. got: " + category.toString());
    return db.update(tableName, category.toMap(),
        where: "$columnId = ?", whereArgs: [category.id]).then((res) {
      print("CategoryDBProvider. update. after update: " + res.toString());
      /*res = 1. if update successful.*/
      if (res == 1) {
        return new Future.value(category.id);
      } else {
        return new Future.value(-1);
      }
    }).catchError((e) {
      print(e.toString());
      return new Future.value(-1);
    });
  }

  Future<Category> getCategory(int id) {
    if (id != null) {
      print("CategoryDBProvider. getCategory. id: " + id.toString());
      return db
          .query(tableName,
          columns: [
            columnId,
            columnTitle
          ],
          where: "$columnId = ?",
          whereArgs: [id])
          .then((result) {
        print(result.toString());
        if (result.length > 0) {
          return new Future.value(new Category.fromMap(result.first));
        } else {
          return new Future.value(null);
        }
      });
    } else {
      print("CategoryDBProvider. getCategory. id is null. id: " + id.toString());
      return new Future.value(null);
    }
  }

  String _getCheckTableQuery() {
    return "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'";
  }

  String _getCreateTableQuery() {
    return "create table $tableName($columnId integer primary key autoincrement,$columnTitle text not null UNIQUE)";
  }

  String _getCheckTableCountQuery() {
    return "SELECT count(*) count_ FROM '$tableName'";
  }
}
/*


  Future<List<Category>> get() {
    print("Category db provider");
    print("Category db provider. get.");
    return db.query(tableName, columns: [columnId, columnTitle]).then((res) {
      print("Category db provider. get. then " + res.length.toString());
      if (res.length > 0) {
        List<Category> categories = new List<Category>();
        for (int a = 0; a < res.length; a++) {
          categories.add(new Category.fromMap(res[a]));
        }
        return categories;
      } else {
        return new List<Category>();
      }
    }).catchError((e) {
      print("Category db provider. get. catchError. " + e.toString());
      return new List<Category>();
    });
  }





Future<bool> initialSetUp() {
    return this.open().then((res) {
      if (res) {
        this.createTable().then((res_1) {
          if (res_1) {
            this._checkTableCount().then((res_2) {
              if (res_2 != null && res_2 is int && res_2 > 0) {
                return true;
              }
            });
          } else {
            return false;
          }
        });
      } else {
        return false;
      }
    });
  }

  Future<bool> setUpDatabase() {
    print("CategoryDBProvider. SetUpDatabase.");
    return this.get().then((res) {
      if (res != null) {
        if (res.length == 0) {
          print("CategoryDBProvider. SetUpDatabase. Category Table is empty.");
          Category category = new Category();
          category.title = "UnCategorized";
          return this.insert(category).then((category) {
            print("CategoryDBProvider. SetUpDatabase. Insert successful.");
            return true;
          }).catchError((e) {
            print(e.toString());
            return false;
          });
        } else {
          print("CategoryDBProvider. SetUpDatabase. Category Table is not empty");
          return true;
        }
      } else {
        print("CategoryDBProvider. SetUpDatabase. Get() returned null." +
            res.toString());
        return false;
      }
    });
  }









  Future<int> update(Category category) {
    print("CategoryDBProvider. update. got: " + category.toString());
    return db.update(tableCategory, category.toMap(),
        where: "$columnId = ?", whereArgs: [category.id]).then((res) {
      print("CategoryDBProvider. update. after update: " + res.toString());
      /*res = 1. if update successful.*/
      if (res == 1) {
        return category.id;
      } else {
        return -1;
      }
    }).catchError((e) {
      print(e.toString());
      return -1;
    });
  }

  Future<Category> insertUpdate(Category category) {
    return this.getCategory(category.id).then((res) {
      print("CategoryDBProvider. insertUpdate. got: " + res.toString());
      if (res != null && res is Category) {
        return this.update(category).then((res_1) {
          print("CategoryDBProvider. insertUpdate. update: " + res_1.toString());

          return category;
        }).catchError((e) {
          print(e.toString());
          category.id = -1;
          return category;
        });
      } else {
        return this.insert(category).then((res_one) {
          print("CategoryDBProvider. insertUpdate. insert: " + res_one.toString());
          return res_one;
        }).catchError((e) {
          print(e.toString());
          return null;
        });
      }
    }).catchError((e) {
      print(e.toString());
      return null;
    });
  }

  Future<int> delete(int id) {
    return db
        .delete(tableCategory, where: "$columnId = ?", whereArgs: [id]).then((res) {
      print("CategoryDBProvider. delete. successful. result:" + res.toString());
      if (res == 1) {
        return id;
      } else {
        print("CategoryDBProvider. delete. More than one row was deleted. res: " +
            res.toString());
        return -1;
      }
    }).catchError((e) {
      print("CategoryDBProvider. delete. error (in catch) e: " + e.toString());
      return -1;
    });
  }
*/

/*

Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();

*/
