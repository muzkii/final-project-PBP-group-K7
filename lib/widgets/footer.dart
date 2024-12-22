import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../forms/faculty_form.dart'; 
import '../forms/canteen_form.dart'; 
import '../forms/stall_form.dart'; 
import '../forms/product_form.dart'; 

class Footer extends StatelessWidget {
  final VoidCallback onAddFaculty;
  final VoidCallback onAddCanteen;
  final VoidCallback onAddStall;
  final VoidCallback onAddProduct;

  const Footer({
    super.key,
    required this.onAddFaculty,
    required this.onAddCanteen,
    required this.onAddStall,
    required this.onAddProduct,
  });

  void showAddOptionsModal(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Wrap(
        children: [
          if (userProvider.isStaff) ...[
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: const Text("Add Faculty"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FacultyForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.green),
              title: const Text("Add Canteen"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CanteenForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.storefront, color: Colors.orange),
              title: const Text("Add Stall"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StallForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.red),
              title: const Text("Add Product"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductForm()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return userProvider.isStaff
        ? FloatingActionButton(
            onPressed: () => showAddOptionsModal(context),
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add, color: Colors.white),
          )
        : Container(); // Return an empty container if the user is not a staff member
  }
}