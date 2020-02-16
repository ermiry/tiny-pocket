import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

class TransactionList extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

		return Container(
      child: Consumer <Transactions> (
        builder: (ctx, trans, _) {
          return trans.transactions.isEmpty ? Container(
            padding: EdgeInsets.all(20),
            child: Text (
              'No transactions yet added!',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          )

          :

          ListView.builder (
            itemCount: trans.transactions.length,
            itemBuilder: (ctx, idx) {
              return Card (
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5
                ),
                child: ListTile (
                  leading: Text (
                    '\$${trans.transactions[idx].amount.toStringAsFixed (2)}', 
                    style: TextStyle (
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  title: Text (
                    trans.transactions[idx].title,
                    // style: TextStyle (
                    // 	fontSize: 18,
                    // 	fontWeight: FontWeight.bold
                    // ),
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text (
                    DateFormat ().format (trans.transactions[idx].date),
                    style: TextStyle (
                      color: Colors.grey
                    ),
                  ),
                  trailing: /* MediaQuery.of(context).size.width > 360 ? 
                    FlatButton.icon(
                      icon: Icon (Icons.delete),
                      label: Text ('Delete'),
                      textColor: Theme.of(context).errorColor,
                      onPressed: () => deleteTransaction(transactions[idx].id),
                    ) : */ IconButton (
                    icon: Icon (Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () => trans.removeTransaction(trans.transactions[idx].id),
                  ),
                )
              );
            },
          );
        },
      )
    );
	}

}