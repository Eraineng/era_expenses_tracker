// lib/models/account.dart
import 'package:uuid/uuid.dart';

const uuid = Uuid(); // Use the same uuid generator

enum AccountType { cash, bank, creditCard, other }

// A map to associate each account type with an icon
const accountTypeIcons = {
  AccountType.cash: (icon: '💵', label: 'Cash'),
  AccountType.bank: (icon: '🏦', label: 'Bank'),
  AccountType.creditCard: (icon: '💳', label: 'Credit Card'),
  AccountType.other: (icon: '💼', label: 'Other'),
};

class Account {
  Account({
    required this.name,
    this.initialBalance = 0.0, // Default to 0.0
    required this.currentBalance,
    required this.type,
  }) : id = uuid.v4();

  final String id;
  String name; // Make mutable if we allow editing account names
  double initialBalance;
  double currentBalance;
  AccountType type;

  // Add a method to update the balance
  void updateBalance(double amount) {
    currentBalance += amount;
  }
}