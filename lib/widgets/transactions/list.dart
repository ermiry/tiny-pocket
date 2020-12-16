import 'package:flutter/material.dart';
import 'package:pocket/widgets/transactions/transaction.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

import 'package:pocket/models/transaction.dart';

import 'package:pocket/style/style.dart';

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
              return ChangeNotifierProvider.value(
                value: sortedTrans[idx],
                child: new TransactionItem()
              );
            },
          );
        },
      )
    );
	}

}