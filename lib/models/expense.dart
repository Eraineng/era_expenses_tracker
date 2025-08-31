import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Generates unique IDs for our expenses
const uuid = Uuid();

// Formatter for dates
final formatter = DateFormat.yMd();

// Enum to define different expense categories
enum Category { food, travel, leisure, work }

// A map to associate each category with an icon
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

// The Expense model class
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); // Generate a unique ID when an expense is created

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // Getter to provide a nicely formatted date
  String get formattedDate {
    return formatter.format(date);
  }
}

// A helper class to group expenses by category for potential chart use
class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  // Constructor to create a bucket from a category and a list of all expenses
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  // Getter to calculate the total expenses for this bucket
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }
    return sum;
  }
}