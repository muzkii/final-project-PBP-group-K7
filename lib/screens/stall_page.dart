import 'package:biteatui/widgets/footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/all_entry.dart';

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
              'http://localhost/create-stall-flutter/',
              {
                'name': nameController.text,
                'cuisine_type': cuisineController.text,
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
              'http://localhost/edit-stall-flutter/${stall.pk}/',
              {
                'name': nameController.text,
                'cuisine_type': cuisineController.text,
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
            await request.post('http://localhost/delete-stall-flutter/$stallId/', {});
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
        title: const Text('Food In'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Find the food you wish to explore!'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Stall>>(
              future: fetchStallsByFaculty(request),
              builder: (context, AsyncSnapshot<List<Stall>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No stalls found in this faculty'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final stall = snapshot.data![index];
                      return StallCard(
                        stall: stall,
                        onEdit: () => editStall(context, request, stall, refreshPage, widget.facultyId),
                        onDelete: () => deleteStall(context, request, stall.pk, refreshPage, widget.facultyId),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Footer(
        onAddFaculty: () {}, // Not used
        onAddCanteen: () {}, // Not used
        onAddStall: () {
          addStall(context, request, refreshPage, widget.facultyId); // Add stall functionality
        },
        onAddProduct: () {}, // Not used
      ),
    );
  }
}

class StallCard extends StatelessWidget {
  final Stall stall;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StallCard({
    super.key,
    required this.stall,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stall.fields.name,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Cuisine: ${stall.fields.cuisine}',
              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Edit Stall',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Stall',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}