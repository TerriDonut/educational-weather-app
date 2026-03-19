import 'dart:math';

import 'package:test_project_weather/core/my_http_client.dart';
import 'package:test_project_weather/features/city_details/data/dto/current_weather_remote_future_data_dto.dart';
import 'package:test_project_weather/features/city_details/data/dto/current_weather_remote_today_data_dto.dart';
import 'package:test_project_weather/features/city_details/data/dto/daily_weather_dto.dart';
import 'package:test_project_weather/features/city_details/data/dto/hourly_weather_dto.dart';
import 'package:test_project_weather/features/common/weather_conditions.dart';
import 'package:test_project_weather/features/common/weather_exception.dart';

class CityDetailsRemoteDataSource {
  final MyHttpClient _myHttpClient;
  final _rnd = Random();

  CityDetailsRemoteDataSource({
    required MyHttpClient myHttpClient,
  }) : _myHttpClient = myHttpClient;

  Future<CurrentWeatherRemoteTodayDataDto> getCurrentWeatherToday(
    int cityId,
  ) async {
    await _myHttpClient.get(
      'https://api.test.com/current_weather/today/$cityId',
    );

    // if (_rnd.nextBool()) {
    //   throw WeatherException('Ошибка загрузки текущего прогноза погоды');
    // }

    final currentTemp = 10 + _rnd.nextInt(15);
    final high = currentTemp + _rnd.nextInt(5);
    final low = currentTemp - _rnd.nextInt(6);

    return CurrentWeatherRemoteTodayDataDto(
      cityId: cityId,
      city: '',
      currentTemp: currentTemp,
      high: high,
      low: low,
    );
  }

  Future<CurrentWeatherRemoteFutureDataDto> getCurrentWeatherFuture(
    int cityId,
  ) async {
    await _myHttpClient.get(
      'https://api.test.com/current_weather/future/$cityId',
    );

    if (_rnd.nextBool()) {
      throw WeatherException('Ошибка загрузки текущего прогноза погоды');
    }

    final currentTemp = 10 + _rnd.nextInt(15);
    final tomorrowHigh = 10 + _rnd.nextInt(15);

    return CurrentWeatherRemoteFutureDataDto(
      cityId: cityId,
      city: '',
      condition: WeatherConditions.random(),
      tomorrowHigh: tomorrowHigh,
      changes: tomorrowHigh > currentTemp ? 'повышение' : 'понижение',
    );
  }

  Future<List<HourlyWeatherDto>> getHourlyWeather(int cityId) async {
    await _myHttpClient.get('https://api.test.com/hourly_weather/$cityId');

    if (_rnd.nextBool()) {
      throw WeatherException('Ошибка загрузки почасового прогноза');
    }

    final baseTemp = 10 + _rnd.nextInt(15);

    return List.generate(24, (i) {
      final hour = DateTime.now().add(Duration(hours: i));

      return HourlyWeatherDto(
        cityId: cityId,
        city: '',
        time: i == 0 ? 'Сейчас' : '${hour.hour.toString().padLeft(2, '0')}:00',
        temperature: baseTemp + _rnd.nextInt(3) - 1,
        precipitation: _rnd.nextInt(80),
        condition: WeatherConditions.random(),
      );
    });
  }

  Future<List<DailyWeatherDto>> getDailyWeather(int cityId) async {
    await _myHttpClient.get('https://api.test.com/daily_weather/$cityId');

    if (_rnd.nextBool()) {
      throw WeatherException('Ошибка загрузки дневного прогноза');
    }

    return List.generate(10, (i) {
      final date = DateTime.now().add(Duration(days: i + 1));

      return DailyWeatherDto(
        cityId: cityId,
        city: '',
        day: i == 0 ? 'Завтра' : WeatherConditions.weekday(date.weekday),
        high: 10 + _rnd.nextInt(15),
        low: 5 + _rnd.nextInt(10),
        condition: WeatherConditions.random(),
        precipitation: _rnd.nextInt(80),
      );
    });
  }
}
