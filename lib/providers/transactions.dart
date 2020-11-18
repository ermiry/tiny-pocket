import 'package:flutter/material.dart';

import 'package:pocket/models/transaction.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Transactions with ChangeNotifier {

  List <Transaction> _transactions = [];

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

  Future <void> load() async {

    // load from local storage
    try {
      var repo = new FuturePreferencesRepository <Transaction> (new TransactionDesSer());
      var list = await repo.findAll();
      this._transactions = list;

      // this._transactions.forEach((trans) {
      //   TransactionType type = getTransType(trans.type);
      //   type.amount += trans.amount;
      // });
    }

    catch (error) {
      print('Failed to load transactions from local storage!');
    }

    notifyListeners();

  }

  Future <void> add(
    String title, double amount, DateTime date, String category
  ) async {

    try {
      Transaction trans = Transaction (
        id: DateTime.now().toString(), 
        title:  title, 
        amount: amount, 
        date: date,
        category: category
      );

      this._transactions.add(
        trans
      );

      // save to local storage
      var repo = new FuturePreferencesRepository <Transaction> (new TransactionDesSer());
      await repo.save(trans);

      notifyListeners();
    } catch (error) {
      throw new Exception (error.toString());
    }

  }

  void remove(String id) {

    this._transactions.firstWhere((t) => t.id == id);

    // remove from local storage
    var repo = new FuturePreferencesRepository <Transaction> (new TransactionDesSer());
    repo.removeWhere((t) => t.id == id);

    this._transactions.removeWhere((t) => t.id == id);

    notifyListeners();

  }

  Future <void> clear() async {

    try {
      var repo = new FuturePreferencesRepository <Transaction> (new TransactionDesSer());
      repo.removeAll();
      this._transactions = [];
    }

    catch (error) {
      print('Failed to clear transactions from local storage!');
    }

    notifyListeners();

  }

}