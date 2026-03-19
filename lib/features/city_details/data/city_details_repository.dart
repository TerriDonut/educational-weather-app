import 'package:test_project_weather/features/city_details/data/datasources/city_details_remote_data_source.dart';
import 'package:test_project_weather/features/city_details/data/dto/current_weather_remote_future_data_dto.dart';
import 'package:test_project_weather/features/city_details/data/dto/current_weather_remote_today_data_dto.dart';
import 'package:test_project_weather/features/city_details/data/models/current_weather_model.dart';
import 'package:test_project_weather/features/city_details/data/models/daily_weather_model.dart';
import 'package:test_project_weather/features/city_details/data/models/hourly_weather_model.dart';

class CityDetailsRepository {
  final CityDetailsRemoteDataSource _cityDetailsRemoteDataSource;

  CityDetailsRepository({
    required CityDetailsRemoteDataSource cityDetailsRemoteDataSource,
  }) : _cityDetailsRemoteDataSource = cityDetailsRemoteDataSource;

  // TODO(kshabanov): remove nameCity
  Future<CurrentWeatherModel> getCurrentWeather(
    int cityId,
    String nameCity,
  ) async {
    final results = await Future.wait<Object>([
      _cityDetailsRemoteDataSource.getCurrentWeatherToday(cityId),
      _cityDetailsRemoteDataSource.getCurrentWeatherFuture(cityId),
    ], eagerError: true);

    final today = results[0] as CurrentWeatherRemoteTodayDataDto;
    final future = results[1] as CurrentWeatherRemoteFutureDataDto;

    return CurrentWeatherModel(
      cityId: cityId,
      city: nameCity,
      currentTemp: today.currentTemp,
      high: today.high,
      low: today.low,
      condition: future.condition,
      tomorrowHigh: future.tomorrowHigh,
      changes: future.changes,
    );
  }

  Future<List<HourlyWeatherModel>> getHourlyWeather(int cityId) async {
    final hourlyWeatherDtos = await _cityDetailsRemoteDataSource
        .getHourlyWeather(cityId);

    return hourlyWeatherDtos
        .map(
          (dto) => HourlyWeatherModel(
            cityId: cityId,
            city: dto.city,
            time: dto.time,
            temperature: dto.temperature,
            precipitation: dto.precipitation,
            condition: dto.condition,
          ),
        )
        .toList();
  }

  Future<List<DailyWeatherModel>> getDailyWeather(int cityId) async {
    final dailyWeatherDtos = await _cityDetailsRemoteDataSource.getDailyWeather(
      cityId,
    );

    return dailyWeatherDtos
        .map(
          (dto) => DailyWeatherModel(
            cityId: cityId,
            city: dto.city,
            day: dto.day,
            high: dto.high,
            low: dto.low,
            condition: dto.condition,
            precipitation: dto.precipitation,
          ),
        )
        .toList();
  }
}
