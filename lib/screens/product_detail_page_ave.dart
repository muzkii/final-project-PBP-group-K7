import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:biteatui/models/all_entry.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  Future<User?> fetchUser(CookieRequest request, int userId) async {
    final response = await request.get('http://localhost:8000/show_json/');
    if (response["users"] != null) {
      for (var u in response["users"]) {
        if (u != null && u["pk"] == userId) {
          return User.fromJson(u);
        }
      }
    }
    return null;
  }
  
  Future<List<Review>> fetchReviews(CookieRequest request, int productId) async {
    final response = await request.get('http://localhost:8000/show_json/');
    List<Review> reviews = [];

    if (response["reviews"] != null) {
      for (var r in response["reviews"]) {
        if (r != null && r["fields"]["product"] == productId) {
          Review review = Review.fromJson(r);
          User? user = await fetchUser(request, review.fields.user);
          if (user != null) {
            review.fields.username = user.fields.username; // Add username to review fields
          }
          reviews.add(review);
        }
      }
    }

    return reviews;
  }

  Future<void> submitReview(CookieRequest request, int productId, int rating, String comment) async {
    try {
      final response = await request.post(
        'http://localhost:8000/submit-review-flutter/',
        jsonEncode({
          'product_id': productId.toString(),
          'rating': rating.toString(),
          'comment': comment,
          'headers': {
            'Content-Type': 'application/json',
          },
        }),
      );
      if (response['success'] == true) {
        print("Review submitted successfully.");
        setState(() {}); // Refresh the reviews
      } else {
        print("Error: ${response['error']}");
      }
    } catch (e) {
      print("Failed to submit review. Error: $e");
    }
  }

  Future<void> deleteReview(CookieRequest request, int reviewId) async {
    try {
      final response = await request.post(
        'http://localhost:8000/delete-review-flutter/',
        jsonEncode({
          'review_id': reviewId.toString(),
          'headers': {
            'Content-Type': 'application/json',
          },
        }),
      );
      if (response['success'] == true) {
        print("Review deleted successfully.");
        setState(() {}); // Refresh the reviews
      } else {
        print("Error: ${response['error']}");
      }
    } catch (e) {
      print("Failed to delete review. Error: $e");
    }
  }

  Future<void> addToFavorites(CookieRequest request, int productId) async {
    try {
      final response = await request.post(
        'http://localhost:8000/favorite/$productId/',
        {},
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add to favorites')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add to favorites')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.fields.name),
      ),
      body: FutureBuilder(
        future: fetchReviews(request, product.pk),
        builder: (context, AsyncSnapshot<List<Review>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    product.fields.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Price: ${product.fields.price}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Add to Favorites'),
                    onPressed: () async {
                      await addToFavorites(request, product.pk);
                    },
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Customer Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: snapshot.data!.isEmpty
                      ? const Center(child: Text('No reviews yet. Be the first to review this product!'))
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Review review = snapshot.data![index];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rating: ${review.fields.rating} / 10',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(review.fields.comment),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '- ${review.fields.username} on ${review.fields.createdAt}',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                                  ),
                                  
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          int rating = 0;
                          String comment = '';
                          return AlertDialog(
                            title: const Text('Submit Review'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: const InputDecoration(labelText: 'Comment'),
                                  onChanged: (value) {
                                    comment = value;
                                  },
                                ),
                                TextField(
                                  decoration: const InputDecoration(labelText: 'Rating (1-10)'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    rating = int.parse(value);
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  submitReview(request, product.pk, rating, comment);
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Add Review'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}