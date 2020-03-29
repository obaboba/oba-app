import 'package:flutter/material.dart';

class TopBar extends AppBar {
  TopBar(BuildContext context) : super (
    backgroundColor: new Color(0xfff8faf8),
    centerTitle: true,
    elevation: 1.0,
    //leading: new Icon(Icons.camera_alt),
    title: SizedBox(height: 45.0, child: Image.asset("assets/logos/oba_pink.png")),
    //actions: <Widget>[
    //  Padding(
    //    padding: const EdgeInsets.only(right: 12.0),
    //    child: Icon(Icons.send),
    //  )
    //],
  );
}