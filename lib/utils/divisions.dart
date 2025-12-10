import 'package:latlong2/latlong.dart';

class BDDivision {
  final String name;
  final double minLat;
  final double maxLat;
  final double minLon;
  final double maxLon;
  final String markerAsset;

  BDDivision({
    required this.name,
    required this.minLat,
    required this.maxLat,
    required this.minLon,
    required this.maxLon,
    required this.markerAsset,
  });

  bool contains(LatLng point) {
    return point.latitude >= minLat &&
        point.latitude <= maxLat &&
        point.longitude >= minLon &&
        point.longitude <= maxLon;
  }
}

final List<BDDivision> bdDivisions = [
  BDDivision(
    name: "Dhaka",
    minLat: 23.4,
    maxLat: 24.2,
    minLon: 90.0,
    maxLon: 91.0,
    markerAsset: "assets/markers/dhaka.png",
  ),
  BDDivision(
    name: "Chittagong",
    minLat: 21.8,
    maxLat: 23.5,
    minLon: 91.0,
    maxLon: 92.7,
    markerAsset: "assets/markers/chittagong.png",
  ),
  BDDivision(
    name: "Sylhet",
    minLat: 24.3,
    maxLat: 25.2,
    minLon: 91.5,
    maxLon: 92.7,
    markerAsset: "assets/markers/sylhet.png",
  ),
  BDDivision(
    name: "Rajshahi",
    minLat: 24.0,
    maxLat: 25.2,
    minLon: 88.0,
    maxLon: 89.5,
    markerAsset: "assets/markers/rajshahi.png",
  ),
  BDDivision(
    name: "Khulna",
    minLat: 21.5,
    maxLat: 23.0,
    minLon: 89.0,
    maxLon: 90.0,
    markerAsset: "assets/markers/khulna.png",
  ),
  BDDivision(
    name: "Barishal",
    minLat: 22.0,
    maxLat: 23.3,
    minLon: 89.7,
    maxLon: 90.5,
    markerAsset: "assets/markers/barishal.png",
  ),
  BDDivision(
    name: "Rangpur",
    minLat: 25.2,
    maxLat: 26.5,
    minLon: 88.5,
    maxLon: 89.5,
    markerAsset: "assets/markers/rangpur.png",
  ),
  BDDivision(
    name: "Mymensingh",
    minLat: 24.3,
    maxLat: 25.1,
    minLon: 90.0,
    maxLon: 91.1,
    markerAsset: "assets/markers/mymensingh.png",
  ),
];
