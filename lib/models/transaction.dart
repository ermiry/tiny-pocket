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

}