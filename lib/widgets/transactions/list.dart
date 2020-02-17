import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/models/transaction.dart';

class TransactionList extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

		return Container(
      child: Consumer <Transactions> (
        builder: (ctx, trans, _) {
          List <Transaction> sortedTrans = trans.sortedTrans;

          return sortedTrans.isEmpty ? Container(
            padding: EdgeInsets.all(20),
            child: Text (
              'No transactions yet added!',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          )

          :

          ListView.builder(
            itemCount: sortedTrans.length,
            itemBuilder: (ctx, idx) {
              return new Dismissible(
                key: ValueKey (sortedTrans[idx].id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  trans.removeTransaction(sortedTrans[idx].id);
                  sortedTrans.removeWhere((t) => t.id == sortedTrans[idx].id);
                },
                confirmDismiss: (dir) {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog (
                      title: Text ('Are you sure?'),
                      content: Text ('Do you want to delete this transaction?'),
                      actions: <Widget>[
                        FlatButton (
                          child: Text ('No'),
                          onPressed: () => Navigator.of(ctx).pop(false),
                        ),
                        FlatButton (
                          child: Text ('Yes'),
                          onPressed: () => Navigator.of(ctx).pop(true),
                        ),
                      ],
                    )
                  );
                },
                background: Container (
                  color: Theme.of(context).errorColor,
                  child: Icon (
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                ),
                child: Card (
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5
                  ),
                  child: ListTile (
                    leading: Text (
                      '\$${sortedTrans[idx].amount.toStringAsFixed (2)}', 
                      style: TextStyle (
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor
                      )
                    ),
                    title: Text (
                      sortedTrans[idx].title,
                      // style: TextStyle (
                      // 	fontSize: 18,
                      // 	fontWeight: FontWeight.bold
                      // ),
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text (
                      DateFormat ().format (sortedTrans[idx].date),
                      style: TextStyle (
                        color: Colors.grey
                      ),
                    ),
                  )
                ),
              );
            },
          );
        },
      )
    );
	}

}