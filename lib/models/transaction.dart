import 'package:flutter/foundation.dart';

class Transaction {

	String id;
	String title;
	double amount;
	DateTime date;

  int type;

	Transaction ({
		@required this.id, 
		@required this.title, 
		@required this.amount, 
		@required this.date,

    @required this.type
	});

  Transaction.fromJson(Map <String, dynamic> json)
    : id = json['name'],
      title = json['title'],
      amount = json['amount'],
      date = DateTime.parse(json['date']),

      type = json['type'];

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'amount': this.amount,
    'date': this.date.toIso8601String(),

    'type': this.type
  };

}