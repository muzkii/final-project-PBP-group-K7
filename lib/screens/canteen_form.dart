import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:biteatui/models/all_entry.dart';

class CanteenForm extends StatefulWidget {
  const CanteenForm({Key? key}) : super(key: key);

  @override
  State<CanteenForm> createState() => _CanteenFormState();
}

class _CanteenFormState extends State<CanteenForm> {
  final TextEditingController canteenNameController = TextEditingController();
  final TextEditingController canteenPriceRangeController = TextEditingController();
  final TextEditingController canteenImageUrlController = TextEditingController();

  Faculty? selectedFaculty;
  List<Faculty> faculties = [];

  @override
  void initState() {
    super.initState();
    fetchFaculties();
  }

  Future<void> fetchFaculties() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://localhost:8000/show_json/');

      setState(() {
        faculties = (response['faculties'] as List)
            .map((facultyJson) => Faculty.fromJson(facultyJson))
            .toList();
      });
    } catch (e) {
      print("Error fetching faculties: $e");
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
                  'Add Canteen',
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
              // Canteen Information Card
              buildCanteenInformationCard(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              // Add Canteen Button
              GestureDetector(
                onTap: () {
                  print('Canteen Name: ${canteenNameController.text}');
                  print('Canteen’s Price Range: ${canteenPriceRangeController.text}');
                  print('From Faculty: ${selectedFaculty?.fields.name}');
                  print('Canteen Image URL: ${canteenImageUrlController.text}');
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
                      'Add Canteen',
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

  Widget buildCanteenInformationCard(double screenWidth, double screenHeight) {
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
                'Canteen Information',
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
                buildInputLabel('Canteen Name', screenWidth),
                buildInputField(canteenNameController, 'KANMER', screenWidth),
                buildInputLabel('Canteen’s Price Range', screenWidth),
                buildInputField(canteenPriceRangeController, 'Rp10.000-Rp30.000/pax', screenWidth),
                buildInputLabel('From Faculty', screenWidth),
                buildFacultyDropdown(screenWidth),
                buildInputLabel('Canteen Image URL', screenWidth),
                buildInputField(canteenImageUrlController, 'https://photo.com', screenWidth),
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

  Widget buildFacultyDropdown(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: DropdownButtonFormField<Faculty>(
        value: selectedFaculty,
        hint: const Text('Select a Faculty'),
        isExpanded: true,
        items: faculties
            .map(
              (faculty) => DropdownMenuItem<Faculty>(
                value: faculty,
                child: Text(
                  faculty.fields.name,
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
            selectedFaculty = value;
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