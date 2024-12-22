import 'package:flutter/material.dart';
import 'screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'screens/landingpage.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) => CookieRequest()),
      ],
      child: Consumer<CookieRequest>(
        builder: (context, request, child) {
          return MaterialApp(
            title: 'Bite @ UI',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepOrange,
              ).copyWith(secondary: Colors.deepOrange[100]),
            ),
            home: request.loggedIn ? MyHomePage() : LandingPage(),
          );
        },
      ),
    );
  }
}