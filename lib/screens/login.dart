import 'menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'register.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
        ).copyWith(secondary: Colors.deepOrange[400]),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String username;

  const LoginPage({super.key, this.username = ''});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.username);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5EA), // Set the background color
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFFFFF5EA), // Match background
        elevation: 0, // Remove shadow to blend AppBar with background
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and Tagline (Outside Card)
              Column(
                children: [
                  Image.asset(
                    'assets/pictures/logo.png', // Add your image to assets and reference it here
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 12.0),
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

              const SizedBox(height: 30.0),

              // Input Fields (Inside Card)
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _usernameController,
                        cursorColor: Colors.orange,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Background color
                          labelText: 'Username',
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0), // Rounded corners
                            borderSide: BorderSide.none, // Remove border
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      TextField(
                        controller: _passwordController,
                        cursorColor: Colors.orange,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock),
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

              const SizedBox(height: 24.0),

              // Login Button (Outside Card)
              ElevatedButton(
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  final response = await request.login(
                    "http://localhost:8000/auth/login/",
                    {
                      'username': username,
                      'password': password,
                    },
                  );

                  if (request.loggedIn) {
                    String message = response['message'];
                    String uname = response['username'];
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text("$message Welcome, $uname.")),
                        );
                    }
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login Failed'),
                          content: Text(response['message']),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Explore the app',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600, // Optional: Adjust font weight if needed
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.arrow_right_alt),
                  ],
                ),
              ),

              const SizedBox(height: 36.0),

              // Register Prompt (Outside Card)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    color: Colors.orange, // Set consistent orange color
                    fontSize: 16.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}