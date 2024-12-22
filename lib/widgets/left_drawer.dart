import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../screens/faculty_canteen_page.dart';
import '../screens/stall_page.dart';
import '../screens/product_page.dart';
import '../screens/product_detail_page_ave.dart';
import '../screens/favorites_page_chiara.dart';
import '../forms/canteen_form.dart';
import '../forms/faculty_form.dart';
import '../forms/stall_form.dart';
import '../forms/product_form.dart';
import '../screens/landingpage.dart';
import '../providers/user_provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFF79022), // Orange background
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
            leading: const Icon(Icons.local_dining),
            title: const Text('Faculty Canteen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CanteenPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('Stalls'),
            onTap: () {
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
            leading: const Icon(Icons.inventory),
            title: const Text('Products Overview'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Product Details'),
            onTap: () {
              // ignore: prefer_typing_uninitialized_variables
              var product;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
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
          if (userProvider.isStaff) ...[
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
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Add Product'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductForm()),
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Declare `request` inside the onTap function
              final request = context.read<CookieRequest>();

              // Call the logout method
              final response = await request.logout("http://localhost:8000/auth/logout/");
              if (context.mounted) {
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Logout successful! Goodbye, $uname.")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LandingPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response["message"] ?? "Logout failed.")),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}