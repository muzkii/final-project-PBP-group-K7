import 'package:flutter/material.dart';
import 'package:biteatui/screens/menu.dart';
import 'package:biteatui/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  int _stall = 0;
  String? _selectedStall; // Stall's primary key
  List<dynamic> _stalls = []; // List to hold stalls fetched from the API

  @override
  void initState() {
    super.initState();
    _fetchStalls();
  }

  Future<void> _fetchStalls() async {
    const url = "http://localhost:8000/show_json/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _stalls = data['stalls']; // Fetch stalls from the JSON response
        });
      } else {
        throw Exception("Failed to fetch stalls");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching stalls: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
        appBar: AppBar(
            title: const Center(
            child: Text(
                'Add Your Product',
            ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
        ),
        // Add the created drawer here
        drawer: const LeftDrawer(),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _name = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Name cannot be empty!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                        value: _selectedStall,
                        decoration: InputDecoration(
                            hintText: "Stall",
                            labelText: "Stall",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            ),
                        ),
                        items: _stalls.map<DropdownMenuItem<String>>((dynamic stall) {
                            return DropdownMenuItem<String>(
                            value: stall['pk'].toString(),
                            child: Text(stall['fields']['name']), // Adjust field name based on JSON
                            );
                        }).toList(),
                        onChanged: (String? value) {
                            setState(() {
                            _selectedStall = value;
                            });
                        },
                        validator: (String? value) {
                            if (value == null || value.isEmpty) {
                            return "Stall must be selected!";
                            }
                            return null;
                        },
                    ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Price",
                        labelText: "Price",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _price = int.tryParse(value!) ?? 0;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Price cannot be empty!";
                        }
                        if (int.tryParse(value) == null) {
                          return "Price must be a number!";
                        }
                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                        ),
                        onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                                // Send request to Django and wait for the response
                                // TODO: Change the URL to your Django app's URL. Don't forget to add the trailing slash (/) if needed.
                                final response = await request.postJson(
                                    "http://localhost:8000/create-product-flutter/",
                                    jsonEncode(<String, String>{
                                        'name': _name,
                                        'stall': _selectedStall!,
                                        'price': _price.toString(),
                                    }),
                                );
                                if (context.mounted) {
                                    if (response['status'] == 'success') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                        content: Text("New product has saved successfully!"),
                                        ));
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => MyHomePage()),
                                        );
                                    } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content:
                                                Text("Something went wrong, please try again."),
                                        ));
                                    }
                                }
                            }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}