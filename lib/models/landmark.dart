class Landmark {
  final int id;
  final String title;
  final double lat;
  final double lon;
  final String image;

  static const String baseUrl = "https://labs.anontech.info/cse489/t3/";

  Landmark({
    required this.id,
    required this.title,
    required this.lat,
    required this.lon,
    required this.image,
  });

  // Convert from JSON
  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? "Untitled",
      lat: double.tryParse(json['lat']?.toString() ?? "0.0") ?? 0.0,
      lon: double.tryParse(json['lon']?.toString() ?? "0.0") ?? 0.0,
      image: json['image']?.toString() ?? "",
    );
  }

  // Convert to JSON 
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "lat": lat,
        "lon": lon,
        "image": image,
      };

  // image helper
  String get imageUrl => baseUrl + image;
}
