import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pocket/model/transaction.dart';

class TransactionList extends StatefulWidget {

	@override
	_TransactionListState createState () => _TransactionListState ();

}

class _TransactionListState extends State <TransactionList> {

	final List <Transaction> _transactions = [
		Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

	@override
	Widget build (BuildContext context) {

		return Column (
				children: _transactions.map ((tx) {
					return Card (
						child: Row (children: <Widget>[
							Container (
								margin: EdgeInsets.symmetric (vertical: 10, horizontal: 15),
								decoration: BoxDecoration (
									border: Border.all (
										color: Colors.purple,
										width: 2
									)
									),
								padding: EdgeInsets.all(10),
								child: Text (
									'\$${tx.amount}', 
									style: TextStyle (
										fontWeight: FontWeight.bold,
										fontSize: 20,
										color: Colors.purple
									)
									)
								),
							Column (
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									Text (
										tx.title,
										style: TextStyle (
											fontSize: 18,
											fontWeight: FontWeight.bold
										),
										),
									Text (
										DateFormat ().format (tx.date),
										style: TextStyle (
											color: Colors.grey
										),
										)
							],)
						],)
					);
				}).toList (),

			);
	}

}