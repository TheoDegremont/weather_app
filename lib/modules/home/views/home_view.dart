import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/config/data/weather_model.dart';
import 'package:weather_app/modules/home/controllers/weather_controller.dart';
import 'package:weather_app/modules/home/services/weather_services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final WeatherController weatherController = WeatherController();
  final WeatherServices _weatherServices = WeatherServices();

  WeatherModel? weatherModel;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weatherData = await _weatherServices.getWeatherData();
      setState(() {
        weatherModel = weatherData;
        _isLoading = false;
      });
    }catch(e){
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor:
            weatherController.isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.location_on,
              color: weatherController.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(
                weatherController.isDarkMode ? Icons.wb_sunny : Icons.bedtime,
                color:
                    weatherController.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  weatherController.isDarkMode = !weatherController.isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: _isLoading ? CircularProgressIndicator(): _errorMessage.isNotEmpty ? Center(child: Text(_errorMessage)): weatherModel != null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weatherModel!.cityName,
                style: TextStyle(
                    color: weatherController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth * 0.55,
                height: screenHeight * 0.25,
                child: Lottie.asset(weatherController.getWeatherLottie(weatherModel!.weatherCode)),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                '${weatherModel!.temperature.toStringAsFixed(1)}°C',
                style: TextStyle(
                    color: weatherController.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold),
              ),
            ],
          
        ) : const Text('No data')));
  }
}
