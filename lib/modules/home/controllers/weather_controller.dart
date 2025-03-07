class WeatherController {
  
  bool isDarkMode = true;

  String getWeatherLottie(int weatherCode) {

    if (weatherCode >= 0 && weatherCode <= 3) {
      return 'assets/images/sun.json';
    } else if(weatherCode >= 45 && weatherCode <= 48) {
      return 'assets/images/halfsun.json';
    } else if(weatherCode >= 51 && weatherCode <= 82) {
      return 'assets/images/cloud.json';
    } else if(weatherCode >= 95 && weatherCode <= 99) {
      return 'assets/images/thunder.json';
    }else{
      return 'assets/images/cloud.json';
    }
  }
}