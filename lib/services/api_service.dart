import 'package:dio/dio.dart';
import '../models/landmark.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://labs.anontech.info/cse489/t3",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  // Fetch all landmarks
  Future<List<Landmark>> fetchLandmarks() async {
    try {
      final response = await _dio.get('/api.php');

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
}
