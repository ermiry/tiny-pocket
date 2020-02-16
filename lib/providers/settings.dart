import 'package:flutter/widgets.dart';

class Settings with ChangeNotifier {

  bool showBarsChart = true;
  bool showExpensesChart = true;
  bool showHistoryChart = false;

  void toggleBarsChart() { 
    this.showBarsChart = !this.showBarsChart;
    notifyListeners(); 
  }

  void toggleExpensesChart() { 
    this.showExpensesChart = !this.showExpensesChart;
    notifyListeners(); 
  }

  void toggleHistoryChart() { 
    this.showHistoryChart = !this.showHistoryChart;
    notifyListeners(); 
  }

}