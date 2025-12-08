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
      id: json['id'],            
      title: json['title'],
      lat: json['lat'],         
      lon: json['lon'],        
      image: json['image'],  
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

  // Helper: full image URL (for Image.network)
  String get imageUrl => baseUrl + image;
}
