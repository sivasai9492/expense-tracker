import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  static const _chartColors = [
    Color(0xFF16A085),
    Color(0xFF2980B9),
    Color(0xFFF39C12),
    Color(0xFF8E44AD),
    Color(0xFFE74C3C),
    Color(0xFF2C3E50),
    Color(0xFF7F8C8D),
  ];

  String _monthLabel(DateTime month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${names[month.month - 1]} ${month.year}';
  }

  Widget _buildCategoryChart(Map<String, double> categoryTotals) {
    if (categoryTotals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text('No expenses available for category analysis.'),
        ),
      );
    }

    final total = categoryTotals.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );
    final entries = categoryTotals.entries.toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 38,
              sections: [
                for (var index = 0; index < entries.length; index++)
                  PieChartSectionData(
                    value: entries[index].value,
                    color: _chartColors[index % _chartColors.length],
                    radius: 76,
                    title: '',
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var index = 0; index < entries.length; index++)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _chartColors[index % _chartColors.length],
                radius: 10,
              ),
              title: Text(entries[index].key),
              subtitle: Text(
                '${(entries[index].value / total * 100).toStringAsFixed(1)}%',
              ),
              trailing: Text('₹${entries[index].value.toStringAsFixed(2)}'),
            ),
          ),
      ],
    );
  }

  Widget _buildMonthlyChart(Map<DateTime, double> monthlyTotals) {
    final months = monthlyTotals.entries.toList();
    final maxAmount = months.fold<double>(
      0,
      (maximum, month) => month.value > maximum ? month.value : maximum,
    );

    if (maxAmount == 0) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: Text('No expenses in the last six months.')),
      );
    }

    final maxY = maxAmount * 1.2;
    final interval = maxY / 4;

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: [
            for (var index = 0; index < months.length; index++)
              BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: months[index].value,
                    color: _chartColors[0],
                    width: 22,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: interval,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 48,
                interval: interval,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    '₹${value.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= months.length) {
                    return const SizedBox.shrink();
                  }
                  final month = months[index].key;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      '${month.month}/${month.year % 100}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    final categoryTotals = provider.categoryTotals;
    final monthlyTotals = provider.monthlyExpenseTotals();

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Total Expenses'),
                subtitle: Text(
                  '₹${provider.totalExpenses.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Category-wise Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCategoryChart(categoryTotals),
            const SizedBox(height: 20),
            const Text(
              'Monthly Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_monthLabel(monthlyTotals.keys.first)} - '
              '${_monthLabel(monthlyTotals.keys.last)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            _buildMonthlyChart(monthlyTotals),
          ],
        ),
      ),
    );
  }
}
