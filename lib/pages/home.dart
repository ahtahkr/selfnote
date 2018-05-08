import 'package:flutter/material.dart';
import '../main.dart';
import './note.dart';
import './category.dart';

class HomePage extends State<SelfNote> {

  var ok;
  String title;

  assignNotePage()
  {
    setState(() {
      ok = NotePage();
      title  = "Note";
    });
  }

  assignCategoryPage()
  {
    setState(() {
      ok = CategoryPage();
      title  = "Category";
    });
  }

  HomePage()
  {
    title = "Home";
    ok = NotePage();
    title  = "Note";
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
      appBar: new AppBar(title: new Text(title),),
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