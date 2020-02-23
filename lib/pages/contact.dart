import 'package:flutter/material.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:pocket/style/colors.dart';

class ContactPage extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Center(
                child: Text(
                  "Contact",
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
                      Text(
                        'For any questions about our service,'
                      ),
                      Text(
                        'request information, or any other inquiry,'
                      ),
                      Text(
                        'please visit:'
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ermiry.com/contact',
                        style: TextStyle(color: mainDarkBlue),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'or'
                      ),
                      SizedBox(height: 8),
                      Text(
                        'You can reach us directly here:'
                      ),
                      SizedBox(height: 8),
                      Text(
                        'contact@ermiry.com',
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
                  Text(
                    'Credits',
                    style: TextStyle(color: mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Icon made by Freepik from www.flaticon.com'
                  ),

                  const SizedBox(height: 10),

                  Text(
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