import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:biteatui/models/all_entry.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  late Product product;
  String cuisine = "";
  String canteen = "";
  String stall = "";

  @override
  void initState() {
    super.initState();
    product = widget.product;
    //fetchDetailedProductInfo();
  }

  Future<void> fetchDetailedProductInfo() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://localhost:8000/detailed_product_info/${product.pk}/');

      // Decode JSON string to a Map
      Map<String, dynamic> jsonData = jsonDecode(response.body);

      setState(() {
        stall = jsonData['stall'];
        canteen = jsonData['canteen'];
        cuisine = jsonData['cuisine'];
      });
    } catch (e) {
      print("Error fetching detailed product info: $e");
    }
  }

  Future<List<Review>> fetchReviews(CookieRequest request, int productId) async {
    final response = await request.get('http://localhost:8000/show_json/');
    List<Review> reviews = [];

    if (response["reviews"] != null) {
      for (var r in response["reviews"]) {
        if (r != null && r["fields"]["product"] == productId) {
          reviews.add(Review.fromJson(r));
        }
      }
    }

    return reviews;
  }

  Future<void> submitReview(String request, int productId, int rating, String comment) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/submit-review-flutter/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $request',
      },
      body: jsonEncode({
        'product_id': productId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        print("Review submitted successfully.");
      } else {
        print("Error: ${data['error']}");
      }
    } else {
      print("Failed to submit review. Status code: ${response.statusCode}");
    }
  }


  Future<void> deleteReview(String request, int reviewId) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/delete-review-flutter/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $request',
      },
      body: jsonEncode({'review_id': reviewId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        print("Review deleted successfully.");
      } else {
        print("Error: ${data['error']}");
      }
    } else {
      print("Failed to delete review. Status code: ${response.statusCode}");
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
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: snapshot.data!.isEmpty
                      ? const Center(child: Text('No reviews yet.'))
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Review review = snapshot.data![index];
                            return ListTile(
                              title: Text('Rating: ${review.fields.rating}'),
                              subtitle: Text(review.fields.comment),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteReview(request.headers['Authorization']!, review.pk);
                                },
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
                                  decoration: const InputDecoration(labelText: 'Rating (1-5)'),
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
                                  submitReview(request.headers['Authorization']!, product.pk, rating, comment);
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
