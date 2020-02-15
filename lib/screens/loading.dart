import 'package:flutter/material.dart';

import 'package:pocket/style/colors.dart';

class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: mainBlue,
      body: Center(
        child: Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );

  }

}