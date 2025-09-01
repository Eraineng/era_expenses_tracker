// lib/widgets/expense_list.dart
import 'package:flutter/material.dart';
import 'package:era_expenses_tracker/models/expense.dart';
import 'package:era_expenses_tracker/widgets/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    this.onRefresh, // <--- RE-ADDING THIS PARAMETER
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  final Future<void> Function()? onRefresh; // <--- RE-ADDING THIS PROPERTY DECLARATION

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Text(
          'No expenses found. Start adding some!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Wrapping the ListView.builder with RefreshIndicator again
    return RefreshIndicator(
      // The onRefresh callback from HomeScreen will be used here.
      // Providing a default empty async function if onRefresh is null (though it shouldn't be now).
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(expenses[index].id),
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
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(expenses[index]),
        ),
      ),
    );
  }
}