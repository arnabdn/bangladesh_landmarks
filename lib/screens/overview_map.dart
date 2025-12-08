import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';
import '../models/landmark.dart';

class OverviewMapScreen extends StatefulWidget {
  const OverviewMapScreen({super.key});

  @override
  State<OverviewMapScreen> createState() => _OverviewMapScreenState();
}

class _OverviewMapScreenState extends State<OverviewMapScreen> {
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
        title: const Text("Overview Map"),
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
              initialCenter: LatLng(23.6850, 90.3563), // Center on Bangladesh
              initialZoom: 7.5,
            ),

            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.bangladesh_landmarks",
              ),

              MarkerLayer(
                markers: landmarks.map((lm) {
                  return Marker(
                    width: 40,
                    height: 40,
                    point: LatLng(lm.lat, lm.lon),
                    child: GestureDetector(
                      onTap: () {
                        _showPopup(context, lm);
                      },
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
}
void _showPopup(BuildContext context, Landmark lm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(lm.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                lm.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    print("Edit pressed: ${lm.title}");
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    print("Delete pressed: ${lm.title}");
                  },
                  icon: const Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  label: const Text("Delete"),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
