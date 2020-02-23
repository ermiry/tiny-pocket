import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/providers/settings.dart';

import 'package:pocket/pages/home/charts/bars.dart';
import 'package:pocket/pages/home/charts/expenses.dart';
import 'package:pocket/pages/home/charts/history.dart';

import 'package:pocket/widgets/transactions/list.dart';
import 'package:pocket/widgets/transactions/add.dart';

import 'package:pocket/style/colors.dart';
import 'package:pocket/style/style.dart';

class HomePage extends StatefulWidget with NavigationStates {

	@override
	_HomePageState createState () => _HomePageState ();

}

class _HomePageState extends State <HomePage> {

  // List <Transaction> get _recentTransactions {
  //   return _transactions.where((tx) {
  //     return tx.date.isAfter(DateTime.now().subtract(Duration (days: 7)));
  //   }).toList();
  // }

	@override
	Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    final body = Consumer <Settings> (
      builder: (ctx, settings, _) {
        return Container (
          color: Colors.white,
          child: ListView (
            children: <Widget>[
              // FIXME: bars chart
              // _showBarsChart ? Container (
              //   height: (mediaQuery.size.height - 
              //     // appBar.preferredSize.height -
              //     mediaQuery.padding.top) * 0.3,
              //   child: BarsChart (_recentTransactions),
              // ) : Container (),

              // settings.showBarsChart ? new BarsChart (_recentTransactions) : new Container(),

              settings.showExpensesChart ? new ExpensesChart () : new Container(),

              settings.showHistoryChart ? new HistoryChart () : new Container(),

              Container(
                height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.12,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Total: ",
                      style: hoursPlayedLabelTextStyle,
                    ),
                    Text(
                      "\$${Provider.of<Transactions>(context, listen: true).getTotal.toStringAsFixed (2)}",
                      style: hoursPlayedTextStyle,
                    ),
                    Text(
                      "from",
                      style: hoursPlayedLabelTextStyle,
                    ),
                    Text(
                      "${Provider.of<Transactions>(context, listen: true).transactions.length}",
                      style: hoursPlayedTextStyle,
                    ),
                    Text(
                      "transactions",
                      style: hoursPlayedLabelTextStyle,
                    ),
                  ],
                ),
              ),

              Container (
                height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.88,
                child: new TransactionList (),
              )
            ]
          )
        );
      }
    );

		return (Platform.isAndroid ? Scaffold (
      backgroundColor: mainBlue,
			body: body,

      // TODO: set as an option
			floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
			floatingActionButton: Platform.isIOS ? Container () : FloatingActionButton (
        backgroundColor: mainBlue,
				child: Icon (Icons.add),
				onPressed: () {
					showModalBottomSheet (
						context: context, 
						builder: (bCtx) => AddTransaction ()
					);
				},
			),
		) :
    CupertinoPageScaffold (
      child: body,
    )
		);

	}

}