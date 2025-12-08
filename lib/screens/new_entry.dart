import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../services/api_service.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();

  File? selectedImage;
  File? resizedImage;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _autoDetectLocation();
  }

  Future<void> _autoDetectLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) {
        print("Location permission permanently denied.");
        return;
      }

      final pos = await Geolocator.getCurrentPosition();

      latController.text = pos.latitude.toString();
      lonController.text = pos.longitude.toString();
    } catch (e) {
      print("Location Error: $e");
    }
  }

  // Image Picker
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage = File(picked.path);
      await _resizeImage();
      setState(() {});
    }
  }

  // resize to 800×600
  Future<void> _resizeImage() async {
    final dir = selectedImage!.parent.path;
    final targetPath = "$dir/resized_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      selectedImage!.path,
      targetPath,
      minWidth: 800,
      minHeight: 600,
      quality: 85,
    );

    if (result != null) {
      resizedImage = File(result.path);
    }
  }

  // api submition
  Future<void> submit() async {
    if (titleController.text.isEmpty ||
        latController.text.isEmpty ||
        lonController.text.isEmpty ||
        resizedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final double? lat = double.tryParse(latController.text);
    final double? lon = double.tryParse(lonController.text);

    if (lat == null || lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid latitude or longitude")),
      );
      return;
    }

    setState(() => isUploading = true);

    final success = await ApiService().createLandmark(
      titleController.text,
      lat,
      lon,
      resizedImage!.path,
    );

    setState(() => isUploading = false);

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Landmark added successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                titleController.clear();
                latController.clear();
                lonController.clear();
                selectedImage = null;
                resizedImage = null;
                _autoDetectLocation();
                setState(() {});
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Entry")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: latController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: lonController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Pick Image"),
            ),

            if (resizedImage != null) ...[
              const SizedBox(height: 10),
              Image.file(resizedImage!, height: 180),
            ],

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: isUploading ? null : submit,
              icon: isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.upload),
              label: Text(isUploading ? "Uploading..." : "Submit"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
