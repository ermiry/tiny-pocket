import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pocket/transaction.dart';

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

class HomePage extends StatelessWidget {

	final List <Transaction> transactions = [
		Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

	// String titleInput;
	// String amountInput;

	final titleController = TextEditingController ();
	final amountController = TextEditingController ();

	@override
	Widget build (BuildContext context) {

		return (Scaffold (
			appBar: AppBar (
				title: Text ('Tiny Pocket'),
			),
			body: Column (
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: <Widget>[
					Card (
						color: Colors.blue, 
						child: Text ('Chart!')
						),

					Card (
						elevation: 5,
						child: Container (
							padding: EdgeInsets.all(10),
							child: Column (children: <Widget>[
								TextField (
									decoration: InputDecoration (labelText: 'Title'),
									// onChanged: (val) => titleInput = val,
									controller: titleController,
								),
								TextField (
									decoration: InputDecoration (labelText: 'Amount'),
									// onChanged: (val) => amountInput = val,
									controller: amountController,
								),
								FlatButton (
									child: Text ('Add'),
									textColor: Colors.purple,
									onPressed: () {},
									)
							],),
						),
					),

					Column (
						children: transactions.map ((tx) {
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
					)
				]
			)
		)
		);

	}

}