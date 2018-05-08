import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends State<SelfNote> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("_HomePageState. Scaffold. appbar"),),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //new UserAccountsDrawerHeader(accountName: new Text("Note Self"), accountEmail: new Text("ahtahkr@yahoo.com")),
            new ListTile(
              title: new Text("Note"), trailing: new Icon(Icons.ac_unit)
            ),
            new ListTile(
                title: new Text("Category"), trailing: new Icon(Icons.access_alarms)
            ),
            new Divider(),
            new ListTile(
                title: new Text("Close"), trailing: new Icon(Icons.cancel)
            )
          ],
        )
      ),
      body: new Center(
        child: new Text("_HomePageState. Scaffold. body. child."),
      ),
    );
  }
}