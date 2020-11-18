import 'package:flutter/material.dart';

import 'package:pocket/models/category.dart';

import 'package:pref_dessert/pref_dessert.dart';

class Categories with ChangeNotifier {

  List <Category> _categories = [];

  List <Category> get categories { return [..._categories]; }

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