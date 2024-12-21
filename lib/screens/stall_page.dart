import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/all_entry.dart';

class StallPage extends StatefulWidget {
  final int facultyId;

  const StallPage({
    super.key,
    required this.facultyId,
  });

  @override
  _StallPageState createState() => _StallPageState();
}

class _StallPageState extends State<StallPage> {
  void refreshPage() {
    setState(() {});
  }

  Future<List<Stall>> fetchStallsByFaculty(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/show_json/');
    List<Stall> facultyStalls = [];
    var canteens = response["canteens"]
        .where((canteen) => canteen["fields"]["faculty"] == widget.facultyId)
        .toList();

    for (var stall in response["stalls"]) {
      if (stall != null) {
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          editStall(context, request, snapshot.data![index], refreshPage, widget.facultyId);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteStall(context, request, snapshot.data![index].pk, refreshPage, widget.facultyId);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addStall(context, request, refreshPage, widget.facultyId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void addStall(BuildContext context, CookieRequest request, Function refreshPage, int facultyId) async {
  final nameController = TextEditingController();
  final cuisineController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Add New Stall'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: cuisineController,
            decoration: const InputDecoration(labelText: 'Cuisine'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await request.post(
              'http://localhost:8000/add_stall/',
              {
                'name': nameController.text,
                'cuisine': cuisineController.text,
                'faculty': facultyId.toString(),
              },
            );
            if (!context.mounted) return;
            Navigator.pop(context);
            refreshPage();
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

void editStall(BuildContext context, CookieRequest request, Stall stall, Function refreshPage, int facultyId) async {
  final nameController = TextEditingController(text: stall.fields.name);
  final cuisineController = TextEditingController(text: stall.fields.cuisine);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Stall'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: cuisineController,
            decoration: const InputDecoration(labelText: 'Cuisine'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await request.post(
              'http://localhost:8000/edit_stall/${stall.pk}/',
              {
                'name': nameController.text,
                'cuisine': cuisineController.text,
                'faculty': facultyId.toString(),
              },
            );
            if (!context.mounted) return;
            Navigator.pop(context);
            refreshPage();
          },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

void deleteStall(BuildContext context, CookieRequest request, int stallId, Function refreshPage, int facultyId) async {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Delete Stall'),
      content: const Text('Are you sure you want to delete this stall?'),
      actions: [
        TextButton(
          onPressed: () async {
            await request.post('http://localhost:8000/delete_stall/$stallId/', {});
            if (!context.mounted) return;
            Navigator.pop(context);
            refreshPage();
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
