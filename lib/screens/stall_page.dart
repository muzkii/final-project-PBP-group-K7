// lib/screens/stall_page.dart

import 'package:biteatui/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biteatui/screens/product_page.dart'; // Import the ProductPage
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/all_entry.dart';
import '../providers/user_provider.dart';

void addStall(BuildContext context, CookieRequest request, Function refreshPage, int facultyId) async {
  final nameController = TextEditingController();
  final cuisineController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Add New Stall'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: cuisineController,
            decoration: const InputDecoration(labelText: 'Cuisine'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await request.post(
              'http://localhost/create-stall-flutter/',
              {
                'name': nameController.text,
                'cuisine_type': cuisineController.text,
                'faculty': facultyId.toString(),
              },
            );
            if (!context.mounted) return;
            Navigator.pop(context);
            refreshPage();
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

void editStall(BuildContext context, CookieRequest request, Stall stall, Function refreshPage, int facultyId) async {
  final nameController = TextEditingController(text: stall.fields.name);
  final cuisineController = TextEditingController(text: stall.fields.cuisine);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Stall'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: cuisineController,
            decoration: const InputDecoration(labelText: 'Cuisine'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await request.post(
              'http://localhost/edit-stall-flutter/${stall.pk}/',
              {
                'name': nameController.text,
                'cuisine_type': cuisineController.text,
                'faculty': facultyId.toString(),
              },
            );
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

void deleteStall(BuildContext context, CookieRequest request, int stallId, Function refreshPage, int facultyId) async {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Stall'),
      content: const Text('Are you sure you want to delete this stall?'),
      actions: [
        TextButton(
          onPressed: () async {
            await request.post('http://localhost/delete-stall-flutter/$stallId/', {});
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

class StallPage extends StatefulWidget {
  final int facultyId;
  final String? initialCuisine; // Added parameter

  const StallPage({
    super.key,
    required this.facultyId,
    this.initialCuisine, // Initialize the parameter
  });

  @override
  _StallPageState createState() => _StallPageState();
}

class _StallPageState extends State<StallPage> {
  List<Stall> allStalls = [];          // All fetched stalls
  List<Stall> displayedStalls = [];    // Stalls to display based on filter
  String selectedCuisine = 'All';      // Currently selected cuisine

  // List of cuisine types matching the backend choices
  final List<String> cuisines = [
    'All',
    'Indonesian',
    'Chinese',
    'Western',
    'Japanese',
    'Korean',
    'Indian',
    'Beverages',
    'Dessert',
    'Others',
    'Italian', // Added to match menu.dart categories
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selectedCuisine with initialCuisine if provided
    selectedCuisine = widget.initialCuisine ?? 'All';
    fetchData();
  }

  void fetchData() async {
    final request = context.read<CookieRequest>();
    try {
      List<Stall> fetchedStalls = await fetchStallsByFaculty(request);
      setState(() {
        allStalls = fetchedStalls;
        filterStalls(); // Initialize displayedStalls based on selectedCuisine
      });
    } catch (e) {
      // Handle error appropriately, possibly set an error state
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching stalls: $e')),
      );
    }
  }

  Future<List<Stall>> fetchStallsByFaculty(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/show_json/');
    List<Stall> facultyStalls = [];
    var canteens = response["canteens"]
        .where((canteen) => canteen["fields"]["faculty"] == widget.facultyId)
        .toList();

    for (var stall in response["stalls"]) {
      if (stall != null) {
        if (canteens.any((c) => c["pk"] == stall["fields"]["canteen"])) {
          facultyStalls.add(Stall.fromJson(stall));
        }
      }
    }
    return facultyStalls;
  }

  void filterStalls() {
    if (selectedCuisine == 'All') {
      displayedStalls = allStalls;
    } else {
      displayedStalls = allStalls
          .where((stall) => stall.fields.cuisine.toLowerCase() == selectedCuisine.toLowerCase())
          .toList();
    }
  }

  void refreshPage() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food In'),
        backgroundColor: Colors.orange, // Optional: Match your theme
      ),
      body: Column(
        children: [
          // Existing Subtitle and Stars
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Find the food you wish to explore!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inria Serif',
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/pictures/stars2.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Existing Divider
          Container(
            width: screenWidth * 0.6,
            height: 1,
            color: Colors.black,
          ),
          const SizedBox(height: 16),

          // **Dropdown Filtering Section**
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text(
                  'Filter by Cuisine: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedCuisine,
                  items: cuisines.map((String cuisine) {
                    return DropdownMenuItem<String>(
                      value: cuisine,
                      child: Text(cuisine),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCuisine = newValue!;
                      filterStalls();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // **Stalls List Section**
          Expanded(
            child: displayedStalls.isEmpty
                ? const Center(child: Text('No stalls found for the selected cuisine.'))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    itemCount: displayedStalls.length,
                    itemBuilder: (_, index) {
                      final stall = displayedStalls[index];
                      return StallCard(
                        stall: stall,
                        onEdit: () => editStall(context, request, stall, refreshPage, widget.facultyId),
                        onDelete: () => deleteStall(context, request, stall.pk, refreshPage, widget.facultyId),
                        isStaff: userProvider.isStaff,
                        onTap: () { // Define the onTap behavior
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                stallId: stall.pk, // Pass the stall's primary key
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

          ),
        ],
      ),
      floatingActionButton: userProvider.isStaff ? Footer(
        onAddFaculty: () {}, // Not used
        onAddCanteen: () {}, // Not used
        onAddStall: () {
          addStall(context, request, refreshPage, widget.facultyId); // Add stall functionality
        },
        onAddProduct: () {}, // Not used
      ) : null,
    );
  }
}

class StallCard extends StatelessWidget {
  final Stall stall;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isStaff;
  final VoidCallback onTap; // Added onTap callback

  const StallCard({
    super.key,
    required this.stall,
    required this.onEdit,
    required this.onDelete,
    required this.isStaff,
    required this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Make the entire card tappable
      onTap: onTap, // Trigger the onTap callback
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stall Name
              Text(
                stall.fields.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              // Cuisine Type
              Text(
                'Cuisine: ${stall.fields.cuisine}',
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const Spacer(),
              // Action Buttons
              if (isStaff) ...[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  // Edit Button
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit Stall',
                    ),
                  // Delete Button
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete Stall',
                    ),
                  ],
                ),
              ],
          ],
          ),
        ),
      ),
    );
  }
}

