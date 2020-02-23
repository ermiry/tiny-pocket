import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pocket/models/transaction.dart';

import 'package:pocket/style/colors.dart';
import 'package:pocket/style/style.dart';

class ChartBar extends StatelessWidget {

  final String label;
  final double amount;
  final double percentage;

  ChartBar (this.label, this.amount, this.percentage);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder (builder: (ctx, constraints) {
      return Column (children: <Widget>[
        Container (
          height: constraints.maxHeight * 0.15,
          child: FittedBox (
            child: Text ('\$${amount.toStringAsFixed(0)}', style: hoursPlayedLabelTextStyle,),
          ),
        ),
        SizedBox (height: constraints.maxHeight * 0.05),
        Container (
          height: constraints.maxHeight * 0.6,
          width: 10,
          child: Stack (
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Container (
                decoration: BoxDecoration (
                  // border: Border.all(color: Colors.grey, width: 1.0),
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),

              FractionallySizedBox (
                heightFactor: percentage,
                child: Container (
                  decoration: BoxDecoration (
                    color: mainBlue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox (
          height: constraints.maxHeight * 0.05,
        ),
        Container (
          height: constraints.maxHeight * 0.15,
          child: FittedBox (
            child: Text (label, style: hoursPlayedLabelTextStyle)
            )
          )
      ],
      );
    }); 

  }

}

class BarsChart extends StatelessWidget {

  final List <Transaction> recentTransactions;

  BarsChart (this.recentTransactions);

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

      return { 
        'day': DateFormat.E().format(weekday).substring(0, 1), 
        'amount': total 
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build (BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: new Material (
        elevation: 4,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container (
          padding: EdgeInsets.all(10),
          child: Row (
            children: groupedTransactionValues.map((data) {
              return Flexible (
                fit: FlexFit.tight,
                child: ChartBar (
                  data['day'], 
                  data['amount'], 
                  totalSpending == 0.0 ? 0.0 :
                    (data['amount'] as double) / totalSpending)
                ); 
            }).toList()
          ),
        ),
      )
    );
  }

}