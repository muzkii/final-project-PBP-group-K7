import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'stall_page.dart';
import 'package:biteatui/models/all_entry.dart';

class CanteenPage extends StatelessWidget {
  const CanteenPage({super.key});

  Future<List<Canteen>> fetchCanteens(CookieRequest request) async {
    final response = await request.get('http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/show_json/');
    var data = response;

    List<Canteen> canteens = [];
    for (var d in data["canteens"]) {
      if (d != null) {
        canteens.add(Canteen.fromJson(d));
      }
    }
    return canteens;
  }

  Future<Map<int, String>> fetchFacultyMap(CookieRequest request) async {
    final response = await request.get('http://chiara-aqmarina-midtermproject.pbp.cs.ui.ac.id/show_json/');
    var data = response;

    Map<int, String> facultyMap = {};
    for (var d in data["faculties"]) {
      if (d != null) {
        int id = d["pk"];
        String name = d["fields"]["name"];
        facultyMap[id] = name;
      }
    }
    return facultyMap;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Canteens'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder(
        future: Future.wait([fetchCanteens(request), fetchFacultyMap(request)]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data![0].isEmpty ||
              snapshot.data![1].isEmpty) {
            return const Center(
              child: Text(
                'No canteens found.',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          } else {
            List<Canteen> canteens = snapshot.data![0];
            Map<int, String> facultyMap = snapshot.data![1];

            return SingleChildScrollView(
              child: Container(
                width: screenWidth,
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/pictures/cafe.png',
                          width: screenWidth,
                          height: screenHeight * 0.25,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          children: const [
                            SizedBox(height: kToolbarHeight + 16), // Space for the AppBar
                            Text(
                              'Our ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0.90,
                              ),
                            ),
                            Text(
                              'Canteens',
                              style: TextStyle(
                                color: Color(0xFFF79022),
                                fontSize: 30,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Find the canteen you wish to ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontFamily: 'Inria Serif',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'explore!',
                                style: TextStyle(
                                  color: Color(0xFFF79022),
                                  fontSize: 13,
                                  fontFamily: 'Inria Serif',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/pictures/stars2.png',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: screenWidth * 0.6,
                      height: 1,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: canteens.map((canteen) {
                        String facultyName =
                            facultyMap[canteen.fields.faculty] ?? "Unknown Faculty";
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StallPage(facultyId: canteen.fields.faculty),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.15,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: screenWidth * 0.9,
                                    height: screenHeight * 0.15,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.25,
                                  top: screenHeight * 0.01,
                                  child: SizedBox(
                                    width: screenWidth * 0.6,
                                    height: screenHeight * 0.05,
                                    child: Text(
                                      canteen.fields.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.80,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.25,
                                  top: screenHeight * 0.04,
                                  child: SizedBox(
                                    width: screenWidth * 0.6,
                                    height: screenHeight * 0.05,
                                    child: Text(
                                      facultyName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inria Serif',
                                        fontWeight: FontWeight.w300,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.25,
                                  top: screenHeight * 0.07,
                                  child: SizedBox(
                                    width: screenWidth * 0.6,
                                    height: screenHeight * 0.05,
                                    child: Text(
                                      canteen.fields.price,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inria Serif',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.02,
                                  top: screenHeight * 0.01,
                                  child: Container(
                                    width: screenWidth * 0.2,
                                    height: screenHeight * 0.13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(canteen.fields.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}