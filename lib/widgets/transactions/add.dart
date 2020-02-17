import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

import 'package:pocket/widgets/adaptive/flatButton.dart';

import 'package:pocket/style/colors.dart';
import 'package:pocket/style/style.dart';

class AddTransaction extends StatefulWidget {

  @override
  _AddTransactionState createState() => _AddTransactionState ();

}

class _AddTransactionState extends State <AddTransaction> {

  final GlobalKey <FormState> _formKey = new GlobalKey ();

  final FocusNode _amountFocusNode = new FocusNode ();

  Map <String, String> _data = {
    'description': '',
    'amount': '',
  };

	final _descriptionController = TextEditingController ();
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
            child: new Form(
              child: Column (children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Colors.grey
                    ))
                  ),

                  child: new TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                      // hintStyle: const TextStyle(color: Colors.grey)
                      hintStyle: hoursPlayedLabelTextStyle
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) return 'A description is required!';
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(
                        this._amountFocusNode
                      );
                    },
                    onSaved: (value) {
                      this._data['description'] = value;
                    },
                  ),
                ),

                // amount input
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Colors.grey
                    ))
                  ),

                  child: new TextFormField(
                    focusNode: this._amountFocusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Amount",
                      // hintStyle: const TextStyle(color: Colors.grey)
                      hintStyle: hoursPlayedLabelTextStyle
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final amount = double.parse(value);
                      if (value.isEmpty || amount <= 0) return 'An amount is required!';
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      // done
                    },
                    onSaved: (value) {
                      this._data['amount'] = value;
                    },
                  ),
                ),

                Container (
                  // height: 70,
                  child: Row (children: <Widget>[
                    Expanded (
                      child: Text (
                        _selectedDate == null ? 'No date chosen!'
                        : '${DateFormat.yMMMd().format(_selectedDate)}',
                        style: _selectedDate == null ? hoursPlayedLabelTextStyle : hoursPlayedTextStyle
                      ),
                    ),
                    AdaptiveFlatButton ('Choose Date', _chooseDate)
                  ],),
                ),

                Container (
                  // height: 70,
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded (
                        child: Text ('Choose a type:', style: hoursPlayedLabelTextStyle),
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
                
                RaisedButton (
                  color: mainBlue,
                  // textTheme: ButtonTextTheme.accent,
                  child: Text ('Add', style: TextStyle (color: Colors.white),),
                  textColor: mainBlue,
                  onPressed: () {
                    if (_amountController.text.isEmpty) return;

                    final title = _descriptionController.text;
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
        ),
      )
    );

	}
}