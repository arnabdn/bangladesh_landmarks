import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../models/landmark.dart';
import '../services/api_service.dart';

class EditEntryScreen extends StatefulWidget {
  final Landmark landmark;

  const EditEntryScreen({super.key, required this.landmark});

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late TextEditingController titleController;
  late TextEditingController latController;
  late TextEditingController lonController;

  File? selectedImage;
  File? resizedImage;

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.landmark.title);
    latController = TextEditingController(text: widget.landmark.lat.toString());
    lonController = TextEditingController(text: widget.landmark.lon.toString());
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedImage = File(picked.path);
      await _resizeImage();
      setState(() {});
    }
  }

  Future<void> _resizeImage() async {
    final dir = selectedImage!.parent.path;
    final targetPath =
        "$dir/updated_${DateTime.now().millisecondsSinceEpoch}.jpg";

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

  Future<void> submitUpdate() async {
    final double? lat = double.tryParse(latController.text);
    final double? lon = double.tryParse(lonController.text);

    if (lat == null || lon == null) {
      _showError("Invalid latitude or longitude");
      return;
    }

    setState(() => isUpdating = true);

    final success = await ApiService().updateLandmark(
      widget.landmark.id,
      titleController.text,
      lat,
      lon,
      resizedImage?.path,
    );

    setState(() => isUpdating = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Landmark updated successfully")),
      );

      Navigator.pop(context, true);
    } else {
      _showError("Update failed. Please try again.");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Landmark")),
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
              decoration: const InputDecoration(labelText: "Latitude"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: lonController,
              decoration: const InputDecoration(labelText: "Longitude"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Change Image"),
            ),

            const SizedBox(height: 10),

            if (resizedImage != null)
              Image.file(resizedImage!, height: 180)
            else
              Image.network(widget.landmark.imageUrl, height: 180),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isUpdating ? null : submitUpdate,
              child: isUpdating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
