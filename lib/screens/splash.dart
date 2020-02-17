import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  
  static const routeName = '/splash';

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State <SplashScreen> {

  @override
  void initState() {
    super.initState();

    new Timer (
      new Duration(seconds: 3),
      () {
        // go the home route
        Navigator.of(context).pop();
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 248, 253, 1),
      // backgroundColor: const Color.fromRGBO(47, 54, 64, 1),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Center(
            child: new Container(
              padding: const EdgeInsets.all(32),
              child: new Image.asset('assets/img/ermiry-512.png')
            )
          )
        ],
      )
    );
  }

}
