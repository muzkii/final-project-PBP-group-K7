import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:biteatui/models/all_entry.dart';
import '../screens/menu.dart';
import 'dart:convert';


class ProductForm extends StatefulWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  Stall? selectedStall;
  List<Stall> stalls = [];

  @override
  void initState() {
    super.initState();
    fetchStalls();
  }

  Future<void> fetchStalls() async {
    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/show_json/');

      setState(() {
        stalls = (response['stalls'] as List)
            .map((stallJson) => Stall.fromJson(stallJson))
            .toList();
      });
    } catch (e) {
      print("Error fetching stalls: $e");
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
                  'Add Product',
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
              // Product Information Card
              buildProductInformationCard(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.05),
              // Add Product Button
              GestureDetector(
                onTap: () async {
                  // Perform validation
                  final productName = productNameController.text.trim();
                  final productPrice = productPriceController.text.trim();
                  if (productName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product name cannot be empty!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (productPrice.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product price cannot be empty!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // Validate that price is an integer
                  final price = int.tryParse(productPrice);
                  if (price == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product price must be a valid integer!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // Validate that a stall is selected
                  if (selectedStall == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select a stall!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // If all validations pass, perform the add product logic
                  try {
                  final request = context.read<CookieRequest>();
                  final response = await request.postJson(
                      "http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/create-product-flutter/",
                      jsonEncode(<String, String>{
                        'name': productName,
                        'stall': selectedStall!.pk.toString(),
                        'price': productPrice,
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
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  print('Product Name: $productName');
                  print('Product Price: $price');
                  print('From Stall: ${selectedStall?.fields.name}');
                  // Add further logic here to submit the product to the backend or update state
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
                      'Add Product',
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

  Widget buildProductInformationCard(double screenWidth, double screenHeight) {
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
                'Product Information',
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
                buildInputLabel('Product Name', screenWidth),
                buildInputField(productNameController, 'Nasi Goreng', screenWidth),
                buildInputLabel('Product Price', screenWidth),
                buildPriceInputField(productPriceController, '14000', screenWidth),
                buildInputLabel('From Stall', screenWidth),
                buildStallDropdown(screenWidth),
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

  Widget buildPriceInputField(TextEditingController controller, String placeholder, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
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

  Widget buildStallDropdown(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: DropdownButtonFormField<Stall>(
        value: selectedStall,
        hint: const Text('Mie Ayam'),
        isExpanded: true,
        items: stalls
            .map(
              (stall) => DropdownMenuItem<Stall>(
                value: stall,
                child: Text(
                  stall.fields.name,
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
            selectedStall = value;
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
