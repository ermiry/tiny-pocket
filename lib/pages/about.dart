import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:pocket/style/colors.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              const Center(
                child: Text(
                  "About",
                  style: const TextStyle(
                    fontSize: 32,
                    color: mainBlue,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
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
                    ],
                  )
                ),
              )
            ],
          ),

          // 12/02/2020 -- added to fill remaining screen and to avoid bug with sidebar
          new Expanded (child: Container (),),

          Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  const Text(
                    'Credits',
                    style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Icon made by Freepik from www.flaticon.com'
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Copyright \u00a9 2020 Ermiry',
                    style: TextStyle(color: mainBlue),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              )
            ),
          )
        ],
      ),
    );
  }

}