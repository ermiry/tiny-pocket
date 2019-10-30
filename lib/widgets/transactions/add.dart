// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {

	final Function addTransaction;

	AddTransaction (this.addTransaction);

  @override
  _AddTransactionState createState() => _AddTransactionState ();

}

class _AddTransactionState extends State <AddTransaction> {

	final _titleController = TextEditingController ();
	final _amountController = TextEditingController ();

  DateTime _selectedDate;

	@override
	Widget build (BuildContext context) {

    // TODO: maybe add an improved modal bottom sheet dialog, see custom widget snippet (125)
		return SingleChildScrollView (
		  child: Card (
		  		elevation: 5,
		  		child: Container (
		  			padding: EdgeInsets.only(
            top: 10, 
            left: 10, 
            right: 10, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
		  			child: Column (children: <Widget>[
            TextField (
		  					decoration: InputDecoration (labelText: 'Title'),
		  					// onChanged: (val) => titleInput = val,
		  					controller: _titleController,
            ),
            TextField (
		  					decoration: InputDecoration (labelText: 'Amount'),
		  					// onChanged: (val) => amountInput = val,
		  					controller: _amountController,
		  					keyboardType: TextInputType.number,
            ),

            Container (
              height: 70,
              child: Row (children: <Widget>[
                Expanded (
                  child: Text (
                    _selectedDate == null ? 'No date chosen!'
                    : 'Picked date: ${DateFormat.yMMMd().format(_selectedDate)}'
                  ),
                ),
                FlatButton (
                  textColor: Theme.of(context).primaryColor,
                  child: Text (
                    'Choose date',
                    style: TextStyle (fontWeight: FontWeight.bold)
                    ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime (2019),
                      lastDate: DateTime.now()
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      } 
                    });
                  },
                )
              ],),
            ),
            
            RaisedButton (
              color: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.accent,
		  					child: Text ('Add'),
		  					textColor: Theme.of(context).textTheme.button.color,
		  					onPressed: () {
                if (_amountController.text.isEmpty) return;

                final title = _titleController.text;
                final amount = double.parse(_amountController.text);

                if (title.isEmpty || amount <= 0 || _selectedDate == null) return;

                widget.addTransaction (
                  title,
                  amount,
                  _selectedDate
		  						);

                Navigator.of (context).pop();
              } 
            )
		  			],),
		  		),
		  	),
		);

	}
}