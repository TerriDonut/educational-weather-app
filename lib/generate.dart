import 'dart:math';
import 'package:flutter/material.dart';

class WeatherData {
  final String city;
  final int currentTemp;
  final int high;
  final int low;
  final String condition;
  final int tomorrowHigh;
  final String changes;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;


  WeatherData({
    required this.city,
    required this.currentTemp,
    required this.high,
    required this.low,
    required this.condition,
    required this.tomorrowHigh,
    required this.changes,
    required this.hourly,
    required this.daily,
  });
}


class HourlyWeather {
  final String time;
  final int temperature;
  final int precipitation;
  final String condition;


  HourlyWeather(this.time, this.temperature, this.precipitation, this.condition);
}


class DailyWeather {
  final String day;
  final int high;
  final int low;
  final String condition;
  final int precipitation;


  DailyWeather(this.day, this.high, this.low, this.condition, this.precipitation);
}

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);
}




class WeatherGenerator {
  static final Random _rnd = Random();

  static Future<WeatherData> generateAsync() async {

    await Future.delayed(const Duration(seconds: 5));

    if (_rnd.nextBool()) {
    //if (false) {
      throw WeatherException('Ошибка выгрузки информации');
    }

    return generate();
  }

    static WeatherData generate() {

    final now = DateTime.now();

    final currentTemp = 10 + _rnd.nextInt(15);
    final high = currentTemp + _rnd.nextInt(5);
    final low = currentTemp - _rnd.nextInt(6);
    final tomorrowHigh = 10 + _rnd.nextInt(15);
    final changes = tomorrowHigh > high ? 'повышение' : 'понижение';


    final hourly = <HourlyWeather>[];
    for (int i = 0; i < 24; i++) {
      final hourToAdd = now.add(Duration(hours: i));
      String formattedTime;
      if (i==0) {
        formattedTime = 'Сейчас';
      } else {
        formattedTime = '${hourToAdd.hour.toString().padLeft(2, '0')}:00';//${hourToAdd.minute.toString().padLeft(2, '0')}';
      }
      final hourlyCondition = _conditions[_rnd.nextInt(_conditions.length)];
      final tempVariation = _rnd.nextInt(3) - 1;
      final precip = _rnd.nextInt(80);

      hourly.add(HourlyWeather(formattedTime, currentTemp + tempVariation, precip, hourlyCondition));
    }


    final List<DailyWeather> daily = [];

    for (int i = 1; i <= 10; i++) {
      final futureDate = now.add(Duration(days: i));
      String dayName;
      if (i == 1) {
        dayName = "Завтра";
      } else {
        dayName = _formatWeekday(futureDate.weekday);
      }
      final dayHigh = 10 + _rnd.nextInt(15);
      final dayLow = 5 + _rnd.nextInt(10);
      final dayCondition = _conditions[_rnd.nextInt(_conditions.length)];
      final precip = _rnd.nextInt(80);
      daily.add(DailyWeather(dayName, dayHigh, dayLow, dayCondition, precip));
    }


    return WeatherData(
      city: "Krasnodar",
      currentTemp: currentTemp,
      high: high,
      low: low,
      condition: _conditions[_rnd.nextInt(_conditions.length)],
      tomorrowHigh: tomorrowHigh,
      changes: changes,
      hourly: hourly,
      daily: daily,
    );
  }


  static String _formatWeekday(int weekday) {
    const days = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"];
    return days[weekday - 1];
  }


  static const _conditions = [
    "Преимущественно облачно",
    "Частично облачно",
    "Ясно",
    "Дождь",
    "Небольшой дождь",
    "Тумано"
  ];


  static IconData getWeatherIcon(String condition) {
    switch (condition) {
      case "Ясно":
        return Icons.wb_sunny;
      case "Частично облачно":
        return Icons.wb_cloudy;
      case "Преимущественно облачно":
        return Icons.cloud;
      case "Дождь":
        return Icons.umbrella;
      case "Небольшой дождь":
        return Icons.water_drop;
      case "Тумано":
        return Icons.opacity;
      default:
        return Icons.cloud;
    }
  }
}
