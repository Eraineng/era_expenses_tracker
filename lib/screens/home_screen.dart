// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider

import 'package:era_expenses_tracker/models/expense.dart'; // Expense model (for type hints)
import 'package:era_expenses_tracker/widgets/chart.dart';
import 'package:era_expenses_tracker/widgets/expense_list.dart';
import 'package:era_expenses_tracker/screens/add_expense_screen.dart';
import 'package:era_expenses_tracker/screens/accounts_screen.dart';
import 'package:era_expenses_tracker/providers/money_manager.dart'; // MoneyManager provider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // --- IMPORTANT: The _registeredExpenses list is NO LONGER DECLARED HERE! ---
  // It is now managed entirely by MoneyManager (lib/providers/money_manager.dart).
  // Any lines like `final List<Expense> _registeredExpenses = [...];` should be removed from this file.

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const AddExpenseScreen(), // AddExpenseScreen now gets MoneyManager from Provider
    );
  }

  void _goToAccountsScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AccountsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // --- Access data from MoneyManager using Provider ---
    // We use Provider.of<MoneyManager>(context) to get the instance of our MoneyManager.
    // This widget will rebuild whenever MoneyManager calls notifyListeners().
    final moneyManager = Provider.of<MoneyManager>(context);
    final _registeredExpenses = moneyManager.expenses; // Get the list of expenses from MoneyManager
    // The accounts list is also available if needed, but not directly used in the main display here.
    // final _accounts = moneyManager.accounts;
    // --- END Access data from MoneyManager ---

    // Content to display if there are no expenses
    Widget mainContent = Center(
      child: Text(
        'No expenses found. Start adding some!',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );

    // If there are expenses, display the ExpensesList
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        // When an expense is removed (via swipe-to-delete),
        // call the removeExpense method on the MoneyManager provider.
        onRemoveExpense: (expense) {
          final expenseIndex = _registeredExpenses.indexOf(expense); // Store index for undo
          moneyManager.removeExpense(expense); // Use provider's remove method

          ScaffoldMessenger.of(context).clearSnackBars(); // Clear previous snackbars
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Expense deleted.'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  moneyManager.insertExpense(expenseIndex, expense); // Use provider's insert for undo
                },
              ),
            ),
          );
        },
        // When the user pulls down to refresh, call the fetchExpensesAndAccounts method
        // on the MoneyManager provider.
        onRefresh: () async {
          await moneyManager.fetchExpensesAndAccounts(); // Call the global refresh method
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expenses refreshed!')),
          );
        },
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
          IconButton(
            onPressed: _goToAccountsScreen,
            icon: const Icon(Icons.account_balance_wallet),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                // The Chart widget also receives the expenses from MoneyManager
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent, // Either the list or the "no expenses" message
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