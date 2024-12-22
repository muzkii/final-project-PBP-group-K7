import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/landingpage.dart';
import 'screens/faculty_canteen_page.dart';
import 'screens/product_page.dart';
import 'screens/stall_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: Consumer<CookieRequest>(
        builder: (context, request, child) {
          return MaterialApp(
            title: 'Bite @ UI',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
              ).copyWith(secondary: Colors.deepPurple[400]),
            ),
            home: request.loggedIn ? MyHomePage() : LandingPage(),
          );
        },
      ),
    );
  }
}