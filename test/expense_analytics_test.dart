import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseProvider analytics', () {
    test('category totals include all recorded expenses', () {
      final provider = ExpenseProvider(
        initialExpenses: [
          Expense(
            id: '1',
            title: 'Lunch',
            amount: 120,
            category: 'Food',
            date: DateTime(2026, 2),
            note: '',
          ),
          Expense(
            id: '2',
            title: 'Dinner',
            amount: 80,
            category: 'Food',
            date: DateTime(2025, 12),
            note: '',
          ),
          Expense(
            id: '3',
            title: 'Bus',
            amount: 50,
            category: 'Travel',
            date: DateTime(2026, 1),
            note: '',
          ),
        ],
      );

      expect(provider.categoryTotals, {'Food': 200, 'Travel': 50});
    });

    test('monthly totals include six months and zero-value months', () {
      final provider = ExpenseProvider(
        initialExpenses: [
          Expense(
            id: '1',
            title: 'Old expense',
            amount: 75,
            category: 'Food',
            date: DateTime(2025, 11),
            note: '',
          ),
          Expense(
            id: '2',
            title: 'December expense',
            amount: 125,
            category: 'Bills',
            date: DateTime(2025, 12, 31),
            note: '',
          ),
          Expense(
            id: '3',
            title: 'January expense',
            amount: 50,
            category: 'Travel',
            date: DateTime(2026, 1),
            note: '',
          ),
          Expense(
            id: '4',
            title: 'Future expense',
            amount: 500,
            category: 'Other',
            date: DateTime(2026, 7),
            note: '',
          ),
        ],
      );

      final totals = provider.monthlyExpenseTotals(
        endingMonth: DateTime(2026, 3, 20),
      );

      expect(totals, {
        DateTime(2025, 10): 0,
        DateTime(2025, 11): 75,
        DateTime(2025, 12): 125,
        DateTime(2026, 1): 50,
        DateTime(2026, 2): 0,
        DateTime(2026, 3): 0,
      });
    });
  });
}
