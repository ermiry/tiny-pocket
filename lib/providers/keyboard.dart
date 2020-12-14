import 'package:flutter/material.dart';

class Keyboard extends ChangeNotifier {
  String _value = "";

  String get value => _value;

  void setValue(String _value, {bool discrete: false}){
    this._value = _value;
    if(!discrete){

      notifyListeners();
    }
  }

}