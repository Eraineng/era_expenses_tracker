import 'package:flutter/material.dart';
import 'package:era_expenses_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Display the amount, formatted to 2 decimal places
                Text('RM${expense.amount.toStringAsFixed(2)}'),
                const Spacer(), // Pushes widgets to the ends of the row
                Row(
                  children: [
                    // Display the icon associated with the expense category
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    // Display the formatted date
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}