import 'package:flutter/material.dart';

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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.school, color: Colors.blue),
            title: const Text("Add Faculty"),
            onTap: () {
              Navigator.pop(context);
              onAddFaculty();
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant, color: Colors.green),
            title: const Text("Add Canteen"),
            onTap: () {
              Navigator.pop(context);
              onAddCanteen();
            },
          ),
          ListTile(
            leading: const Icon(Icons.storefront, color: Colors.orange),
            title: const Text("Add Stall"),
            onTap: () {
              Navigator.pop(context);
              onAddStall();
            },
          ),
          ListTile(
            leading: const Icon(Icons.fastfood, color: Colors.red),
            title: const Text("Add Product"),
            onTap: () {
              Navigator.pop(context);
              onAddProduct();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddOptionsModal(context),
      backgroundColor: Colors.orange,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
