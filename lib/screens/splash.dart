import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

class SplashScreen extends StatefulWidget {

  static const routeName = '/splash';

  // final VoidCallback onInitializationComplete;

  const SplashScreen({
    Key key,
    // @required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  // bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    // >>> initialize async dependencies <<<
    // >>> register favorite dependency manager <<<
    // >>> reap benefits <<<

    // try {
      await Provider.of<Transactions>(context, listen: false).loadTransactions();
    // }

    // catch (error) {
    //   print('Error!');
    // }

    Future.delayed(
      Duration(milliseconds: 2000),
      // () => widget.onInitializationComplete(),
      () => Navigator.of(context).pop()
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

  // Widget _buildBody() {
  //   if (_hasError) {
  //     return Center(
  //       child: RaisedButton(
  //         child: Text('retry'),
  //         // onPressed: () => main(),
  //       ),
  //     );
  //   }
  //   return Center(
  //     child: CircularProgressIndicator(),
  //   );
  // }
}