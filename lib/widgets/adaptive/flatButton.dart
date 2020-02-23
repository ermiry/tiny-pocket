import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pocket/style/colors.dart';

class AdaptiveFlatButton extends StatelessWidget {

  final String text;
  final Function handler;

  AdaptiveFlatButton (this.text, this.handler);

  @override
  Widget build (BuildContext context) {

    return Platform.isAndroid ? FlatButton (
      child: Text (
        this.text,
        style: const TextStyle(
          fontSize: 18,
          color: mainBlue,
          fontWeight: FontWeight.bold,
        )
        ),
      onPressed: this.handler
    ) :
    CupertinoButton (
      child: Text (
        this.text,
        style: TextStyle (fontWeight: FontWeight.bold)
      ),
      onPressed: this.handler,
    );

  }

}