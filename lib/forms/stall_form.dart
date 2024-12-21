import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:biteatui/models/all_entry.dart';

class StallForm extends StatefulWidget {
  const StallForm({Key? key}) : super(key: key);

  @override
  State<StallForm> createState() => _StallFormState();
}

class _StallFormState extends State<StallForm> {
  final TextEditingController stallNameController = TextEditingController();
  final TextEditingController stallImageUrlController = TextEditingController();

  Canteen? selectedCanteen;
  List<Canteen> canteens = [];
  String? selectedCuisineType;
  List<String> cuisineTypes = [
    'Indonesian', 
    'Chinese', 
    'Western', 
    'Japanese', 
    'Korean', 
    'Indian', 
    'Beverages', 
    'Dessert', 
    'Others'
    ];

  @override
  void initState() {
    super.initState();
    fetchCanteens();
  }

  Future<void> fetchCanteens() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://localhost:8000/show_json/');

      setState(() {
        canteens = (response['canteens'] as List)
            .map((canteenJson) => Canteen.fromJson(canteenJson))
            .toList();
      });
    } catch (e) {
      print("Error fetching canteens: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EA),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
          child: Column(
            children: [
              // Header Logo and Text
              buildHeader(screenWidth, screenHeight),
              SizedBox(
                width: screenWidth * 0.9,
                child: Text(
                  'Add Stall',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: screenWidth * 0.08,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Stall Information Card
              buildStallInformationCard(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              // Add Stall Button
              GestureDetector(
                onTap: () {
                  print('Stall Name: ${stallNameController.text}');
                  print('Cuisine Type: $selectedCuisineType');
                  print('From Canteen: ${selectedCanteen?.fields.name}');
                  print('Stall Image URL: ${stallImageUrlController.text}');
                },
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.065,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF79022),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Add Stall',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget buildHeader(double screenWidth, double screenHeight) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        width: screenWidth * 0.7,
        height: screenHeight * 0.1,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Transform.rotate(
                angle: 0.02,
                child: Container(
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.08,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.28,
              top: screenHeight * 0.01,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Bite',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: screenWidth * 0.08,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '@',
                      style: TextStyle(
                        color: const Color(0xFFF79022),
                        fontSize: screenWidth * 0.08,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: 'UI',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: screenWidth * 0.08,
                        fontFamily: 'Inria Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: screenWidth * 0.28,
              top: screenHeight * 0.08, // Adjusted to avoid overlap
              child: SizedBox(
                width: screenWidth * 0.4,
                child: Text(
                  'Coping with one Bite at a time',
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: screenWidth * 0.025,
                    fontFamily: 'Inria Serif',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStallInformationCard(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0x3F000000),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 72, 101, 133),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                'Stall Information',
                style: TextStyle(
                  color: const Color(0xFFF79022),
                  fontSize: screenWidth * 0.05,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInputLabel('Stall’s Name', screenWidth),
                buildInputField(stallNameController, 'Mie Ayam Pakde', screenWidth),
                buildInputLabel('Cuisine Type', screenWidth),
                buildCuisineDropdown(screenWidth),
                buildInputLabel('From Canteen', screenWidth),
                buildCanteenDropdown(screenWidth),
                buildInputLabel('Stall Image URL', screenWidth),
                buildInputField(stallImageUrlController, 'https://photo.com', screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputLabel(String label, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.01),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.04,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String placeholder, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.19),
            fontSize: screenWidth * 0.045,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.045,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildCuisineDropdown(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: DropdownButtonFormField<String>(
        value: selectedCuisineType,
        hint: const Text('Select a Cuisine Type'),
        isExpanded: true,
        items: cuisineTypes
            .map(
              (cuisine) => DropdownMenuItem<String>(
                value: cuisine,
                child: Text(
                  cuisine,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.045,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCuisineType = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.045,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildCanteenDropdown(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: DropdownButtonFormField<Canteen>(
        value: selectedCanteen,
        hint: const Text('Select a Canteen'),
        isExpanded: true,
        items: canteens
            .map(
              (canteen) => DropdownMenuItem<Canteen>(
                value: canteen,
                child: Text(
                  canteen.fields.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.045,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCanteen = value;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.045,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}