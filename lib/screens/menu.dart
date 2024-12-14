import 'package:flutter/material.dart';
import '../widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<ItemHomepage> items = [
    ItemHomepage("View Product List", Icons.list),
    ItemHomepage("Add Product", Icons.add),
    ItemHomepage("Logout", Icons.logout),
  ];

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.8;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const LeftDrawer(),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
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
            const SizedBox(width: 48),
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
                  'assets/pictures/heading1_mieayam.png',
                  width: double.infinity,
                  height: screenHeight * 0.25,
                  fit: BoxFit.cover,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Find food just for you",
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: screenWidth * 0.025,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/pictures/search.png',
                        width: 38,
                        height: 38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Popular Categories
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
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.06,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * 0.06,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 3,
                    width: screenWidth * 0.7,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: screenHeight * 0.18,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final categories = [
                          {'image': 'assets/pictures/indonesian_circle.png', 'label': 'Indonesian'},
                          {'image': 'assets/pictures/japanese_circle.png', 'label': 'Japanese'},
                          {'image': 'assets/pictures/italian_circle.png', 'label': 'Italian'},
                          {'image': 'assets/pictures/chinese_circle.png', 'label': 'Chinese'}
                        ];
                        return CategoryItem(
                          imagePath: categories[index]['image']!,
                          label: categories[index]['label']!,
                          screenWidth: screenWidth,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // "Don't know what to get?" Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Don't know what to get?",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                  const SizedBox(height: 3),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'InriaSerif',
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.030,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: "Here are some "),
                        TextSpan(
                          text: "recommendations",
                          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(text: " from our local pacil coder's"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Recommendations Cards
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                children: [
                  RecommendationCard(
                    imagePath: 'assets/pictures/tomoro.png',
                    recommendationText: "chi's recommendation",
                    title: "Caramel Machiato",
                    subTitle: "TOMORO Coffee",
                    faculty: "FISIP UI",
                    price: "23k",
                    cardWidth: cardWidth,
                  ),
                  const SizedBox(width: 16),
                  RecommendationCard(
                    imagePath: 'assets/pictures/bebek_madura.png',
                    recommendationText: "ari's recommendation",
                    title: "Bebek Madura",
                    subTitle: "Kantin FIB",
                    faculty: "FIB UI",
                    price: "20k",
                    cardWidth: cardWidth,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Hits under 15K section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Hits under 15K!" Section Title
                  Row(
                    children: [
                      Text(
                        "Hits under 15K!",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.width * 0.06, // Same size as "Don't know what to get?"
                        ),
                      ),
                      const SizedBox(width: 8), // Spacing between text and stars
                      Image.asset(
                        'assets/pictures/stars.png', // Path to the stars asset
                        width: 24, // Adjust as necessary
                        height: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Underline
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.7, 
                    color: Colors.orange, // Same color as the other line
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Content Section (GridView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
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

class RecommendationCard extends StatelessWidget {
  final String imagePath;
  final String recommendationText;
  final String title;
  final String subTitle;
  final String faculty;
  final String price;
  final double cardWidth;

  const RecommendationCard({
    Key? key,
    required this.imagePath,
    required this.recommendationText,
    required this.title,
    required this.subTitle,
    required this.faculty,
    required this.price,
    required this.cardWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Make the shadow more prominent
            blurRadius: 10, // Adjusted for a stronger effect
            offset: const Offset(0, 5), // Slightly larger offset
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.asset(
              imagePath,
              width: cardWidth * 0.4,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recommendationText,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontFamily: 'InriaSerif-Regular',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    faculty,
                    style: const TextStyle(
                      fontFamily: 'InriaSerif-BoldItalic',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    price,
                    style: const TextStyle(
                      fontFamily: 'InriaSerif-Bold',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



