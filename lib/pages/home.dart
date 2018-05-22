import 'package:flutter/material.dart';
import '../main.dart';
import './note.dart';
import './category.dart';
import 'package:path/path.dart' as _path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class HomePage extends State<SelfNote> {
  var ok;
  CategoryPage categoryPage;
  NoteWidget notePage;
  String title, databaseDirectory, databaseName;

  Future<bool> setPages() {
    return new Future<bool>(() {
      return getApplicationDocumentsDirectory().then((directory) {
        this.databaseDirectory = directory.path;
        this.databaseName = "selfnote.db";

        this.categoryPage =
            new CategoryPage(this.databaseDirectory, this.databaseName);

        this.notePage = new NoteWidget(
            _path.join(this.databaseDirectory, this.databaseName));

        this.title = "Home";

        setState(() {
          this.assignNotePage();
        });
        return true;
      }).catchError((e) {
        print("SelfNoteError. HomePage. setPages. Error: " + e.toString());
        return false;
      });
    });
  }

  assignNotePage() {
    setState(() {
      ok = this.notePage;
      title = "Note";
    });
  }

  assignCategoryPage() {
    setState(() {
      ok = this.categoryPage;
      title = "Category";
    });
  }

  HomePage() {
    this.setPages().then((result) {
      if (result != null && result is bool && result) {
        print("SelfNoteSuccess. Homepage. Constructor. setPages returned " +
            result.toString());
      } else {
        print("SelfNoteError. Homepage. Constructor. setPages returned false.");
      }
    }).catchError((e) {
      print("SelfNoteError. HomePage. Constructor. catch. Error: " +
          e.toString());
    });
  }

  void openNotePage(BuildContext context) {
    assignNotePage();
    Navigator.of(context).pop();
    //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NotePage()));
  }

  void openCategoryPage(BuildContext context) {
    assignCategoryPage();
    Navigator.of(context).pop();
  }

  void closeSideMenu(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text((title == null) ? "Home" : title),
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text("Note"),
            onTap: () {
              openNotePage(context);
            },
          ),
          new ListTile(
              title: new Text("Category"),
              onTap: () {
                openCategoryPage(context);
              }),
          new Divider(),
          new ListTile(
            title: new Text("Close"),
            trailing: new Icon(Icons.cancel),
            onTap: () {
              closeSideMenu(context);
            },
          )
        ],
      )),
      body: ok,
    );
  }
}
