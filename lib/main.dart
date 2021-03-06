import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocket/providers/keyboard.dart';
import 'package:pocket/providers/places.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/global.dart';
import 'package:pocket/providers/ui.dart';
import 'package:pocket/providers/auth.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/providers/categories.dart';
import 'package:pocket/providers/settings.dart';

import 'package:pocket/screens/splash.dart';
import 'package:pocket/screens/welcome.dart';
import 'package:pocket/screens/loading.dart';
import 'package:pocket/screens/auth/login.dart';
import 'package:pocket/screens/auth/register.dart';
import 'package:pocket/screens/drawer.dart';
import 'package:pocket/screens/active.dart';
import 'package:pocket/screens/recorder.dart';

import 'package:pocket/style/colors.dart';

void main() => runApp(new TinyPocket ());

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          ActiveScreen(),
        ],
      ),
    );
  }
}

class TinyPocket extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: new Global()),
        ChangeNotifierProvider.value(value: new UI()),
        ChangeNotifierProvider.value(value: new Auth()),
        ChangeNotifierProvider.value(value: new Transactions()),
        ChangeNotifierProvider.value(value: new Places()),
        ChangeNotifierProvider.value(value: new Categories()),
        ChangeNotifierProvider.value(value: new Settings()),
        ChangeNotifierProvider.value(value: new Keyboard()),
      ],
      child: Consumer <Global> (
        builder: (ctx, global, _) => MaterialApp (
          title: 'Tiny Pocket',
          theme: ThemeData (
            primaryColor: mainBlue,
            fontFamily: 'Quicksand',
            appBarTheme: AppBarTheme (
              textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle (fontFamily: 'Open Sans', fontSize: 20, fontWeight: FontWeight.bold)
                )
            ),
            textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle (
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
          home: Consumer <Auth> (
            builder: (ctx, auth, _) => global.firstTime ? new WelcomeScreen() 
              :
              auth.isAuth && auth.isFaceAuth ? new MainScreen () :
                !auth.isAuth 
                ? FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState == ConnectionState.waiting ?
                      new LoadingScreen () : new LoginScreen (),
                )
                : VideoRecorder()
          ),
          routes: {
            '/splash': (ctx) => new SplashScreen (),

            '/register': (ctx) => new RegisterScreen (),

            '/face': (ctx) => new VideoRecorder (),
          },

          debugShowCheckedModeBanner: true,
        )
      )
    );

	}

}