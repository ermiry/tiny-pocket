import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:pocket/models/transaction.dart';
import 'package:pocket/models/http_exception.dart';

import 'package:pref_dessert/pref_dessert.dart';

import 'package:pocket/values.dart';

import '../models/category.dart';

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
      total += trans.amount.abs();
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

  Future <void> fetch(String token) async {
    try {
      final res = await http.get(
        serverURL + '/api/pocket/transactions',
        headers: { 'authorization' : '$token' }
      );

      switch (res.statusCode) {
        case 200: {
          // print(res.body);
          var transJson = jsonDecode(res.body)['transactions'] as List;
          this._transactions = transJson.map((t) => Transaction.fromJson(t)).toList();
        } break;

        case 400:
        default: {
          throw HttpException (res.body.toString());
        } break;
      }

      notifyListeners();
    }

    // catches responses with error status codes
    catch (error) {
      print(error);
      throw HttpException (error.toString());
    }
  }

  double getPercentageByCategory(Category category) {
    double sum = 0.0;
    double percentage = 0.0;
    try{
      this._transactions.where((element) => element.category == category.id).forEach((element) {
        sum += element.amount.abs();
      });

      percentage =  (sum.abs() / this.getTotal) * 100;

    }catch(error){
      print(error);
    }
    return percentage;


  }

  Future <void> add(
    String title, double amount, DateTime date, String category,
    String token,
  ) async {
    final url = serverURL + "/api/pocket/transactions";
    print(date.toIso8601String());
    try {
      print(url);
      print(category);
      final res = await http.post(url,
        body: json.encode({
          "title": title,
          "amount": amount,
          "date":  date.toLocal().toIso8601String(),
          "category": category
        }),
        headers: {
          "Authorization": token
        }
      );

      switch(res.statusCode){
        case 200:
          notifyListeners();
        break;
        default: 
          throw Exception(res.body.toString());
        break;
      }
      // Transaction trans = Transaction (
      //   id: DateTime.now().toString(), 
      //   title:  title, 
      //   amount: amount, 
      //   date: date,
      //   category: category
      // );

      // this._transactions.add(
      //   trans
      // );

      // // save to local storage
      // var repo = new FuturePreferencesRepository <Transaction> (new TransactionDesSer());
      // await repo.save(trans);

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw new Exception (error.toString());
    }

  }

  Future<void> remove(String id,String token) async{

    final url = serverURL +"/api/pocket/transactions/$id";

    try{
      final res = await http.delete(url, 
        headers: {
          "Authorization": token,
        }
      );

      switch(res.statusCode){
        case 200:
          this._transactions.firstWhere((t) => t.id == id);

          // remove from local storage
          var repo = new FuturePreferencesRepository <Transaction> (new TransactionDesSer());
          repo.removeWhere((t) => t.id == id);

          this._transactions.removeWhere((t) => t.id == id);

          notifyListeners();
        break;
        default: 
          throw Exception(res.body);
        break;

      }
    }catch(error){
      throw Exception(error.toString());
    }

  

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