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
│   │   └── account.dart         # Model apply different wallet
│   │   └── expense.dart         # Model representing an expense item
│   ├── screens
│   │   ├── home_screen.dart     # Main interface displaying expenses
│   │   └── add_expense_screen.dart # Form for adding new expenses
│   │   └── login_screen.dart # Main interface for Login
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
   git clone https://github.com/Eraineng/era_expenses_tracker.git
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

6. Update and push changes
   ```
   git add .
   git commit -m "remark"
   git push
   ```

## Run app in android emulator
1. Open android studio
2. Click on "More Actions"
3. Click on Virtual Device Manager
4. Click Play button on any target android virtual device
5. In VSCode's terminal locate to project folder
6. Insert command "flutter run" and press Enter

## View Changes
If you're changing initial data, adding a new expense logic to _addExpense, or modifying anything in main.dart (like theme colors), do a Hot Restart (the circular arrow in VS Code debug toolbar, or R in the terminal).

in short
Flutter run key commands.
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

## Usage

- Launch the app to view the home screen.
- user Eraine and 1234@Abcd for login
- Use the "Add Expense" button to input new expenses.
- View the list of expenses and their details.
- Use the chart to visualize your spending habits.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.


