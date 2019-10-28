import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {

  final String label;
  final double amount;
  final double percentage;

  ChartBar (this.label, this.amount, this.percentage);

  @override
  Widget build (BuildContext context) {

    return Column (children: <Widget>[
      Text ('\$${amount.toStringAsFixed(0)}'),
      SizedBox (height: 4),
      Container (
        height: 60,
        width: 10,
        child: Stack (children: <Widget>[
          Container (
            decoration: BoxDecoration (
              border: Border.all(color: Colors.grey, width: 1.0),
              color: Color.fromRGBO(220, 200, 220, 1),
              borderRadius: BorderRadius.circular(10)
            ),
          ),

          FractionallySizedBox (
            heightFactor: amount,
            child: Container (
              decoration: BoxDecoration (
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
        ],),
      ),
      SizedBox (
        height: 4,
      ),
      Text (label)
    ],
    );

  }

}