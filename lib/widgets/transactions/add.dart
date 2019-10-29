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

            Container (
              height: 70,
              child: Row (children: <Widget>[
                Text (
                  'No date chosen!'
                ),
                FlatButton (
                  textColor: Theme.of(context).primaryColor,
                  child: Text (
                    'Choose date',
                    style: TextStyle (fontWeight: FontWeight.bold)
                    ),
                  onPressed: () {},
                )
              ],),
            ),
            
						RaisedButton (
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.accent,
							child: Text ('Add'),
							textColor: Theme.of(context).textTheme.button.color,
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