import 'package:flutter/material.dart';
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

	@override
	Widget build (BuildContext context) {

		return (Scaffold (
			appBar: AppBar (
				title: Text ('Tiny Pocket'),
			),
			body: Column (
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: <Widget>[
					Card (
						color: Colors.blue, 
						child: Text ('Chart!')
						),
					Card (child: Text ('List of TX!'))
				]
			)
		)
		);

	}

}