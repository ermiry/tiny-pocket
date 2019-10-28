import 'package:flutter/material.dart';

import 'package:pocket/widgets/transactions/list.dart';
import 'package:pocket/widgets/transactions/add.dart';

import 'package:pocket/models/transaction.dart';

void main () => runApp (TinyPocket ());

class TinyPocket extends StatelessWidget {

	@override
	Widget build (BuildContext context) {

		return MaterialApp (
			title: 'Tiny Pocket',
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
		Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

	void _addTransaction (String title, double amount) {

		final newTx = Transaction (title: title, amount: amount, 
			date: DateTime.now (), id: DateTime.now ().toString ());

		setState(() {
			_transactions.add(newTx);
		});

	}

	@override
	Widget build (BuildContext context) {

		return (Scaffold (
			appBar: AppBar (
				title: Text ('Tiny Pocket'),
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
			),
			body: ListView (
				children: <Widget>[
						Card (
							color: Colors.blue, 
							child: Text ('Chart!')
							),

						TransactionList (_transactions)
					]
			),

			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
			floatingActionButton: FloatingActionButton (
				child: Icon (Icons.add),
				onPressed: () {
					showModalBottomSheet (
						context: context, 
						builder: (bCtx) { return AddTransaction (_addTransaction); }
					);
				},
			),
		)
		);

	}

}