import 'package:flutter/material.dart';
import '../main.dart';
import './note.dart';
import './category.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomePage extends State<SelfNote> {

  var ok;
  CategoryPage categoryPage;
  NotePage notePage;
  String title, databaseDirectory, databaseName;

  setPages() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    this.databaseDirectory = documentsDirectory.path;
    this.databaseName = "selfnote.db";

    this.categoryPage = new CategoryPage(this.databaseDirectory, this.databaseName);
    this.notePage = new NotePage(this.databaseDirectory, this.databaseName);

    this.title = "Home";
    this.ok = this.notePage;
    this.title  = "Note";
  }

  assignNotePage()
  {
    setState(() {
      ok = this.notePage;
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

  void openNotePage()
  {
    assignNotePage();
    Navigator.of(context).pop();
    //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NotePage()));
  }

  void openCategoryPage()
  {
    assignCategoryPage();
    Navigator.of(context).pop();
  }

  void closeSideMenu()
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
              title: new Text("Note"), onTap: openNotePage,
            ),
            new ListTile(
                title: new Text("Category"), onTap: openCategoryPage
            ),
            new Divider(),
            new ListTile(
                title: new Text("Close"), trailing: new Icon(Icons.cancel), onTap: closeSideMenu,
            )
          ],
        )
      ),
      body: ok,
    );
  }
}