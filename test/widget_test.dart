import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/providers/expense_provider.dart';

void main() {
  testWidgets('Expense Tracker app loads', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ExpenseProvider(),
        child: const ExpenseTrackerApp(),
      ),
    );

    await tester.pump();

    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}