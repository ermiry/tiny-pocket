import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Category {

  final String id;

  String title;
  String description;

  Color color;

  DateTime date;

  Category ({
    @required this.id,

    @required this.title,
    @required this.description,

    @required this.color,

    @required this.date
  });

  static Color _colorFromJson(String colorString) {
    // String valueString = colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    // return new Color(int.parse(valueString, radix: 16));
    
    return Color(hexToInt(colorString));
  }

  static int hexToInt(String hex){
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  factory Category.fromJson(Map <String, dynamic> map) {
    return new Category (
      id: map['_id']['\$oid'],
      title: map['title'],
      description: map['description'],
      color : _colorFromJson(map['color']),
      date: DateTime.parse(map['date']['\$date'] as String)
    );
  }

  Map <String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'description': this.description,
    'color': this.color.value.toRadixString(16),
    'date': this.date.toIso8601String()
  };

}

class CategoryDesSer extends DesSer <Category> {

  @override
  String get key => "PREF_CATEGORY";

  @override
  Category deserialize(String s) {
    var map = json.decode(s);
    return new Category(
      id: map['id'] as String,
      title: map['title'] as String, 
      description: map['description'] as String,
      color: Category._colorFromJson(map['color']),
      date: DateTime.parse(map['date'] as String),
    );
  }

  @override
  String serialize(Category c) {
    return json.encode(c);
  }

}