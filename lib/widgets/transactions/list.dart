import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pocket/models/transaction.dart';

class TransactionList extends StatelessWidget {

	final List <Transaction> transactions;

	TransactionList (this.transactions);

	@override
	Widget build (BuildContext context) {

		return Container (
			height: 400,
			child: transactions.isEmpty ? Column (children: <Widget>[
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
						child: Row (children: <Widget>[
							Container (
								margin: EdgeInsets.symmetric (vertical: 10, horizontal: 15),
								decoration: BoxDecoration (
									border: Border.all (
										color: Theme.of(context).primaryColor,
										width: 2
									)
									),
								padding: EdgeInsets.all(10),
								child: Text (
									'\$${transactions[idx].amount.toStringAsFixed (2)}', 
									style: TextStyle (
										fontWeight: FontWeight.bold,
										fontSize: 20,
										color: Theme.of(context).primaryColor
									)
									)
								),
							Column (
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									Text (
										transactions[idx].title,
										// style: TextStyle (
										// 	fontSize: 18,
										// 	fontWeight: FontWeight.bold
										// ),
                    style: Theme.of(context).textTheme.title,
										),
									Text (
										DateFormat ().format (transactions[idx].date),
										style: TextStyle (
											color: Colors.grey
										),
										)
							],)
						],)
					);
				},
				itemCount: transactions.length,
			)
		);
	}

}