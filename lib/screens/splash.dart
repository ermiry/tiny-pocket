import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  
  static const routeName = '/splash';

  final int seconds = 3;
  final Color backgroundColor = Colors.white;
  // final Gradient gradientBackground;

  final Image image = new Image.asset('assets/img/ermiry-512.png');
  final double imageSize = 512;

  // final Text title;
  // final Text loadingText;

  // final dynamic navigateAfterSeconds;

  // SplashScreen (
  //   {
  //     @required this.seconds,
  //     this.backgroundColor = Colors.white,
  //     this.gradientBackground,
  //     this.image,
  //     this.imageSize,
  //     this.title = const Text(''),
  //     this.loadingText  = const Text(""),
  //     this.navigateAfterSeconds,
  //   }
  // );

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State <SplashScreen> {

  @override
  void initState() {
    super.initState();

    new Timer (
      new Duration(seconds: widget.seconds),
      () {
        // go the home route
        Navigator.of(context).pop();
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              // gradient: widget.gradientBackground,
              color: widget.backgroundColor,
            ),
          ),

          new Center(
            child: widget.image
          )

          // new Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: <Widget>[
          //     new Expanded(
          //       flex: 2,
          //       child: new Container(
          //         child: new Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: <Widget>[
          //             new CircleAvatar(
          //               backgroundColor: Colors.transparent,
          //               child: new Container(
          //                 child: widget.image
          //               ),
          //               // radius: widget.imageSize,
          //             ),
          //             new Padding(
          //               padding: const EdgeInsets.only(top: 35.0),
          //             ),
          //             // widget.title
          //           ],
          //         )
          //       ),
          //     ),
          //   ],
          // ),
        ],
      )
    );
  }

}
