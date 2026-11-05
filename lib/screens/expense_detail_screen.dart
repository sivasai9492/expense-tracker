
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Center(
              child: CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.receipt_long,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                '₹${expense.amount.toStringAsFixed(2)}',

                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            _detail('Title', expense.title),

            _detail('Category', expense.category),

            _detail(
              'Date',
              '${expense.date.day}/${expense.date.month}/${expense.date.year}',
            ),

            _detail(
              'Note',
              expense.note.isEmpty ? 'No note' : expense.note,
            ),

            const Spacer(),

            // Edit Expense Button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddExpenseScreen(
                        expense: expense,
                      ),
                    ),
                  );
                },

                icon: const Icon(Icons.edit),

                label: const Text('Edit Expense'),
              ),
            ),

            const SizedBox(height: 12),

            // Delete Expense Button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),

                onPressed: () async {
                  await context
                      .read<ExpenseProvider>()
                      .deleteExpense(expense.id);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },

                icon: const Icon(Icons.delete),

                label: const Text('Delete Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
