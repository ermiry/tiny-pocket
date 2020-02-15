import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pocket/screens/auth.dart';

void main() => runApp(new TinyPocket ());

class TinyPocket extends StatelessWidget {

	@override
	Widget build (BuildContext context) {

		return Platform.isAndroid ? MaterialApp (
			title: 'Tiny Pocket',
      theme: ThemeData (
        primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme (
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle (fontFamily: 'Open Sans', fontSize: 20, fontWeight: FontWeight.bold)
            )
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle (
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          button: TextStyle (
            color: Colors.white
          )
        )
      ),
			home: new AuthScreen ()
		) :
    CupertinoApp (
      title: 'Tiny Pocket',
      theme: CupertinoThemeData (
        primaryColor: Colors.blue,
        primaryContrastingColor: Colors.redAccent,
        textTheme: CupertinoTextThemeData (
          textStyle: TextStyle (
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        )
      ),
			// home: HomePage ()
			home: new AuthScreen ()
    );

	}

}