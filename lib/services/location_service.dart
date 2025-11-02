import 'package:geolocator/geolocator.dart';

class LocationService {
  
  Future<bool> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  
  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestPermission();
      
      if (!hasPermission) {
        throw Exception('Нет разрешения на доступ к местоположению');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      throw Exception('Ошибка получения местоположения: $e');
    }
  }
}
