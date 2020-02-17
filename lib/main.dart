import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/auth.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/providers/settings.dart';

import 'package:pocket/screens/splash.dart';
import 'package:pocket/screens/auth.dart';
import 'package:pocket/screens/loading.dart';
import 'package:pocket/sidebar/sidebar_layout.dart';

void main() => runApp(new TinyPocket ());

class TinyPocket extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: new Auth(),
        ),
        ChangeNotifierProvider.value(
          value: new Transactions(),
        ),
        ChangeNotifierProvider.value(
          value: new Settings(),
        )
      ],
      child: Consumer <Auth> (
        builder: (ctx, auth, _) => Platform.isAndroid ? MaterialApp (
          title: 'Tiny Pocket',
          theme: ThemeData (
            // primarySwatch: mainBlue,
            // accentColor: mainDarkBlue,
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
          initialRoute: '/splash',
          home: auth.isAuth ? new SideBarLayout () :
            FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting ?
                  new LoadingScreen () : new AuthScreen (),
            ),
          routes: {
            '/splash': (ctx) => new SplashScreen (),
          },

          debugShowCheckedModeBanner: true,
        )

        :

        CupertinoApp (
          title: 'Tiny Pocket',
          theme: CupertinoThemeData (
            // primaryColor: Colors.blue,
            // primaryContrastingColor: Colors.redAccent,
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
        )
      ),
    );

	}

}