import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.location_on,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.bedtime,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'San Francisco',
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth * 0.55,
                height: screenHeight * 0.25,
                child: Lottie.asset('assets/images/sun.json'),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                '9°C',
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
