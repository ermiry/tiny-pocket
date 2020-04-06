import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:pocket/style/colors.dart';

import 'package:pocket/version.dart';

class AboutPage extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),

              Center(
                child: Text(
                  "About",
                  style: const TextStyle(
                    fontSize: 24,
                    color: mainBlue,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Tiny Pocket Mobile App',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainDarkBlue),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'Version $version_number -- $version_date',
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'To learn more about Tiny Pocket,'
              ),
              const Text('check out the official website:'),
              const SizedBox(height: 10),
              const Text(
                'pocket.ermiry.com',
                style: TextStyle(color: mainDarkBlue),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Contact',
                style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'For any questions about our service,'
              ),
              const Text(
                'request information, or any other inquiry,'
              ),
              const Text(
                'please visit:'
              ),
              const SizedBox(height: 8),
              const Text(
                'ermiry.com/contact',
                style: TextStyle(color: mainDarkBlue),
              ),
              const SizedBox(height: 8),
              const Text(
                'or'
              ),
              const SizedBox(height: 8),
              const Text(
                'You can reach us directly here:'
              ),
              const SizedBox(height: 8),
              const Text(
                'contact@ermiry.com',
                style: TextStyle(color: mainDarkBlue),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Legal',
                style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Privacy Policy'
              ),
              const SizedBox(height: 8),
              const Text(
                'ermiry.com/privacy-policy',
                style: TextStyle(color: mainDarkBlue),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Text(
                'Credits',
                style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'Icon made by Freepik from www.flaticon.com'
              ),
            ],
          ),

          new Spacer (),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Copyright \u00a9 2020 Ermiry',
                style: TextStyle(color: mainBlue),
              ),

              SizedBox(height: 20),
            ],
          )
        ],
      ),
    );
  }

}