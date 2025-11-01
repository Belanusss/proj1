import 'package:geolocator/geolocator.dart';

class LocationService {
  // Проверка и запрос разрешений
  Future<bool> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем, включены ли службы геолокации
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

  // Получить текущую позицию
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
