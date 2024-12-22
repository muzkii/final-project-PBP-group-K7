import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class FacultyForm extends StatefulWidget {
  const FacultyForm({Key? key}) : super(key: key);

  @override
  State<FacultyForm> createState() => _FacultyFormState();
}

class _FacultyFormState extends State<FacultyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController facultyNameController = TextEditingController();
  final TextEditingController facultyNicknameController = TextEditingController();
  final TextEditingController facultyColorController = TextEditingController();
  final TextEditingController facultyImageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4EA),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header Logo and Text
                FittedBox(
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
                ),
                // Title
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Text(
                    'Add Faculty',
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
                // Faculty Information Card
                Container(
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
                            'Faculty Information',
                            style: TextStyle(
                              color: Color(0xFFF79022),
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
                            buildInputLabel('Faculty Name', screenWidth),
                            buildInputField(facultyNameController, 'Faculty of Law', screenWidth, 'Faculty Name'),
                            buildInputLabel('Faculty Nickname', screenWidth),
                            buildInputField(facultyNicknameController, 'FMIPA | FASILKOM | FH', screenWidth, 'Faculty Nickname'),
                            buildInputLabel('Faculty Color', screenWidth),
                            buildInputField(facultyColorController, 'red | red,blue | red,blue,green', screenWidth, 'Faculty Color'),
                            buildInputLabel('Faculty Image URL', screenWidth),
                            buildInputField(facultyImageUrlController, 'https://photo.com', screenWidth, 'Faculty Image URL'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Add Faculty Button
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://localhost:8000/create-faculty-flutter/",
                        jsonEncode(<String, String>{
                          'name': facultyNameController.text,
                          'nickname': facultyNicknameController.text,
                          'colors': facultyColorController.text,
                          'image': facultyImageUrlController.text,
                        }),
                      );
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("New faculty has been added successfully!"),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong, please try again."),
                            ),
                          );
                        }
                      }
                    }
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
                        'Add Faculty',
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

  Widget buildInputField(TextEditingController controller, String placeholder, double screenWidth, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.04),
      child: TextFormField(
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
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty!";
          }
          return null;
        },
      ),
    );
  }
}