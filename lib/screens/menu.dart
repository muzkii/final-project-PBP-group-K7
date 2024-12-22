import 'package:flutter/material.dart';
import '../widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MyHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  height: screenHeight * 0.35,
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

                  // Scrollable Categories
                  SizedBox(
                    height: screenHeight * 0.18, // Adjusted height for circular categories
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Reduced padding
                      itemBuilder: (context, index) {
                        final categories = [
                          {'image': 'assets/pictures/indonesian_circle.png', 'label': 'Indonesian'},
                          {'image': 'assets/pictures/japanese_circle.png', 'label': 'Japanese'},
                          {'image': 'assets/pictures/italian_circle.png', 'label': 'Italian'},
                          {'image': 'assets/pictures/chinese_circle.png', 'label': 'Chinese'},
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0), // Spacing between items
                          child: CategoryItem(
                            imagePath: categories[index]['image']!,
                            label: categories[index]['label']!,
                            screenWidth: screenWidth,
                          ),
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
            const SizedBox(height: 35),

            SizedBox(
              height: 210, // Fixed height for recommendations section
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: RecommendationCard(
                      imagePath: 'assets/pictures/tomoro.png',
                      recommendationText: "chi's recommendation",
                      title: "Caramel Machiato",
                      subTitle: "TOMORO Coffee",
                      faculty: "FISIP UI",
                      price: "23k",
                      cardWidth: cardWidth * 0.8,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: RecommendationCard(
                      imagePath: 'assets/pictures/bebek_madura.png',
                      recommendationText: "ari's recommendation",
                      title: "Bebek Madura",
                      subTitle: "Kantin FIB",
                      faculty: "FIB UI",
                      price: "20k",
                      cardWidth: cardWidth * 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Hits under 15K Section
            Container(
              width: double.infinity,
              height: 380, // Height of container
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white, // Start with white
                    Colors.red[100] ?? Colors.red, // Fades into light red
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Stars
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Hits under 15K!",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/pictures/stars.png', // Path to the stars asset
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 3,
                          width: MediaQuery.of(context).size.width * 0.7,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Scrollable Cards
                  Expanded( // Use Expanded to allow ListView to take available space
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      children: [
                        // First Card
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, bottom: 15.0),
                          child: _buildHitsUnder15kCard(
                            context: context,
                            imagePath: 'assets/pictures/nasi_uduk.png',
                            priceCirclePath: 'assets/pictures/price_circle13.png',
                            department: "FISIP UI",
                            foodTitle: "Nasi Uduk",
                            stall: "Siomay Ikan Tenggiri",
                            cardWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                        ),
                        // Second Card
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, bottom: 15.0),
                          child: _buildHitsUnder15kCard(
                            context: context,
                            imagePath: 'assets/pictures/nasi_uduk.png',
                            priceCirclePath: 'assets/pictures/price_circle14.png',
                            department: "FISIP UI",
                            foodTitle: "Nasi Uduk",
                            stall: "Siomay Ikan Tenggiri",
                            cardWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                        ),
                        // third card
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, bottom: 15.0),
                          child: _buildHitsUnder15kCard(
                            context: context,
                            imagePath: 'assets/pictures/nasi_uduk.png',
                            priceCirclePath: 'assets/pictures/price_circle14.png',
                            department: "FISIP UI",
                            foodTitle: "Nasi Uduk",
                            stall: "Siomay Ikan Tenggiri",
                            cardWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
    super.key,
    required this.imagePath,
    required this.label,
    required this.screenWidth,
  });

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
  final int? productId; // Add this

  const RecommendationCard({
    super.key,
    required this.imagePath,
    required this.recommendationText,
    required this.title,
    required this.subTitle,
    required this.faculty,
    required this.price,
    required this.cardWidth,
    this.productId, // Add this
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width to scale text
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adjust these multipliers as needed for a good look
    final recTextSize = screenWidth * 0.025;   // ~10px on a 400px wide screen
    final titleTextSize = screenWidth * 0.045; // ~18px on a 400px wide screen
    final subTitleTextSize = screenWidth * 0.03;
    final facultyTextSize = screenWidth * 0.032;
    final priceTextSize = screenWidth * 0.045;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext ctx) {
            return ProductQuickView(
              imagePath: imagePath,
              title: title,
              subTitle: subTitle,
              faculty: faculty,
              price: price,
              productId: productId ?? -1, // Add this line
            );
          },
        );
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left image
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
            // Text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recommendationText,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: recTextSize,
                        color: Colors.pink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: titleTextSize,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontFamily: 'InriaSerif-Regular',
                        fontWeight: FontWeight.w500,
                        fontSize: subTitleTextSize,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      faculty,
                      style: TextStyle(
                        fontFamily: 'InriaSerif-BoldItalic',
                        fontWeight: FontWeight.w600,
                        fontSize: facultyTextSize,
                        color: Colors.orange,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      price,
                      style: TextStyle(
                        fontFamily: 'InriaSerif-Bold',
                        fontWeight: FontWeight.w600,
                        fontSize: priceTextSize,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHitsUnder15kCard({
  required BuildContext context,
  required String imagePath,
  required String priceCirclePath,
  required String department,
  required String foodTitle,
  required String stall,
  required double cardWidth,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  // Adjust these multipliers as needed for a good look
  final departmentFontSize = screenWidth * 0.035;
  final foodTitleFontSize = screenWidth * 0.045;
  final stallFontSize = screenWidth * 0.035;

  return Container(
    width: cardWidth,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20), // Increased border radius
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      children: [
        // Food Image Section
        Stack(
          alignment: Alignment.center, // Center-align the price circle
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Image.asset(
              priceCirclePath,
              width: 90,
              height: 90,
            ),
          ],
        ),
        const SizedBox(height: 10), // Space between image and text

        // Text Content Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                department,
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontStyle: FontStyle.italic,
                  fontSize: departmentFontSize,
                  color: Colors.orange,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                foodTitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: foodTitleFontSize,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                stall,
                style: TextStyle(
                  fontFamily: 'InriaSerif',
                  fontSize: stallFontSize,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10), // Padding at the bottom
      ],
    ),
  );
}

class ProductQuickView extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final String faculty;
  final String price;
  final int productId; // Add this

  const ProductQuickView({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.faculty,
    required this.price,
    required this.productId, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Image.asset(
            imagePath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subTitle,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            faculty,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.favorite_border),
            label: const Text('Add to Favorites'),
            onPressed: () async {
              final request = context.read<CookieRequest>();
              try {
                await request.post(
                  'http://localhost:8000/favorite/$productId/',
                  {},
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites!')),
                );
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to add to favorites')),
                );
              }
            },
          ),
          TextButton(
            child: const Text('View Full Details'),
            onPressed: () {
              Navigator.pop(context); // Close bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    imagePath: imagePath,
                    title: title,
                    subTitle: subTitle,
                    faculty: faculty,
                    price: price,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Add this class in menu.dart after your other widget classes
class ProductDetailPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final String faculty;
  final String price;

  final int? productId; // Make it optional

  const ProductDetailPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.faculty,
    required this.price,
    this.productId, // Now optional
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Location: $faculty",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Price: $price",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add to favorites functionality
                    },
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Add to Favorites'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}