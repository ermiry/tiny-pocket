import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Transaction {

	final String id;

	final String title;
	final double amount;
	final DateTime date;

  final String category;

	Transaction ({
		@required this.id,

		@required this.title, 
		@required this.amount, 
		@required this.date,

    @required this.category
	});

  Transaction.fromJson(Map <String, dynamic> json)
    : id = json['name'],
      title = json['title'],
      amount = json['amount'],
      date = DateTime.parse(json['date']),
      category = json['category'];

  Map <String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'amount': this.amount,
    'date': this.date.toIso8601String(),
    'category': this.category
  };

}

class TransactionDesSer extends DesSer <Transaction> {

  @override
  String get key => "PREF_TRANS";

  @override
  Transaction deserialize(String s) {
    var map = json.decode(s);
    return new Transaction(
      id: map['id'] as String,
      title: map['title'] as String, 
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String
    );
  }

  @override
  String serialize(Transaction t) {
    return json.encode(t);
  }

}