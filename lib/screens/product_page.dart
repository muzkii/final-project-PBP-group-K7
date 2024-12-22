import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:biteatui/models/all_entry.dart';
import 'product_detail_page.dart';
import '../providers/user_provider.dart';
import 'dart:convert';

class ProductPage extends StatefulWidget {
  final int? stallId;

  const ProductPage({Key? key, this.stallId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  void refreshPage() {
    setState(() {});
  }

  Future<List<Product>> fetchProducts(CookieRequest request) async {
    String url = 'http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/products_json/'; // Updated endpoint
    
    // If stallId is provided, append it as a query parameter
    if (widget.stallId != null) {
      url += '?stall_id=${widget.stallId}';
    }

    final response = await request.get(url);

    // Check for errors in the response
    if (response == null || response['status'] == 'error') {
      throw Exception(response != null ? response['message'] : 'Unknown error');
    }

    // Convert JSON data to Product objects
    List<Product> products = [];
    for (var d in response["products"]) {
      if (d != null) {
        products.add(Product.fromJson(d));
      }
    }
    return products;
  }

  void deleteProduct(BuildContext context, CookieRequest request, int productId, Function refreshPage) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await request.post('http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/delete-product-flutter/$productId/', {});
              if (response['status'] == 'success') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Product deleted successfully!")),
                );
                setState(() {}); // Refresh the product list after deletion
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to delete product.")),
                );
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              refreshPage();
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void editProduct(BuildContext context, CookieRequest request, Product product, Function refreshPage) async {
    final nameController = TextEditingController(text: product.fields.name);
    final priceController = TextEditingController(text: product.fields.price);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final response = await request.post(
                'http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/edit-product-flutter/${product.pk}/',
                jsonEncode({
                  'name': nameController.text,
                  'price': priceController.text,
                  'stall': product.fields.stall.toString(),
                })
              );
              if (response['status'] == 'success') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Product updated successfully!")),
                );
                setState(() {}); // Refresh the product list after deletion
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update product.")),
                );
              }
              if (!context.mounted) return;
              Navigator.pop(context);
              refreshPage();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No products found.',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Product product = snapshot.data![index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      product.fields.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text("Price: ${product.fields.price}"),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/id/1457433817/photo/group-of-healthy-food-for-flexitarian-diet.jpg?s=612x612&w=0&k=20&c=v48RE0ZNWpMZOlSp13KdF1yFDmidorO2pZTu2Idmd3M=',
                      ),
                    ),
                    trailing: userProvider.isStaff
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  editProduct(context, request, snapshot.data![index], refreshPage);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteProduct(context, request, snapshot.data![index].pk, refreshPage);
                                },
                              ),
                            ],
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}