
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _category = 'Food';
  DateTime _date = DateTime.now();
  bool _saving = false;

  final List<String> _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Education',
    'Bills',
    'Health',
    'Other',
  ];

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();

    // Fill existing expense details when editing.
    if (_isEditing) {
      final expense = widget.expense!;

      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
      _noteController.text = expense.note;

      _category = _categories.contains(expense.category)
          ? expense.category
          : 'Other';

      _date = expense.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final expense = Expense(
      // Preserve the original ID when editing.
      id: _isEditing
          ? widget.expense!.id
          : DateTime.now().microsecondsSinceEpoch.toString(),

      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _category,
      date: _date,
      note: _noteController.text.trim(),
    );

    final provider = context.read<ExpenseProvider>();

    if (_isEditing) {
      await provider.updateExpense(expense);
    } else {
      await provider.addExpense(expense);
    }

    if (!mounted) return;

    setState(() => _saving = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Expense' : 'Add Expense',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller: _titleController,

                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),

                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter expense title'
                        : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,

                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),

                validator: (value) {
                  final amount =
                      double.tryParse(value?.trim() ?? '');

                  if (amount == null ||
                      !amount.isFinite ||
                      amount <= 0) {
                    return 'Enter a valid positive amount';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _category,

                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),

                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),

                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),

              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,

                title: const Text('Expense Date'),

                subtitle: Text(
                  '${_date.day}/${_date.month}/${_date.year}',
                ),

                trailing: const Icon(Icons.calendar_month),

                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    setState(() => _date = picked);
                  }
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _noteController,
                maxLength: 200,
                maxLines: 3,

                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: _saving ? null : _saveExpense,

                  child: _saving
                      ? const CircularProgressIndicator()
                      : Text(
                          _isEditing
                              ? 'Update Expense'
                              : 'Save Expense',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
