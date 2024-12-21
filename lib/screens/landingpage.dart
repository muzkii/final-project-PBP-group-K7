import 'package:flutter/material.dart';
import 'login.dart'; // Ensure proper import paths
import 'register.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Image
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background-landingpage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
            ),
            // Welcome Text
            Positioned(
              top: size.height * 0.25,
              child: SizedBox(
                width: size.width * 0.9,
                child: const Text(
                  'Welcome to',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 45,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.25,
                  ),
                ),
              ),
            ),
            // BITE@UI Text
            Positioned(
              top: size.height * 0.32,
              child: SizedBox(
                width: size.width * 0.9,
                child: const Text(
                  'BITE@UI',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFFF79022),
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            // Subtitle Text
            Positioned(
              top: size.height * 0.40,
              child: SizedBox(
                width: size.width * 0.9,
                child: const Text(
                  'All your favorite canteens, available at the\nswipe of a hand',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
            // Rotated Logo
            Positioned(
              top: size.height * 0.63,
              child: Transform.rotate(
                angle: 0.02,
                child: Container(
                  width: size.width * 0.2,
                  height: size.height * 0.1,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            // Register Now with Lines
            Positioned(
              top: size.height * 0.72,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.52,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Input Field (Register with Username)
            Positioned(
              top: size.height * 0.78,
              child: Container(
                width: size.width * 0.6,
                height: size.height * 0.07,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFF79022),
                  ),
                ),
                child: Center(
                  child: TextField(
                    controller: _usernameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Register With Username',
                      hintStyle: TextStyle(
                        color: Color(0xFFD9D9D9),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.48,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            // Sign In Text
            Positioned(
              top: size.height * 0.88,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        username: _usernameController.text,
                      ),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Have an Account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          color: Color(0xFFF79022),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
