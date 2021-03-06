import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Transaction with ChangeNotifier {

	final String id;

	final String title;
	final double amount;
	final DateTime date;

  String category;
  String place;

	Transaction ({
		@required this.id,

		@required this.title, 
		@required this.amount, 
		@required this.date,

    @required this.category,
    this.place,
	});

  Transaction.fromJson(Map <String, dynamic> map)
    : id = map['_id']['\$oid'],
      title = map['title'],
      amount = map['amount'],
      date = DateTime.parse(map['date']['\$date'] as String),
      category = map['category']['\$oid'],
      place = (map["place"] != null ? map["place"]["\$oid"] : null)
    ;


  Map <String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'amount': this.amount,
    'date': this.date.toIso8601String(),
    'category': this.category,
    "place": this.place
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
      category: map['category'] as String,
      place: map["place"] as String,
    );
  }

  @override
  String serialize(Transaction t) {
    return json.encode(t);
  }

}