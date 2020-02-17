import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

import 'package:pocket/widgets/adaptive/flatButton.dart';

class AddTransaction extends StatefulWidget {

  @override
  _AddTransactionState createState() => _AddTransactionState ();

}

class _AddTransactionState extends State <AddTransaction> {

	final _titleController = TextEditingController ();
	final _amountController = TextEditingController ();

  DateTime _selectedDate;

  TransactionType _selectedType;

  void _chooseDate() {
    showDatePicker (
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
  }

  void _onChangeDropdownItem(TransactionType type) {
    setState(() {
      this._selectedType = type;
    });
  }

	@override
	Widget build(BuildContext context) {

		return Consumer <Transactions> (
      builder: (ctx, trans, _) => SingleChildScrollView (
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
                AdaptiveFlatButton ('Choose Date', _chooseDate)
              ],),
            ),

            Container (
              height: 70,
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded (
                    child: Text ('Choose a type:'),
                  ),
                  // AdaptiveFlatButton ('Choose Date', _chooseDate)
                  new DropdownButton(
                    value: this._selectedType,
                    items: trans.buildDropdownMenuItems(),
                    onChanged: this._onChangeDropdownItem,
                  ),
                ],
              ),
            ),
            
            // FIXME: add input validation
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

                trans.addTransaction(
                  title,
                  amount,
                  this._selectedDate,
                  this._selectedType
                );

                Navigator.of (context).pop();
              } 
            )
            ],),
          ),
        ),
      )
    );

	}
}