# Expenses Tracker Application

This is a Flutter application designed to help users track their expenses efficiently. The app allows users to add, view, and visualize their expenses through a user-friendly interface.

## Features

- Add new expenses with details such as title, amount, and date.
- View a list of all expenses.
- Visualize expenses through charts.
- Delete expenses as needed.

## Project Structure

```
era_expenses_tracker
├── lib
│   ├── main.dart                # Entry point of the application
│   ├── models
│   │   └── expense.dart         # Model representing an expense item
│   ├── screens
│   │   ├── home_screen.dart     # Main interface displaying expenses
│   │   └── add_expense_screen.dart # Form for adding new expenses
│   ├── widgets
│   │   ├── expense_list.dart     # Widget for displaying a list of expenses
│   │   ├── expense_item.dart      # Widget for a single expense item
│   │   └── chart.dart             # Widget for visualizing expenses
├── pubspec.yaml                  # Project configuration file
└── README.md                     # Documentation for the project
```

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd era_expenses_tracker
   ```
3. Install the dependencies:
   ```
   flutter pub get
   ```
4. Run the application:
   ```
   flutter run
   ```

5. All in one:
   ```
   flutter clean
   flutter pub get
   flutter run
   ```

## View Changes
If you're changing initial data, adding a new expense logic to _addExpense, or modifying anything in main.dart (like theme colors), do a Hot Restart (the circular arrow in VS Code debug toolbar, or R in the terminal).


## Usage

- Launch the app to view the home screen.
- Use the "Add Expense" button to input new expenses.
- View the list of expenses and their details.
- Use the chart to visualize your spending habits.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.