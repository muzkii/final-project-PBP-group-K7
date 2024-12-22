import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Product>> fetchFavorites(CookieRequest request) async {
    try {
      final favoritesResponse =
          await request.get('http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/favorites/json/');
      print('Favorites Response: $favoritesResponse');

      return favoritesResponse.map<Product>((item) {
        final prodJson = item['product'];

        // Debugging log
        print(
            'Processing product: ${prodJson['name']}, Price: ${prodJson['price']}');

        return Product(
          model: 'main.product',
          pk: prodJson['id'],
          fields: Fields(
            name: prodJson['name'],
            price: double.tryParse(prodJson['price'].toString()) ?? double.nan, // Convert price to double
            stall: prodJson['stall']?['name'] ?? 'Unknown Stall',
          ),
        );
      }).toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
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
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth / 3; // Subtract padding and spacing
    final imageHeight = cardWidth * 0.75; // Aspect ratio for image

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            height: imageHeight,
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
              mainAxisSize: MainAxisSize.min,
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
                  'Rp${product.fields.price.toStringAsFixed(0)}',
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
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () async {
                        final request = context.read<CookieRequest>();
                        await request.post(
                          'http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/unfavorite/${product.pk}/',
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
  final double price; // Changed to double
  final String stall;

  Fields({
    required this.name,
    required this.price,
    required this.stall,
  });
}