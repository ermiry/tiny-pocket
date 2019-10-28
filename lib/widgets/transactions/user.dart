import 'package:flutter/material.dart';

import 'package:pocket/widgets/transactions/add.dart';
import 'package:pocket/widgets/transactions/list.dart';

import 'package:pocket/models/transaction.dart';

class UserTransactions extends StatefulWidget {

	@override
	_UserTransactionsState createState () => _UserTransactionsState ();

}

class _UserTransactionsState extends State <UserTransactions> {

	final List <Transaction> _transactions = [
		Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

	@override
	Widget build (BuildContext context) {

		return Column (
			children: <Widget>[
				AddTransaction (),

				TransactionList ()
			],
		);

	}

}