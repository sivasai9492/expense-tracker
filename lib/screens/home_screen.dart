import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedCategory = 'All';
  bool _newestFirst = true;

  final List<String> _categories = [
    'All',
    'Food',
    'Travel',
    'Shopping',
    'Education',
    'Bills',
    'Health',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      _newestFirst = true;
    });
  }

  // Show monthly budget dialog
 void _showBudgetDialog(double currentBudget) {
  String budgetText = currentBudget > 0
      ? currentBudget.toString()
      : '';

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextFormField(
          initialValue: budgetText,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: const InputDecoration(
            labelText: 'Monthly Budget',
            prefixText: '₹ ',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            budgetText = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final budget = double.tryParse(budgetText.trim());

              if (budget == null || budget <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a valid budget greater than zero.'),
                  ),
                );
                return;
              }

              await context
                  .read<ExpenseProvider>()
                  .setMonthlyBudget(budget);

              if (!mounted) return;

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Monthly budget updated successfully!'),
                ),
              );
            },
            child: const Text('Save Budget'),
          ),
        ],
      );
    },
  );
}
  // Monthly budget card
  Widget _buildBudgetCard(ExpenseProvider provider) {
    final budget = provider.monthlyBudget;
    final spent = provider.monthlyExpenses;
    final remaining = provider.remainingBudget;
    final percentage = provider.budgetPercentage.clamp(0.0, 1.0);
    final warning = provider.budgetWarning;

    final progressColor = budget <= 0
        ? Colors.grey
        : provider.budgetPercentage >= 1
            ? Colors.red
            : provider.budgetPercentage >= 0.8
                ? Colors.orange
                : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Budget',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showBudgetDialog(budget),
                  icon: const Icon(Icons.edit, size: 18),
                  label: Text(budget > 0 ? 'Edit' : 'Set Budget'),
                ),
              ],
            ),

            if (budget <= 0) ...[
              const Text(
                'Set a monthly budget to track your spending.',
                style: TextStyle(color: Colors.grey),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Monthly Limit'),
                  Text(
                    '₹${budget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Spent'),
                  Text(
                    '₹${spent.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              LinearProgressIndicator(
                value: percentage,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remaining'),
                  Text(
                    '₹${remaining.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: remaining < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),

              if (warning != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: progressColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: progressColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          warning,
                          style: TextStyle(
                            color: progressColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Expense Summary',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: provider.retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allExpenses = provider.expenses;

          // Search and category filtering
          final filteredExpenses = allExpenses.where((expense) {
            final query =
                _searchController.text.toLowerCase().trim();

            final matchesSearch =
                expense.title.toLowerCase().contains(query) ||
                expense.note.toLowerCase().contains(query);

            final matchesCategory =
                _selectedCategory == 'All' ||
                expense.category == _selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();

          // Sort expenses by date
          filteredExpenses.sort((a, b) {
            return _newestFirst
                ? b.date.compareTo(a.date)
                : a.date.compareTo(b.date);
          });

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Total Expenses Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Expenses',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '₹${provider.totalExpenses.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${allExpenses.length} transactions',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Monthly Budget Card
                    _buildBudgetCard(provider),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search expenses...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Category Filter
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Filter by Category',
                          prefixIcon: Icon(Icons.category),
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
                            setState(() {
                              _selectedCategory = value;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Recent Expenses and Sorting
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Expenses',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text('${filteredExpenses.length} items'),
                              IconButton(
                                tooltip: _newestFirst
                                    ? 'Newest first'
                                    : 'Oldest first',
                                icon: Icon(
                                  _newestFirst
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _newestFirst = !_newestFirst;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Clear Filters
                    if (_searchController.text.isNotEmpty ||
                        _selectedCategory != 'All')
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear Filters'),
                        ),
                      ),

                    // Expense List
                    if (allExpenses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'No expenses yet!\nTap + to add your first expense.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (filteredExpenses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          'No matching expenses found.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ...filteredExpenses.map(
                        (expense) => ExpenseCard(
                          expense: expense,
                        ),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // Add Expense Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExpenseScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }
}