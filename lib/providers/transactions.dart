import 'package:flutter/widgets.dart';

// import 'package:http/http.dart' as htpp;

// TODO: save transactions as a json value
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:pocket/models/http_exception.dart';
// import 'package:pocket/values.dart';

import 'package:pocket/models/transaction.dart';

class Transactions with ChangeNotifier {

  final List <Transaction> _transactions = [
		Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ()),
    Transaction (id: 't3', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't4', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ()),
    Transaction (id: 't5', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		Transaction (id: 't6', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

  List <Transaction> get transactions { return [...this._transactions]; }

  void addTransaction(String title, double amount, DateTime date) {

    this._transactions.add(
      new Transaction (
        id: DateTime.now().toString(), 
        title:  title, 
        amount: amount, 
        date: date
      )
    );

    notifyListeners();

  }

  void removeTransaction(String id) {

    this._transactions.removeWhere((t) => t.id == id);
    notifyListeners();

  }

}