import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {

  bool showBarsChart = true;
  bool showExpensesChart = true;
  bool showHistoryChart = false;

  bool enableCloud = true;

  Future <void> toggleBarsChart() async { 
    this.showBarsChart = !this.showBarsChart;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_bars_chart', this.showBarsChart);

    notifyListeners(); 
  }

  Future <void> toggleExpensesChart() async { 
    this.showExpensesChart = !this.showExpensesChart;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_expenses_chart', this.showExpensesChart);

    notifyListeners(); 
  }

  Future <void> toggleHistoryChart() async { 
    this.showHistoryChart = !this.showHistoryChart;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('show_history_chart', this.showHistoryChart);

    notifyListeners(); 
  }

  Future <void> loadSettings() async {

    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('show_bars_chart')) {
      this.showBarsChart = prefs.getBool('show_bars_chart');
    }

    if (!prefs.containsKey('show_expenses_chart')) {
      this.showExpensesChart = prefs.getBool('show_expenses_chart');
    }

    if (!prefs.containsKey('show_history_chart')) {
      this.showHistoryChart = prefs.getBool('show_history_chart');
    }

    notifyListeners();

  }

}