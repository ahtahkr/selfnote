import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {

  NoteView(){
    print('NoteView Constructor');
  }

  @override
  createState() => new NoteViewState();
}

class NoteViewState extends State<NoteView> {
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text('NoteViewState')
    );
  }
}