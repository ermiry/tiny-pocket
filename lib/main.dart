import 'package:flutter/material.dart';

import 'package:pocket/widgets/transactions.dart';

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

					TransactionList ()

				]
			)
		)
		);

	}

}