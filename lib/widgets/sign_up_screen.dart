import 'package:flutter/material.dart';
import '../Access/UserAccess.dart';
import '../Models/User.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to handle user registration
  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Create a User object with form data
      User newUser = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Call the UserAccess class to insert the new user
      UserAccess userAccess = UserAccess();
      await userAccess.insertUser(newUser);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Welcome ${_nameController.text}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 350,
                  ),
                ],
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _registerUser,  // Call the registration method
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Sign up"),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
