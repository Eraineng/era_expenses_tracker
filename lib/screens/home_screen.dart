import 'package:flutter/material.dart';
import 'package:era_expenses_tracker/models/expense.dart';
import 'package:era_expenses_tracker/widgets/chart.dart';
import 'package:era_expenses_tracker/widgets/expense_list.dart';
import 'package:era_expenses_tracker/screens/add_expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // A list to hold our registered expenses
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.50,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Lunch',
      amount: 12.00,
      date: DateTime(2025, 8, 29), // Example: A past date
      category: Category.food,
    ),
    Expense(
      title: 'Train Ticket',
      amount: 25.75,
      date: DateTime(2025, 8, 28),
      category: Category.travel,
    ),
  ];

  // Function to open the add expense overlay (modal bottom sheet)
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // Ensures content is not obscured by device cutouts
      isScrollControlled: true, // Allows the sheet to take full height
      context: context,
      builder: (ctx) => AddExpenseScreen(onAddExpense: _addExpense),
    );
  }

  // Function to add a new expense to the list
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  // Function to remove an expense from the list
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    // Show a SnackBar to allow undoing the deletion
    ScaffoldMessenger.of(context).clearSnackBars(); // Clear previous snackbars
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine available width (useful for responsive layouts)
    final width = MediaQuery.of(context).size.width;

    // Content to be displayed when no expenses are present
    Widget mainContent = Center(
      child: Text(
        'No expenses found. Start adding some!',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );

    // If there are expenses, display the list
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ERA Expenses Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses), // Display the chart
                Expanded(
                  child: mainContent, // Display the expense list or message
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}