// lib/screens/add_account_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package

import 'package:era_expenses_tracker/models/account.dart'; // Import the Account model
import 'package:era_expenses_tracker/providers/money_manager.dart'; // Import our MoneyManager provider

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  // Controllers for the text input fields
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();

  // State variable for the selected account type, defaults to cash
  AccountType _selectedAccountType = AccountType.cash;

  // Dispose controllers when the widget is removed to prevent memory leaks
  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  // Function to handle the submission of new account data
  void _submitAccountData() {
    // Attempt to parse the entered initial balance to a double
    final enteredBalance = double.tryParse(_initialBalanceController.text);
    // Check for invalid balance: null if not a valid number, or negative
    final balanceIsInvalid = enteredBalance == null || enteredBalance < 0;

    // Validate inputs
    if (_nameController.text.trim().isEmpty || balanceIsInvalid) {
      // Show an error dialog if validation fails
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
            'Please make sure a valid name and non-negative initial balance was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return; // Stop function execution if input is invalid
    }

    // If inputs are valid, add the new account via the MoneyManager provider
    // We use `listen: false` because we're only dispatching an action (addAccount),
    // not listening for changes that would rebuild this widget.
    Provider.of<MoneyManager>(context, listen: false).addAccount(
      Account(
        name: _nameController.text,
        initialBalance: enteredBalance,
        currentBalance: enteredBalance, // For a new account, initial = current
        type: _selectedAccountType,
      ),
    );
    Navigator.pop(context); // Close the modal bottom sheet after submission
  }

  @override
  Widget build(BuildContext context) {
    // Get the height of the keyboard to adjust the view and prevent overflow
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: double.infinity, // Allow the sheet to take full height
      child: SingleChildScrollView( // Make content scrollable to avoid overflow when keyboard appears
        child: Padding(
          // Adjust padding dynamically based on keyboard space
          padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
          child: Column(
            children: [
              // Text field for account name
              TextField(
                controller: _nameController,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                ),
              ),
              Row(
                children: [
                  // Text field for initial balance
                  Expanded(
                    child: TextField(
                      controller: _initialBalanceController,
                      keyboardType: TextInputType.number, // Restrict to numbers
                      decoration: const InputDecoration(
                        prefixText: 'RM ', // Currency prefix
                        labelText: 'Initial Balance',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Dropdown to select account type
                  DropdownButton<AccountType>(
                    value: _selectedAccountType, // Currently selected type
                    items: AccountType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              // Display the friendly label for each account type
                              accountTypeIcons[type]!.label,
                            ),
                          ),
                        )
                        .toList(), // Convert iterable to a list of DropdownMenuItems
                    onChanged: (value) {
                      if (value == null) {
                        return; // Do nothing if null is selected (shouldn't happen with enum)
                      }
                      setState(() {
                        _selectedAccountType = value; // Update selected type
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Buttons for Cancel and Save Account
              Row(
                children: [
                  const Spacer(), // Pushes buttons to the right
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the modal bottom sheet
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitAccountData, // Call submit function
                    child: const Text('Save Account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}