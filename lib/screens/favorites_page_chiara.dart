import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '/models/all_entry.dart'; 

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Product>> fetchFavorites(CookieRequest request) async {
    // 1) Fetch the JSON array from your Django endpoint
    final favoritesResponse = await request.get('http://localhost:8000/favorites/json/');
    print (favoritesResponse);

    List<Product> favorites = [];

    // 2) Parse each favorite’s "product" object right away
    for (var item in favoritesResponse) {
      final prodJson = item['product']; 
      favorites.add(
        Product(
          model: 'main.product', 
          pk: prodJson['id'], 
          fields: Fields(
            name: prodJson['name'],
            price: prodJson['price'],
            stall: prodJson['stall']['name'], 
          ),
        ),
      );
    }

    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchFavorites(request),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          // 4) Display loading, empty, or your grid of favorite products
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onRemove: () {
                    // When "unfavorite" completes, refresh
                    setState(() {});
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// A reusable card widget for each favorite product
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pictures/default_food.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.fields.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp${product.fields.price}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stall: ${product.fields.stall}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54, // or any color you like
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        // 5) Unfavorite the product
                        final request = context.read<CookieRequest>();
                        await request.post(
                          'http://localhost:8000/unfavorite/${product.pk}/',
                          {},
                        );
                        onRemove(); 
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String model;  
  final int pk;        
  final Fields fields; 

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });
}

class Fields {
  final String name;
  final String price;
  final String stall;

  Fields({
    required this.name,
    required this.price,
    required this.stall,
  });
}
