import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {

	final Function addTransaction;

	AddTransaction (this.addTransaction);

  @override
  _AddTransactionState createState() => _AddTransactionState ();

}

class _AddTransactionState extends State <AddTransaction> {

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
							keyboardType: TextInputType.number,
						),
						FlatButton (
							child: Text ('Add'),
							textColor: Theme.of(context).primaryColor,
							onPressed: () {
                widget.addTransaction (
                  titleController.text, 
                  double.parse(amountController.text)
								);

                Navigator.of (context).pop();
              } 
              )
					],),
				),
			);

	}
}