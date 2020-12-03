import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:pocket/models/category.dart';
import 'package:pocket/models/http_exception.dart';

import 'package:pref_dessert/pref_dessert.dart';

import 'package:pocket/values.dart';

class Categories with ChangeNotifier {

  List <Category> _categories = [];

  List <Category> get categories { return [..._categories]; }

  Category getById(String id) {
    return this._categories.firstWhere((c) => c.id == id);
  }

  Future <void> fetch(String token) async {
    try {
      final res = await http.get(
        serverURL + '/api/pocket/categories',
        headers: { 'authorization' : '$token' }
      );

      switch (res.statusCode) {
        case 200: {
          print(res.body);
          var categoriesJson = jsonDecode(res.body)['categories'] as List;
          this._categories = categoriesJson.map((c) => Category.fromJson(c)).toList();
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

  Future <void> add(String title, String description, Color color) async {
    Category cat = new Category(
      id: DateTime.now().toString(),
      title: title, 
      description: description,
      color: color,
      date: DateTime.now()
    );

    this._categories.add(cat);

    // save to local storage
    var repo = new FuturePreferencesRepository <Category> (new CategoryDesSer());
    await repo.save(cat);

    notifyListeners();
  }

  void update(
    Category category, 
    String title, String description, Color color
  ) {
    try {
      if (category != null) {
        category.title = title;
        category.description = description;
        category.color = color;

        // save to local storage
        var repo = new FuturePreferencesRepository <Category> (new CategoryDesSer());
        repo.updateWhere((c) => c.id == category.id, category);

        notifyListeners();
      }
    }

    catch (error) {
      print(error);
      print('Failed to update category!');
    }
  }

  Future <void> load() async {
    try {
      var repo = new FuturePreferencesRepository <Category> (new CategoryDesSer ());
      this._categories = await repo.findAll();
    }

    catch (error) {
      print('Failed to load categories from local storage!');
    }

    notifyListeners();
  }

}