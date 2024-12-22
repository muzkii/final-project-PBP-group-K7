import 'dart:convert';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EA), // Light cream background
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and Branding
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png', // Replace with your logo asset path
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bite@UI',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'InriaSerif',
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Find Your Next Favorite Dish at UI with Bite@UI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'InriaSerif',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Form Fields
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          cursorColor: Colors.orange,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white, // Background color
                            labelText: 'Username',
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none, // No border outline
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.orange,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _confirmPasswordController,
                          cursorColor: Colors.orange,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Register Button (Reverted to original)
                ElevatedButton(
                  onPressed: () async {
                    String username = _usernameController.text.trim();
                    String password1 = _passwordController.text;
                    String password2 = _confirmPasswordController.text;

                    if (username.isEmpty) {
                      setState(() {
                        _errorMessage = 'Username cannot be empty';
                      });
                      return;
                    }
                    if (password1 != password2) {
                      setState(() {
                        _errorMessage = 'Passwords do not match';
                      });
                      return;
                    }

                    // Send request
                    final response = await request.postJson(
                      "http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/auth/register/",
                      jsonEncode({
                        "username": username,
                        "password1": password1,
                        "password2": password2,
                      }),
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        _showSnackbar('Successfully registered!');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else {
                        setState(() {
                          _errorMessage = response['message'] ??
                              'Failed to register. Please try again.';
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50), // Stretched button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded button
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
