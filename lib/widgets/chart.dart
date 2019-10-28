import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:pocket/models/transaction.dart';

class Chart extends StatelessWidget {

  final List <Transaction> recentTransactions;

  Chart (this.recentTransactions);

  List <Map <String, Object>> get groupedTransactionValues {
    return List.generate(7, (idx) {
      final weekday = DateTime.now().subtract(Duration (days: idx));

      double total = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
          recentTransactions[i].date.month == weekday.month &&
          recentTransactions[i].date.year == weekday.year)
          total += recentTransactions[i].amount;
      }

      return { 'day': DateFormat.E().format(weekday), 'amount': total };
    });
  }

  @override
  Widget build (BuildContext context) {

    return Card (
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row (children: <Widget>[

      ],
      ),
    );

  }

}