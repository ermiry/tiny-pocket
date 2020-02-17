import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

// import 'package:http/http.dart' as htpp;

// TODO: save transactions as a json value
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:pocket/models/http_exception.dart';
// import 'package:pocket/values.dart';

import 'package:pocket/models/transaction.dart';

class TransactionType {

	String id;
	String title;
	double amount;
	Color color;

  int type;

	TransactionType ({
		@required this.id, 
		@required this.title, 
		// @required this.amount, 
    @required this.color,

    @required this.type
	});

}

class Transactions with ChangeNotifier {

  // Transactions types:
  // 0 -> food
  // 1 -> transportation
  // 2 -> work
  // 3 -> fun

  final List <TransactionType> _transTypes = [
    new TransactionType(id: 'type_1', title: 'Food', color: Color(0xff0293ee), type: 0),
    new TransactionType(id: 'type_2', title: 'Transportation', color: Color(0xfff8b250), type: 1),
    new TransactionType(id: 'type_3', title: 'Work', color: Color(0xff845bef), type: 2),
    new TransactionType(id: 'type_4', title: 'Fun', color: Color(0xff13d38e), type: 3),
  ];

  List <TransactionType> get transTypes { return [...this._transTypes]; }

  TransactionType getTransType(int type) {
    return this._transTypes.firstWhere((t) => t.type == type);
  }

  double getTransTypePercentage(int type) {
    double total = 0;
    double value = 0;
    this._transactions.forEach((trans) {
      total += trans.amount;
      if (trans.type == type) value += trans.amount;
    });

    return (total == 0 ? 1 : (value * 100) / total);
  }

  List <DropdownMenuItem <TransactionType>> buildDropdownMenuItems() {
    List <DropdownMenuItem <TransactionType>> items = List();
    for (TransactionType trans in this._transTypes) {
      items.add(
        DropdownMenuItem(
          value: trans,
          child: Text(trans.title),
        ),
      );
    }
    return items;
  }

  final List <Transaction> _transactions = [
		Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now (), type: 3),
		Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now (), type: 0),
    Transaction (id: 't3', title: 'Dinner', amount: 69.99, date: DateTime.now (), type: 0),
		Transaction (id: 't4', title: 'Metro', amount: 20.99, date: DateTime.now (), type: 1),
    Transaction (id: 't5', title: 'New work book', amount: 69.99, date: DateTime.now (), type: 2),
		Transaction (id: 't6', title: 'Icecream', amount: 20.99, date: DateTime.now (), type: 0)
	];

  List <Transaction> get transactions { return [...this._transactions]; }

  List <Transaction> get sortedTrans { 
    List <Transaction> trans = [...this._transactions]; 
    trans.sort((a, b) => b.date.compareTo(a.date));
    return trans;
  }

  List <Transaction> get recentTransactions {
    return this._transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration (days: 7)));
    }).toList();
  }

  double get getTotal {
    double total = 0;
    this._transactions.forEach((trans) {
      total += trans.amount;
    });

    return total;
  }

  void addTransaction(String title, double amount, DateTime date, TransactionType type) {

    this._transactions.add(
      new Transaction (
        id: DateTime.now().toString(), 
        title:  title, 
        amount: amount, 
        date: date,

        type: type.type
      )
    );

    notifyListeners();

  }

  void removeTransaction(String id) {

    this._transactions.removeWhere((t) => t.id == id);
    notifyListeners();

  }

}