import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/settings.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:pocket/style/colors.dart';

class SettingsPage extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    return Consumer <Settings> (
      builder: (ctx, settings, _) {
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
                      "Settings",
                      style: const TextStyle(
                        fontSize: 32,
                        color: mainBlue,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Show bars chart'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.showBarsChart,
                        onChanged: (val) { 
                          settings.toggleBarsChart();
                        },)
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Show expenses chart'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.showExpensesChart,
                        onChanged: (val) { 
                          settings.toggleExpensesChart();
                        },)
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Show history chart'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.showHistoryChart,
                        onChanged: (val) { 
                          settings.toggleHistoryChart();
                        },)
                    ),
                  ),
                ],
              ),

              // 12/02/2020 -- added to fill remaining screen and to avoid bug with sidebar
              new Expanded (child: Container (),)
            ],
          ),
        );
      },
    );
  }

}