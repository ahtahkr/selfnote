import 'package:flutter/material.dart';
import '../main.dart';
import './note.dart';
import './category.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends State<SelfNote> {

  var ok;
  CategoryPage categoryPage;
  String title, databaseDirectory, databaseName;

  setPages() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    this.databaseDirectory = documentsDirectory.path;
    this.databaseName = "selfnote.db";

    this.categoryPage = new CategoryPage(this.databaseDirectory, this.databaseName);

    this.title = "Home";
  }

  assignNotePage()
  {
    setState(() {
      ok = new NoteWidget();
      title  = "Note";
    });
  }

  assignCategoryPage()
  {
    setState(() {
      ok = this.categoryPage;
      title  = "Category";
    });
  }

  HomePage()
  {
    this.setPages();
  }

  void openNotePage(BuildContext context)
  {
    assignNotePage();
    Navigator.of(context).pop();
    //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NotePage()));
  }

  void openCategoryPage(BuildContext context)
  {
    assignCategoryPage();
    Navigator.of(context).pop();
  }

  void closeSideMenu(BuildContext context)
  {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text((title == null) ? "Home" : title),),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              title: new Text("Note"), onTap: () { openNotePage(context); },
            ),
            new ListTile(
                title: new Text("Category"), onTap: () { openCategoryPage(context); }
            ),
            new Divider(),
            new ListTile(
                title: new Text("Close"), trailing: new Icon(Icons.cancel), onTap: () { closeSideMenu(context); },
            )
          ],
        )
      ),
      body: ok,
    );
  }
}