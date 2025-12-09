import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/landmark.dart';
import 'edit_entry.dart';

class RecordsListScreen extends StatefulWidget {
  const RecordsListScreen({super.key});

  @override
  State<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordsListScreen> {
  late Future<List<Landmark>> futureLandmarks;

  @override
  void initState() {
    super.initState();
    futureLandmarks = ApiService().fetchLandmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landmarks"),
      ),
      body: FutureBuilder<List<Landmark>>(
        future: futureLandmarks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final landmarks = snapshot.data ?? [];

          if (landmarks.isEmpty) {
            return const Center(child: Text("No landmarks found"));
          }

          return ListView.builder(
            itemCount: landmarks.length,
            itemBuilder: (context, index) {
              final lm = landmarks[index];

              return Dismissible(
                key: ValueKey(lm.id),

                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                secondaryBackground: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),

                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // confirm it has been deleted
                    final shouldDelete = await _confirmDelete(context, lm);
                    if (shouldDelete) {
                      final success =
                          await ApiService().deleteLandmark(lm.id);

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Deleted successfully")),
                        );

                        setState(() {
                          futureLandmarks = ApiService().fetchLandmarks();
                        });
                        return true;
                      } else {
                        _showErrorDialog(context, "Failed to delete entry.");
                        return false;
                      }
                    }
                    return false;
                  } else {
                    _goToEditScreen(lm);
                    return false;
                  }
                },

                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        lm.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(lm.title),
                    subtitle: Text("Lat: ${lm.lat}, Lon: ${lm.lon}"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Landmark lm) async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete Landmark"),
            content: Text("Are you sure you want to delete '${lm.title}'?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text("Delete"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void _goToEditScreen(Landmark lm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditEntryScreen(landmark: lm),
      ),
    ).then((updated) {
      if (updated == true) {
        setState(() {
          futureLandmarks = ApiService().fetchLandmarks();
        });
      }
    });
  }
}

