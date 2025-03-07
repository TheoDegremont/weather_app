import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:weather_app/config/data/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WeatherServices {
  static const String _weatherUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl =
      'https://nominatim.openstreetmap.org/reverse?format=json';

  Future<WeatherModel> getWeatherData() async {
    // Position GPS
    Position position = await determinedPosition();

    // Récupération de la ville

    String cityName = await _getCityName(position.latitude, position.longitude);

    // Récupération des données météorologiques

    return _getWeatherData(position.latitude, position.longitude, cityName);
  }

  Future<Position> determinedPosition() async {
    // Verification de la permission
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled');
    }
    //Verification de l'autorisation de l'application
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> _getCityName(double lat, double long) async {
    // Récupération de la ville
    final response =
        await http.get(Uri.parse('$_geocodingUrl&lat=$lat&lon=$long'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('address')) {
        return data['address']['city'] ??
            data['address']['town'] ??
            data['address']['village'] ??
            data['address']['country'] ??
            'Unknown';
      }
    }
    throw Exception('Failed to get city name');
  }

  Future<WeatherModel> _getWeatherData(
      double latitude, double longitude, String cityName) async {
    final url =
        '$_weatherUrl?latitude=$latitude&longitude=$longitude&current=weather_code&hourly=temperature_2m,weather_code&timezone=auto';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel(cityName: cityName, temperature: _getCurrentHourlyTemperature(data), weatherCode: _getCurrentHourlyWeatherCode(data));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  double _getCurrentHourlyTemperature(Map<String, dynamic> data) {
    final times = data['hourly']['time'];
    final weatherCodes = data['hourly']['temperature_2m'];
    final currentTime = _getCurrentUTcTime();
    final index = times.indexOf(currentTime);
    return index != -1 ? data['hourly']['temperature_2m'][index] : weatherCodes.last;

  }

  int _getCurrentHourlyWeatherCode(Map<String, dynamic> data) {
    final times = data['hourly']['time'];
    final weatherCodes = data['hourly']['weather_code'];
    final currentTime = _getCurrentUTcTime();
    final index = times.indexOf(currentTime);
    return index != -1 ? weatherCodes[index] : weatherCodes.last;
  }

  String _getCurrentUTcTime() {
    return DateFormat("yyyy-MM-ddTHH:00").format(DateTime.now().toUtc());
  }
}
