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
            ],
          ),

          // 12/02/2020 -- added to fill remaining screen and to avoid bug with sidebar
          new Expanded (child: Container (),),
        ],
      ),
    );
  }

}