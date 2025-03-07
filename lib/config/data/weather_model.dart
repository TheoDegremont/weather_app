class WeatherModel {
  final String cityName;
  final double temperature;
  final int weatherCode;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.weatherCode,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'],
      temperature: json['temperature'],
      weatherCode: json['weatherCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'weatherCode': weatherCode,
    };
  }
}
