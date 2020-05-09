import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/models/transaction.dart';

import 'package:pocket/style/style.dart';
import 'package:pocket/style/colors.dart';

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
              style: hoursPlayedLabelTextStyle,
              textAlign: TextAlign.center,
            ),
          )

          :

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      title: Text (
                        'Are you sure?', 
                        style: const TextStyle(color: mainDarkBlue, fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text (
                            'Do you want to delete this transaction?',
                            style: const TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              FlatButton(
                                child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              )
                            ],
                          )
                        ],
                      ),
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
                  color: trans.getTransType(sortedTrans[idx].type).color,
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4
                  ),
                  child: ListTile (
                    leading: Text (
                      '\$${sortedTrans[idx].amount.toStringAsFixed (2)}', 
                      style: TextStyle (
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        // color: trans.getTransType(sortedTrans[idx].type).color
                        color: Colors.white
                      )
                    ),
                    title: Text (
                      sortedTrans[idx].title,
                      style: TextStyle (
                      	fontSize: 18,
                      	fontWeight: FontWeight.bold,
                        // color: trans.getTransType(sortedTrans[idx].type).color
                        color: Colors.white
                      ),
                      // style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text (
                      DateFormat ().format (sortedTrans[idx].date),
                      style: TextStyle (
                        color: Colors.white70,
                        fontSize: 14
                        // color: Colors.white
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