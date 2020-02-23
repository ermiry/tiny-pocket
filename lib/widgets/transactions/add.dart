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

  DateTime _selectedDate;

  TransactionType _selectedType;

  bool _loading = false;

  void _chooseDate() {
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
  }

  void _onChangeDropdownItem(TransactionType type) {
    setState(() {
      this._selectedType = type;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        title: Text ('An error ocurred!', style: const TextStyle(color: mainDarkBlue, fontSize: 28)),
        content: Text (message),
        actions: <Widget>[
          FlatButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <void> _add() async {
    if (this._formKey.currentState.validate()) {
      this._formKey.currentState.save();
      
      if (_selectedDate != null) {
        if (this._selectedType != null) {
          try {
            setState(() => this._loading = true);
            await Provider.of<Transactions>(context, listen: false).addTransaction(
              this._data['description'],
              double.parse(this._data['amount']),
              this._selectedDate,
              this._selectedType
            );

            Navigator.of(context).pop();
          }

          catch (error) {
            this._showErrorDialog('Failed to add new transaction!');
          }
        }

        else this._showErrorDialog('Transaction type is required!');
      }

      else this._showErrorDialog('Date is required!');
    }
  }

	@override
	Widget build(BuildContext context) {

		return Consumer <Transactions> (
      builder: (ctx, trans, _) => SingleChildScrollView (
        child: new Container (
          padding: EdgeInsets.only(
            top: 10, 
            left: 10, 
            right: 10, 
            bottom: MediaQuery.of(context).viewInsets.bottom + 10
          ),
          child: new Form(
            key: this._formKey,
            child: Column (children: <Widget>[
              // description input
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                    color: Colors.grey
                  ))
                ),

                child: new TextFormField(
                  enabled: this._loading ? false : true,
                  autofocus: false,
                  maxLength: 64,
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
                  textInputAction: TextInputAction.done,
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
                  enabled: this._loading ? false : true,
                  autofocus: false,
                  focusNode: this._amountFocusNode,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Amount",
                    // hintStyle: const TextStyle(color: Colors.grey)
                    hintStyle: hoursPlayedLabelTextStyle
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) return 'An amount is required!';
                    if (double.parse(value) <= 0) return 'An amount is required!';
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
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text (
                        _selectedDate == null ? 'No date chosen!'
                        : '${DateFormat.yMMMd().format(_selectedDate)}',
                        style: _selectedDate == null ? hoursPlayedLabelTextStyle : hoursPlayedTextStyle
                      ),
                    ),
                    AdaptiveFlatButton (
                      'Choose Date', 
                      this._loading ? null : _chooseDate
                    )
                  ],
                ),
              ),

              Container (
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container (
                      padding: EdgeInsets.only(left: 10),
                      child: Text ('Choose a type:', style: hoursPlayedLabelTextStyle),
                    ),
                    // AdaptiveFlatButton ('Choose Date', _chooseDate)
                    this._loading ? Text (this._selectedType.title) :
                      new DropdownButton(
                        value: this._selectedType,
                        items: trans.buildDropdownMenuItems(),
                        onChanged: this._onChangeDropdownItem,
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              new Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  // color: mainDarkBlue
                  color: mainBlue
                ),
                child: Center(
                  child: RawMaterialButton(
                    onPressed: this._loading ? null : () => _add(),
                    elevation: 0,
                    textStyle: TextStyle(
                      color: Colors.white,
                      // fontSize: 18,
                      fontWeight: FontWeight.w800
                    ),
                    child: this._loading ? new CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: new AlwaysStoppedAnimation<Color>(mainDarkBlue),
                      ) :
                      Text("Add!")
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],),
          ),
        ),
      )
    );

	}
}