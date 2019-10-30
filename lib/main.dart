import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:pocket/widgets/transactions/list.dart';
import 'package:pocket/widgets/transactions/add.dart';
import 'package:pocket/widgets/chart/chart.dart';

import 'package:pocket/models/transaction.dart';

void main () {

  // only allow portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp (TinyPocket ());

} 

class TinyPocket extends StatelessWidget {

	@override
	Widget build (BuildContext context) {

		return Platform.isAndroid ? MaterialApp (
			title: 'Tiny Pocket',
      theme: ThemeData (
        primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
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
			home: HomePage ()
		) :
    CupertinoApp (
      title: 'Tiny Pocket',
      theme: CupertinoThemeData (
        primaryColor: Colors.blue,
        primaryContrastingColor: Colors.redAccent,
        textTheme: CupertinoTextThemeData (
          textStyle: TextStyle (
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.bold
          )
        )
      ),
			home: HomePage ()
    );

	}

}

// FIXME: we need to refactor this using a better solution to avoid having
// a state in the main class
class HomePage extends StatefulWidget {

	@override
	_HomePageState createState () => _HomePageState ();

}

class _HomePageState extends State <HomePage> {

	final List <Transaction> _transactions = [
		// Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		// Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

  bool _showChart = true;

  List <Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration (days: 7)));
    }).toList();
  }

	void _addTransaction (String title, double amount, DateTime date) {

		final newTx = Transaction (title: title, amount: amount, 
			date: date, id: DateTime.now().toString());

		setState(() {
			_transactions.add(newTx);
		});

	}

  void _deleteTransaction (String id) {

    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });

  }

	@override
	Widget build (BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    final PreferredSizeWidget appBar = Platform.isAndroid ? AppBar (
				title: Text (
          'Tiny Pocket',
          // style: TextStyle (fontFamily: 'Open Sans'),
          ),
				actions: <Widget>[
					IconButton (
						icon: Icon (Icons.add),
						onPressed: () {
							showModalBottomSheet (
								context: context, 
								builder: (bCtx) { return AddTransaction (_addTransaction); }
							);
						},
					)
				],
			)
      : CupertinoNavigationBar (
        middle: Text ('Tiny Pocket'),
        trailing: Row (
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          GestureDetector (
            child: Icon (CupertinoIcons.add),
            onTap: () {
              showModalBottomSheet (
								context: context, 
								builder: (bCtx) { return AddTransaction (_addTransaction); }
							);
            },
          )
        ]),
      );

    final appBody = SafeArea (
      child: ListView (
				children: <Widget>[
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text ('Show chart'),
            Switch.adaptive (
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) { 
                setState(() {
                  _showChart = val;
                });
              },)
          ],),

          _showChart ? Container (
            height: (mediaQuery.size.height - 
              appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.3,
            child: Chart (_recentTransactions),
          ) : Container (),

          Container (
            height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.7,
            child: TransactionList (_transactions, _deleteTransaction),
            // Expanded (child: TransactionList (_transactions, _deleteTransaction))
          )
        ]
			)
    );

		return (Platform.isAndroid ? Scaffold (
			appBar: appBar,
			body: appBody,

			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
			floatingActionButton: Platform.isIOS ? Container () : FloatingActionButton (
				child: Icon (Icons.add),
				onPressed: () {
					showModalBottomSheet (
						context: context, 
						builder: (bCtx) { return AddTransaction (_addTransaction); }
					);
				},
			),
		) :
    CupertinoPageScaffold (
      navigationBar: appBar,
      child: appBody,
    )
		);

	}

}