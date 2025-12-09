import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/landmark.dart';
import 'edit_entry.dart';

class OverviewMapScreen extends StatefulWidget {
  const OverviewMapScreen({super.key});

  @override
  State<OverviewMapScreen> createState() => _OverviewMapScreenState();
}

class _OverviewMapScreenState extends State<OverviewMapScreen> {
  late Future<List<Landmark>> futureLandmarks;

  bool isNightMode = false;
  @override
  void initState() {
    super.initState();
    futureLandmarks = ApiService().fetchLandmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overview Map"),
        actions: [
          IconButton(
            icon: Icon(
              isNightMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              setState(() {
                isNightMode = !isNightMode;
              });
            },
          )
        ],
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

          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(23.6850, 90.3563),
              initialZoom: 7.5,
            ),
            children: [
              TileLayer(
                urlTemplate: isNightMode
                    ? "https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png"
                    : "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.bangladesh_landmarks",
              ),

              MarkerLayer(
                markers: landmarks.map((lm) {
                  return Marker(
                    width: 40,
                    height: 40,
                    point: LatLng(lm.lat, lm.lon),
                    child: GestureDetector(
                      onTap: () => _openBottomSheet(context, lm),
                      child: Image.asset(
                        'assets/athens.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openBottomSheet(BuildContext context, Landmark lm) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              lm.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Image.network(lm.imageUrl, height: 120, fit: BoxFit.cover),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _goToEditScreen(lm);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmDelete(context, lm);
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Delete", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
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

  void _confirmDelete(BuildContext context, Landmark lm) async {
    final yes = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Landmark"),
        content: Text("Are you sure you want to delete '${lm.title}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (yes != true) return;

    final success = await ApiService().deleteLandmark(lm.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deleted Successfully")),
      );
      setState(() {
        futureLandmarks = ApiService().fetchLandmarks();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delete Failed")),
      );
    }
  }
}

