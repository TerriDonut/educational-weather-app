
import 'package:flutter/material.dart';
import 'widgets.dart';
import 'generate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather main',
      theme: ThemeData.dark(),
      home: const WeatherPage(),
    );
  }
}


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<WeatherData> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    _weatherFuture = WeatherGenerator.generateAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 51, 56),
      body: SafeArea(
        child: FutureBuilder<WeatherData>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              final errorText = snapshot.error is WeatherException
                  ? (snapshot.error as WeatherException).message
                  : 'Что-то пошло не так';

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        errorText,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(_loadWeather);
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final weather = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  WeatherHeader(weather: weather),
                  WeatherSummary(weather: weather),
                  HourlyForecast(hourly: weather.hourly),
                  const ForecastInfo(),
                  DailyForecast(daily: weather.daily),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}