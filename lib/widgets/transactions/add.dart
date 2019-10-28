import 'package:flutter/material.dart';

class AddTransaction extends StatelessWidget {

	// String titleInput;
	// String amountInput;

	final titleController = TextEditingController ();
	final amountController = TextEditingController ();

	@override
	Widget build (BuildContext context) {

		return Card (
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
			);

	}

}