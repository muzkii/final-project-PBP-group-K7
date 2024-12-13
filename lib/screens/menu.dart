import 'package:flutter/material.dart';
import '../widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  // Create a GlobalKey to manage the Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<ItemHomepage> items = [
    ItemHomepage("View Product List", Icons.list),
    ItemHomepage("Add Product", Icons.add),
    ItemHomepage("Logout", Icons.logout),
  ];

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to the Scaffold

      // Drawer for navigation
      drawer: const LeftDrawer(),

      // Bottom navigation bar replacing the top AppBar
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); // Use the GlobalKey to open the drawer
              },
            ),
            const Text(
              'Bite @ UI',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 48), // Spacer to balance the layout
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Section
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/pictures/heading1_mieayam.png', // Correct asset path
                  width: double.infinity, // Full width of the container
                  height: screenHeight * 0.25, // Adjust height dynamically
                  fit: BoxFit.cover, // Ensures the image covers the header space
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15), // Rounded rectangle with smaller radius
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Find food just for you",
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins', // Apply Poppins font
                            fontSize: screenWidth * 0.025, // Responsive font size
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12, // Adjust padding for a more rectangular shape
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/pictures/search.png', // Update with the correct asset path
                        width: 38,
                        height: 38,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Popular Categories Section (Aligned with Search Bar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "POPULAR",
                        style: TextStyle(
                          fontFamily: 'Poppins', // Ensure the Poppins font is added
                          fontWeight: FontWeight.w600, // Semi-bold
                          fontSize: screenWidth * 0.06, // Responsive font size
                          color: Colors.orange, // Orange color for POPULAR
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.06, // Responsive font size
                          color: Colors.black, // Black color for Categories
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: screenWidth * 0.7, // Responsive line length
                    color: Colors.orange, // Orange color for the line
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Scrollable Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.18, // Adjust height dynamically
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing between items
                      children: [
                        // Indonesian Category
                        CategoryItem(
                          imagePath: 'assets/pictures/indonesian_circle.png',
                          label: "Indonesian",
                          screenWidth: MediaQuery.of(context).size.width,
                        ),
                        // Japanese Category
                        CategoryItem(
                          imagePath: 'assets/pictures/japanese_circle.png',
                          label: "Japanese",
                          screenWidth: MediaQuery.of(context).size.width,
                        ),
                        // Italian Category
                        CategoryItem(
                          imagePath: 'assets/pictures/italian_circle.png',
                          label: "Italian",
                          screenWidth: MediaQuery.of(context).size.width,
                        ),
                        // Chinese Category
                        CategoryItem(
                          imagePath: 'assets/pictures/chinese_circle.png',
                          label: "Chinese",
                          screenWidth: MediaQuery.of(context).size.width,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content Section (GridView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                primary: true,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You have pressed the ${item.name} button!")),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  final String imagePath;
  final String label;
  final double screenWidth;

  const CategoryItem({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.screenWidth,
  }) : super(key: key);

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isPressed = false; // Track hover/click state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true; // Button pressed
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have clicked on the ${widget.label} category!'),
          ),
        );
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false; // Button released
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false; // Reset when tap is canceled
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0), // Spacing between items
        child: Column(
          children: [
            Material(
              elevation: isPressed ? 12 : 6, // Darken shadow on press/hover
              shape: const CircleBorder(), // Ensures shadow is circular
              clipBehavior: Clip.hardEdge, // Clips child to match the circle
              child: ClipOval(
                child: Image.asset(
                  widget.imagePath, // Path to the circular image
                  width: widget.screenWidth * 0.125, // Image size
                  height: widget.screenWidth * 0.125,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6), // Space between image and text
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: widget.screenWidth * 0.03, // Font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}



