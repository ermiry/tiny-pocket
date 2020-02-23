import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/settings.dart';
import 'package:pocket/providers/transactions.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:pocket/style/colors.dart';

class SettingsPage extends StatelessWidget with NavigationStates {

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('An error ocurred!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('Success!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _clearLocalData(BuildContext context) async {
    try {
      await Provider.of<Transactions>(context, listen: false).clearTransactions();
      Navigator.of(context).pop();
      this._showSuccessDialog(context, 'Local data has been deleted!');
    }

    catch (error) {
      Navigator.of(context).pop();
      this._showErrorDialog(context, 'Failed to delete local data!');
    }
  }

  void _showConfirmDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('Are you sure?', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              this._clearLocalData(context);
            },
          )
        ],
      )
    );
  }

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

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text ('General', style: new TextStyle(fontSize: 18, color: mainDarkBlue, fontWeight: FontWeight.bold)),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Show bars chart'),
                      subtitle: const Text('Display your last week\'s activity using a bars'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.showBarsChart,
                        onChanged: (val) { 
                          settings.toggleBarsChart();
                        },)
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Show expenses chart'),
                      subtitle: const Text('Display expenses by category pie chart'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.showExpensesChart,
                        onChanged: (val) { 
                          settings.toggleExpensesChart();
                        },)
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Show history chart'),
                      subtitle: const Text('Display your last week\'s activity using a line chart'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.showHistoryChart,
                        onChanged: (val) { 
                          settings.toggleHistoryChart();
                        },)
                    ),
                  ),

                  new SizedBox(height: MediaQuery.of(context).size.height * 0.16),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text ('Danger Zone', style: new TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: const Text ('Enable cloud backup'),
                      subtitle: const Text('Backup your transactions in the cloud'),
                      trailing: Switch.adaptive (
                        activeColor: mainBlue,
                        value: settings.enableCloud,
                        onChanged: (val) { 
                          // FIXME:
                          // settings.toggleHistoryChart();
                        },)
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: Text ('Delete cloud data', style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      subtitle: const Text('Delete all the transactions and data saved in the cloud'),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: mainDarkBlue
                      ))
                    ),
                    child: ListTile(
                      title: Text ('Clear local data', style: new TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      subtitle: const Text('Clear all the transactions and data saved in this device'),
                      onTap: () => this._showConfirmDialog(context, "Delete all transactions and data saved on this device?"),
                    ),
                  ),
                ],
              ),

              // 12/02/2020 -- added to fill remaining screen and to avoid bug with sidebar
              new Expanded (child: Container (),),
            ],
          ),
        );
      },
    );
  }

}