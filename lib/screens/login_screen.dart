// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:era_expenses_tracker/screens/home_screen.dart'; // Import your HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey to uniquely identify our form and enable validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dispose controllers when the widget is removed to prevent memory leaks
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to handle login submission
  void _submitLogin() {
    // Validate all form fields
    if (_formKey.currentState!.validate()) {
      // If validation passes, attempt login
      final enteredUsername = _usernameController.text;
      final enteredPassword = _passwordController.text;

      // --- Simple Hardcoded Login Check ---
      // In a real app, you would send these to an authentication service
      // or database. For now, let's use a creative, friendly default!
      const String validUsername = 'eraine'; // Your special username!
      const String validPassword = '1234@Abcd'; // Your secret password!

      if (enteredUsername == validUsername && enteredPassword == validPassword) {
        // Successful login! Navigate to the HomeScreen
        // pushReplacement removes the LoginScreen from the stack,
        // so the user can't go back to it with the back button.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const HomeScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, $enteredUsername! Happy tracking!'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Failed login
        ScaffoldMessenger.of(context).clearSnackBars(); // Clear previous snackbars
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username or password. Please try again.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to ERA Tracker'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Assign the form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Creative App Icon/Logo (Optional but nice!) ---
                  Icon(
                    Icons.account_balance_wallet,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Personal Expense Journal',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Username Input
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your username.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next, // Go to next field on "done"
                  ),
                  const SizedBox(height: 15),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true, // Hide password input
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password.';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done, // Submit on "done"
                    onFieldSubmitted: (_) => _submitLogin(), // Trigger login on keyboard submit
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  ElevatedButton.icon(
                    onPressed: _submitLogin,
                    icon: const Icon(Icons.login),
                    label: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Make button full width
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}