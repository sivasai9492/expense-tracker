import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/storage_service.dart';

class ExpenseProvider extends ChangeNotifier {
  ExpenseProvider({List<Expense> initialExpenses = const []})
    : _expenses = List.of(initialExpenses);

  final StorageService _storageService = StorageService();

  List<Expense> _expenses;
  bool _isLoading = true;
  String? _error;
  double _monthlyBudget = 0.0;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get monthlyBudget => _monthlyBudget;

  // Total expenses
  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> get categoryTotals {
    final totals = <String, double>{};

    for (final expense in _expenses) {
      totals.update(
        expense.category,
        (total) => total + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return Map.unmodifiable(totals);
  }

  Map<DateTime, double> monthlyExpenseTotals({DateTime? endingMonth}) {
    final end = endingMonth ?? DateTime.now();
    final lastMonth = DateTime(end.year, end.month);
    final totals = <DateTime, double>{
      for (var offset = 5; offset >= 0; offset--)
        DateTime(lastMonth.year, lastMonth.month - offset): 0,
    };

    for (final expense in _expenses) {
      final month = DateTime(expense.date.year, expense.date.month);
      if (totals.containsKey(month)) {
        totals.update(month, (total) => total + expense.amount);
      }
    }

    return Map.unmodifiable(totals);
  }

  // Current month's expenses
  double get monthlyExpenses {
    final now = DateTime.now();

    return _expenses
        .where(
          (expense) =>
              expense.date.year == now.year && expense.date.month == now.month,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Remaining budget
  double get remainingBudget {
    return monthlyBudget - monthlyExpenses;
  }

  // Budget usage percentage
  double get budgetPercentage {
    if (monthlyBudget <= 0) return 0;
    return monthlyExpenses / monthlyBudget;
  }

  // Budget warning
  String? get budgetWarning {
    if (monthlyBudget <= 0) return null;

    if (monthlyExpenses > monthlyBudget) {
      return 'Alert! You have exceeded your monthly budget.';
    }

    if (budgetPercentage >= 0.8) {
      return 'Warning! You have used 80% of your monthly budget.';
    }

    return null;
  }

  // Load expenses and budget
  Future<void> loadExpenses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _storageService.loadExpenses();
      _monthlyBudget = await _storageService.loadMonthlyBudget();
    } catch (e) {
      _error = 'Unable to load expenses. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Set monthly budget
  Future<void> setMonthlyBudget(double budget) async {
    _monthlyBudget = budget;
    await _storageService.saveMonthlyBudget(budget);
    notifyListeners();
  }

  // Add expense
  Future<void> addExpense(Expense expense) async {
    _expenses = [..._expenses, expense];
    await _save();
  }

  // Update expense
  Future<void> updateExpense(Expense updatedExpense) async {
    final index = _expenses.indexWhere(
      (expense) => expense.id == updatedExpense.id,
    );

    if (index == -1) return;

    final updatedList = [..._expenses];
    updatedList[index] = updatedExpense;
    _expenses = updatedList;

    await _save();
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    _expenses = _expenses.where((e) => e.id != id).toList();
    await _save();
  }

  // Save expenses
  Future<void> _save() async {
    try {
      await _storageService.saveExpenses(_expenses);
      _error = null;
    } catch (e) {
      _error = 'Unable to save expenses.';
    }

    notifyListeners();
  }

  // Retry loading
  Future<void> retry() async {
    await loadExpenses();
  }
}
