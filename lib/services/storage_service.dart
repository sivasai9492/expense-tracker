import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageService {
  static const String _key = 'expenses';
  static const String _budgetKey = 'monthly_budget';

  // Save expenses
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();

    final String data = jsonEncode(
      expenses.map((expense) => expense.toJson()).toList(),
    );

    await prefs.setString(_key, data);
  }

  // Load expenses
  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_key);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(data);

    return decodedData
        .map((item) => Expense.fromJson(item))
        .toList();
  }

  // Save monthly budget
  Future<void> saveMonthlyBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, budget);
  }

  // Load monthly budget
  Future<double> loadMonthlyBudget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_budgetKey) ?? 0.0;
  }
}