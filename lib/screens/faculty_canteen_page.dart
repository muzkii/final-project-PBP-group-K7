import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:biteatui/models/all_entry.dart';
import 'package:biteatui/widgets/footer.dart';

class FacultyCanteenPage extends StatefulWidget {
  const FacultyCanteenPage({Key? key}) : super(key: key);

  @override
  State<FacultyCanteenPage> createState() => _FacultyCanteenPageState();
}

class _FacultyCanteenPageState extends State<FacultyCanteenPage> {
  Future<List<Faculty>> fetchFaculties(CookieRequest request) async {
    // Ensure your Django endpoint returns faculties with their canteens
    final response = await request.get('http://localhost:8000/show_json/');

    // Decoding the response into JSON
    var data = response;

    // Convert json data to Faculty objects
    List<Faculty> faculties = [];
    for (var d in data["faculties"]) {
      if (d != null) {
        faculties.add(Faculty.fromJson(d));
      }
    }
    return faculties;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculties and Canteens'),
      ),
      body: FutureBuilder(
        future: fetchFaculties(request),
        builder: (context, AsyncSnapshot<List<Faculty>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No faculties found.',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                Faculty faculty = snapshot.data![index];

                return ExpansionTile(
                  title: Text(
                    faculty.fields.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(faculty.fields.nickname),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${faculty.fields.image}"),
                  ),
                  children: [
                    FutureBuilder(
                      future: fetchCanteensForFaculty(faculty.pk, request),
                      builder: (context, AsyncSnapshot<List<Canteen>> canteenSnapshot) {
                        if (canteenSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (canteenSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${canteenSnapshot.error}'),
                          );
                        } else if (!canteenSnapshot.hasData ||
                            canteenSnapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'No canteens found for this faculty.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        } else {
                          return Column(
                            children: canteenSnapshot.data!
                                .map((canteen) => ListTile(
                                      title: Text(canteen.fields.name),
                                      subtitle: Text(canteen.fields.price),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "${canteen.fields.image}"),
                                      ),
                                    ))
                                .toList(),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Footer(
        onAddFaculty: () => print("Add Faculty clicked"),
        onAddCanteen: () => print("Add Canteen clicked"),
        onAddStall: () => print("Add Stall clicked"),
        onAddProduct: () => print("Add Product clicked"),
      ),
    );
  }

  Future<List<Canteen>> fetchCanteensForFaculty(
      int facultyId, CookieRequest request) async {
    final response = await request.get('http://localhost:8000/show_json/');
    var data = response;

    List<Canteen> canteens = [];
    for (var d in data["canteens"]) {
      if (d != null && d["fields"]["faculty"] == facultyId) {
        canteens.add(Canteen.fromJson(d));
      }
    }
    return canteens;
  }
}
