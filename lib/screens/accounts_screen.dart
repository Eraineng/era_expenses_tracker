// lib/screens/accounts_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:era_expenses_tracker/models/account.dart'; // Import the Account model
import 'package:era_expenses_tracker/providers/money_manager.dart'; // Import our MoneyManager provider
import 'package:era_expenses_tracker/screens/add_account_screen.dart'; // Import the screen for adding new accounts

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  // Function to open the modal bottom sheet for adding a new account
  void _openAddAccountOverlay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true, // Ensures content is not obscured by device cutouts (like notches)
      isScrollControlled: true, // Allows the sheet to take full height
      context: context,
      builder: (ctx) => const AddAccountScreen(), // Our AddAccountScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    // We use Provider.of<MoneyManager>(context) to listen for changes
    // in the MoneyManager. When accounts are added/removed, this widget
    // will automatically rebuild.
    final moneyManager = Provider.of<MoneyManager>(context);
    final accounts = moneyManager.accounts; // Get the current list of accounts

    // Content to display if there are no accounts
    Widget content = Center(
      child: Text(
        'No accounts found. Start adding some!',
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );

    // If accounts exist, build a ListView to display them
    if (accounts.isNotEmpty) {
      content = ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (ctx, index) {
          final account = accounts[index];
          // Get the icon and label data based on the account type
          final accountTypeData = accountTypeIcons[account.type]!;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  // Display the emoji icon for the account type
                  Text(
                    accountTypeData.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display account name
                        Text(
                          account.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        // Display account type label (e.g., "Cash", "Bank")
                        Text(
                          accountTypeData.label,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Display current balance, formatted with RM
                  Text(
                    'RM${account.currentBalance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  // Button to delete the account
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () {
                      // Call the removeAccount method from MoneyManager
                      moneyManager.removeAccount(account);
                      // Show a SnackBar to confirm deletion
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${account.name} deleted.')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Accounts'), // Title of the screen
        actions: [
          IconButton(
            onPressed: () => _openAddAccountOverlay(context), // Button to add new account
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content, // Display either the list of accounts or the "no accounts" message
    );
  }
}