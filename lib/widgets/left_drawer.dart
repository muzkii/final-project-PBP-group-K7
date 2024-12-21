import 'package:flutter/material.dart';
import '../screens/menu.dart';
import 'package:biteatui/forms/product_form.dart';
import '../screens/stall_page.dart';
import '../screens/favorites_page.dart';
import 'package:biteatui/forms/canteen_form.dart';
import 'package:biteatui/forms/faculty_form.dart';
import 'package:biteatui/forms/stall_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Bite @ UI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Find your meal here!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home Page'),
            // Redirection part to MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Add Product'),
            // Redirection part to ProductFormPage
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductForm()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Stalls'),
            onTap: () {
              // need to pass the faculty ID 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StallPage(
                    facultyId: 1, // Replace with actual selected faculty ID
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Add Canteen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CanteenForm()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Add Faculty'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FacultyForm()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront),
            title: const Text('Add Stall'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StallForm()),
              );
            },
          ),
        ],
      ),
    );
  }
}