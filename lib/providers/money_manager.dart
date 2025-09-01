// lib/providers/money_manager.dart
import 'package:flutter/material.dart'; // Needed for ChangeNotifier and debugPrint
import 'package:era_expenses_tracker/models/expense.dart'; // Import Expense model
import 'package:era_expenses_tracker/models/account.dart'; // Import Account model

// This class extends ChangeNotifier, allowing widgets to listen for changes
// and rebuild when data managed by this class is updated.
class MoneyManager with ChangeNotifier {
  // --- Accounts Management ---
  // Private list of accounts, can only be modified internally.
  final List<Account> _accounts = [
    Account(
        name: 'Cash Wallet',
        initialBalance: 100.0,
        currentBalance: 100.0,
        type: AccountType.cash),
    Account(
        name: 'Bank Savings',
        initialBalance: 500.0,
        currentBalance: 500.0,
        type: AccountType.bank),
  ];

  // Public getter to provide an immutable copy of the accounts list.
  List<Account> get accounts {
    return [..._accounts];
  }

  // Method to find a specific account by its ID.
  Account? getAccountById(String id) {
    try {
      return _accounts.firstWhere((account) => account.id == id);
    } catch (e) {
      debugPrint('Account with ID $id not found: $e');
      return null;
    }
  }

  // Method to add a new account.
  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners(); // Notify all listening widgets about the change.
  }

  // Method to remove an existing account.
  void removeAccount(Account account) {
    // In a production app, you'd likely want to handle expenses
    // associated with this account (e.g., reassign or archive them)
    // before fully deleting the account to maintain data integrity.
    _accounts.remove(account);
    // You might also want to remove related expenses, or at least
    // make sure expense display handles missing accounts gracefully.
    _expenses.removeWhere((expense) => expense.accountId == account.id);
    notifyListeners();
  }

  // --- Expenses Management ---
  // Private list of expenses.
  final List<Expense> _expenses = [];

  // Public getter for expenses.
  List<Expense> get expenses {
    return [..._expenses];
  }

  // Constructor: This runs when MoneyManager is first created (e.g., in main.dart).
  MoneyManager() {
    _addInitialExpenses();
  }

  // Helper method to populate initial sample expenses.
  void _addInitialExpenses() {
    // Ensure we have accounts to link expenses to.
    if (_accounts.isEmpty) {
      debugPrint("No accounts to link initial expenses. Skipping initial expenses.");
      return;
    }

    final cashAccount = _accounts.firstWhere((acc) => acc.name == 'Cash Wallet');
    final bankAccount = _accounts.firstWhere((acc) => acc.name == 'Bank Savings');

    // Add initial expenses. We use `doNotNotify: true` to optimize performance
    // by only calling `notifyListeners` once after all initial additions.
    addExpense(
      Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now().subtract(const Duration(days: 2)),
        category: Category.work,
        accountId: bankAccount.id, // Linked to Bank Account
      ),
      doNotNotify: true,
    );
    addExpense(
      Expense(
        title: 'Cinema Ticket',
        amount: 15.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: Category.leisure,
        accountId: cashAccount.id, // Linked to Cash Account
      ),
      doNotNotify: true,
    );
    addExpense(
      Expense(
        title: 'Groceries',
        amount: 45.00,
        date: DateTime.now(),
        category: Category.food,
        accountId: cashAccount.id, // Linked to Cash Account
      ),
      doNotNotify: true,
    );

    // Sort expenses by date (newest first)
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners(); // Now notify all listeners once.
  }

  // Method to add a new expense.
  void addExpense(Expense expense, {bool doNotNotify = false}) {
    _expenses.add(expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date)); // Keep the list sorted

    // Update the balance of the associated account.
    final account = getAccountById(expense.accountId);
    account?.updateBalance(-expense.amount); // Expense decreases balance.

    if (!doNotNotify) {
      notifyListeners();
    }
  }

  // Method to remove an expense.
  void removeExpense(Expense expense) {
    final expenseIndex = _expenses.indexOf(expense);
    if (expenseIndex >= 0) {
      _expenses.removeAt(expenseIndex);

      // Revert the account balance when an expense is removed.
      final account = getAccountById(expense.accountId);
      account?.updateBalance(expense.amount); // Removing expense increases balance.

      notifyListeners();
    }
  }

  // Method to insert an expense (primarily for the undo functionality).
  void insertExpense(int index, Expense expense) {
    _expenses.insert(index, expense);

    // Update the balance when an expense is re-inserted.
    final account = getAccountById(expense.accountId);
    account?.updateBalance(-expense.amount); // Adding expense back decreases balance.

    notifyListeners();
  }

  // --- Global Refresh/Fetch Logic ---
  // This method simulates fetching new data (accounts and expenses)
  // from a source and updates the lists.
  Future<void> fetchExpensesAndAccounts({bool showLoading = true}) async {
    if (showLoading) {
      debugPrint("Simulating data fetch for expenses and accounts...");
    }

    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay.

    // Simulate adding a new expense, linked to a random existing account.
    if (_accounts.isNotEmpty) {
      final randomAccount = _accounts[(_expenses.length) % _accounts.length];
      addExpense(
        Expense(
          title: 'Refreshed Global Item! ✨',
          amount: (20 + _expenses.length * 0.5), // Ensure unique amount
          date: DateTime.now(),
          category: Category.values[(_expenses.length) % Category.values.length],
          accountId: randomAccount.id,
        ),
        doNotNotify: true, // Will notify once at the end
      );
    }

    // You could also simulate adding a new account here if desired:
    // addAccount(Account(
    //   name: 'New Card ${(_accounts.length + 1)}',
    //   currentBalance: 0.0,
    //   initialBalance: 0.0,
    //   type: AccountType.creditCard,
    // ));

    _expenses.sort((a, b) => b.date.compareTo(a.date)); // Re-sort after potential additions.
    notifyListeners(); // Notify all listeners that the data has changed.

    if (showLoading) {
      debugPrint("Data fetch complete!");
    }
  }
}