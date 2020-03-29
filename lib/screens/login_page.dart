import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../libs/auth.dart';
import '../libs/globals.dart' as G;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(G.logo), height: 105.0,
                  alignment: Alignment.centerLeft),
              SizedBox(height: 50),
              SizedBox(height: 50),
              _signInButton("assets/logos/google.png",
                  "Sign in with Google",
                      () {
                    AuthService().signInWithGoogle().whenComplete((){});
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton(String img, String txt, Function callback) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: callback,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: SizedBox(width:250, child:Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(img), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                txt,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

