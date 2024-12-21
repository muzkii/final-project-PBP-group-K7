import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/all_entry.dart';

// lib/screens/stall_page.dart
class StallPage extends StatefulWidget {
  final int facultyId; // Add this parameter
  
  const StallPage({
    Key? key,
    required this.facultyId,
  }) : super(key: key);

  @override
  _StallPageState createState() => _StallPageState();
}

class _StallPageState extends State<StallPage> {
  Future<List<Stall>> fetchStallsByFaculty(CookieRequest request) async {
    // First get canteens for this faculty
    final response = await request.get('http://localhost:8000/show_json/');
    List<Stall> facultyStalls = [];
    
    // Get canteens for this faculty
    var canteens = response["canteens"].where(
      (canteen) => canteen["fields"]["faculty"] == widget.facultyId
    ).toList();
    
    // Get stalls for these canteens
    for (var stall in response["stalls"]) {
      if (stall != null) {
        // Check if stall's canteen belongs to the faculty
        if (canteens.any((c) => c["pk"] == stall["fields"]["canteen"])) {
          facultyStalls.add(Stall.fromJson(stall));
        }
      }
    }
    return facultyStalls;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Stalls'),
      ),
      body: FutureBuilder<List<Stall>>(
        future: fetchStallsByFaculty(request),
        builder: (context, AsyncSnapshot<List<Stall>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stalls found in this faculty'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(snapshot.data![index].fields.name),
                  subtitle: Text(snapshot.data![index].fields.cuisine),
                  trailing: Text('Canteen ID: ${snapshot.data![index].fields.canteen}'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}