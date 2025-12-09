import 'package:dio/dio.dart';
import '../models/landmark.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://labs.anontech.info/cse489/t3",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<Landmark>> fetchLandmarks() async {
    try {
      final response = await _dio.get("/api.php");

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Landmark.fromJson(json)).toList();
      }

      throw Exception("Unexpected status code: ${response.statusCode}");
    } catch (e) {
      print("API ERROR: $e");
      rethrow;
    }
  }

  Future<bool> createLandmark(
      String title, double lat, double lon, String imagePath) async {
    try {
      final formData = FormData.fromMap({
        "title": title,
        "lat": lat.toString(),
        "lon": lon.toString(),
        "image": await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        "/api.php",
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("UPLOAD ERROR: $e");
      return false;
    }
  }

  Future<bool> updateLandmark(
      int id, String title, double lat, double lon, String? imagePath) async {
    try {
      FormData formData;

      if (imagePath != null) {
        formData = FormData.fromMap({
          "id": id.toString(),
          "title": title,
          "lat": lat.toString(),
          "lon": lon.toString(),
          "image": await MultipartFile.fromFile(
            imagePath,
            filename: imagePath.split('/').last,
          ),
        });
      } else {
        formData = FormData.fromMap({
          "id": id.toString(),
          "title": title,
          "lat": lat.toString(),
          "lon": lon.toString(),
        });
      }

      final response = await _dio.put(
        "/api.php",
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("UPDATE ERROR: $e");
      return false;
    }
  }

  Future<bool> deleteLandmark(int id) async {
    try {
      final response = await _dio.delete(
        "/api.php",
        data: {"id": id},
      );

      return response.statusCode == 200;
    } catch (e) {
      print("DELETE ERROR: $e");
      return false;
    }
  }
}
