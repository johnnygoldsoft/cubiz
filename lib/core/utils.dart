import 'package:geolocator/geolocator.dart';

String formatDistanceMeters(double meters) {
  if (meters >= 1000) {
    return '${(meters / 1000).toStringAsFixed(1)} km';
  } else {
    return '${meters.toInt()} m';
  }
}

Future<Position> getCurrentLocation() =>
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2); // meters
}
