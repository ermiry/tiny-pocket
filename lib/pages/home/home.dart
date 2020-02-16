import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';
import 'package:pocket/style/colors.dart';

import 'package:pocket/widgets/transactions/list.dart';
import 'package:pocket/widgets/transactions/add.dart';

import 'package:pocket/pages/home/charts/bars.dart';
import 'package:pocket/pages/home/charts/expenses.dart';
import 'package:pocket/pages/home/charts/history.dart';

class HomePage extends StatefulWidget with NavigationStates {

	@override
	_HomePageState createState () => _HomePageState ();

}

class _HomePageState extends State <HomePage> {

  bool _showBarsChart = true;
  bool _showHistoryChart = true;
  bool _showExpensesChart = true;

  // List <Transaction> get _recentTransactions {
  //   return _transactions.where((tx) {
  //     return tx.date.isAfter(DateTime.now().subtract(Duration (days: 7)));
  //   }).toList();
  // }

	@override
	Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    final body = Container (
      color: Colors.white,
      child: ListView (
				children: <Widget>[

          // bars chart
          // _showBarsChart ? Container (
          //   height: (mediaQuery.size.height - 
          //     // appBar.preferredSize.height -
          //     mediaQuery.padding.top) * 0.3,
          //   child: BarsChart (_recentTransactions),
          // ) : Container (),

          this._showExpensesChart ? new ExpensesChart () : new Container(),

          this._showHistoryChart ? new HistoryChart () : new Container(),

          SizedBox(height: mediaQuery.size.height * 0.05),

          Container (
            height: (mediaQuery.size.height -
              // appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.5,
            child: TransactionList (),
            // Expanded (child: TransactionList (_transactions, _deleteTransaction))
          )
        ]
			)
    );

		return (Platform.isAndroid ? Scaffold (
      backgroundColor: mainBlue,
			body: body,

      // TODO: set as an option
			floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
			floatingActionButton: Platform.isIOS ? Container () : FloatingActionButton (
        backgroundColor: mainBlue,
				child: Icon (Icons.add),
        // FIXME:
				// onPressed: () {
				// 	showModalBottomSheet (
				// 		context: context, 
				// 		builder: (bCtx) { return AddTransaction (_addTransaction); }
				// 	);
				// },
			),
		) :
    CupertinoPageScaffold (
      child: body,
    )
		);

	}

}