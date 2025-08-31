import 'package:flutter/material.dart';
import 'package:era_expenses_tracker/models/expense.dart';
import 'package:era_expenses_tracker/widgets/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // If there are no expenses, display a message
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No expenses found. Start adding some!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Use ListView.builder for efficient rendering of long lists
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index].id), // Unique key for each item
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        direction: DismissDirection.endToStart, // Only swipe from right to left
        onDismissed: (direction) {
          // Call the provided callback to remove the expense
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}