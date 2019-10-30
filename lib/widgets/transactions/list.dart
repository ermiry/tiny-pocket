import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pocket/models/transaction.dart';

class TransactionList extends StatelessWidget {

	final List <Transaction> transactions;
  final Function deleteTransaction;

	TransactionList (this.transactions, this.deleteTransaction);

	@override
	Widget build (BuildContext context) {

		return transactions.isEmpty ? 
    Column (children: <Widget>[
      Text (
        'No transactions yet added!',
        style: Theme.of(context).textTheme.title,
      ),

      SizedBox (height: 10),

      Container (
        height: 200,
        child: Image.asset (
          'assets/img/waiting.png', 
          fit: BoxFit.cover)
      )
    ],) 
    : ListView.builder (
      itemBuilder: (ctx, idx) {
        return Card (
          elevation: 5,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5
          ),
          child: ListTile (
            leading: Text (
              '\$${transactions[idx].amount.toStringAsFixed (2)}', 
              style: TextStyle (
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor
              )
            ),
            title: Text (
              transactions[idx].title,
              // style: TextStyle (
              // 	fontSize: 18,
              // 	fontWeight: FontWeight.bold
              // ),
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text (
              DateFormat ().format (transactions[idx].date),
              style: TextStyle (
                color: Colors.grey
              ),
            ),
            trailing: IconButton (
              icon: Icon (Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () => deleteTransaction(transactions[idx].id),
            ),
          )
        );
      },
      itemCount: transactions.length,
    );
	}

}