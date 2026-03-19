import 'dart:math';

import 'package:test_project_weather/core/my_http_client.dart';
import 'package:test_project_weather/features/common/weather_conditions.dart';
//import 'package:test_project_weather/features/common/weather_exception.dart';
import 'package:test_project_weather/features/favorites/data/dto/favorites_cities_dto.dart';

// TODO(kshabanov): change data layer structure
/// API
///
/// WEATHER API
/// 1. GET weather/current/[city_id] - получить текущую погоду для города
/// 2. GET weather/hourly/[city_id] - получить почасовую погоду для города на 24 часа
/// 3. GET weather/daily/[city_id] - получить погоду города на 10 дней
///
/// FAVORITES API
/// 1. GET favorites/ - получить список избранных городов || RESPONSE: {cities: [{city_id: 1, weather: {...}}, ...]}
/// 2. POST favorites/[city_id] - добавить город в избранное
/// 3. DELETE favorites/[city_id] - удалить город из избранного
///
/// CITIES API
/// 1. GET cities/ - получить список городов || RESPONSE: {cities: [{city_id: 1, name: 'Москва'}, ...]}
///
/// DATASOURCES
/// 1. WeatherDataSource - получает данные из WEATHER API
///    - getCurrentWeather - получает текущую погоду для города
///    - getHourlyWeather - получает почасовую погоду для города на 24 часа
///    - getDailyWeather - получает погоду города на 10 дней
///
/// 2. FavoritesDataSource - получает данные из FAVORITES API
///    - getFavorites - получает список избранных городов
///    - addFavorite - добавляет город в избранное
///    - removeFavorite - удаляет город из избранного
///
/// 3. CitiesDataSource - получает данные из CITIES API
///    - getCities - получает список городов
///
/// REPOSITORIES
/// 1. WeatherRepository
///    - getCurrentWeather - получает текущую погоду для города
///    - getHourlyWeather - получает почасовую погоду для города на 24 часа
///    - getDailyWeather - получает погоду города на 10 дней
///
/// 2. FavoritesRepository
///    - getFavorites - получает список избранных городов
///    - addFavorite - добавляет город в избранное
///    - removeFavorite - удаляет город из избранного
///
/// 3. CitiesRepository
///    - getCities - получает список городов
class FavoritesRemoteDataSource {
  final MyHttpClient _myHttpClient;
  final Random _random = Random();

  FavoritesRemoteDataSource({
    required MyHttpClient myHttpClient,
  }) : _myHttpClient = myHttpClient;

  // TODO(kshabanov): сделать все по конртактам как описывали выше
  // Future<List<FavoriteCityDto>> getFavoritesCities() async {
  //   final response = await _myHttpClient.get(
  //     'https://api.test.com/favorites/',
  //   );
  //   return response.map((e) => FavoriteCityDto.fromJson(e)).toList();
  // }

  Future<FavoritesCitiesDto> getFavoritesCities(int cityId) async {
    await _myHttpClient.get(
      'https://api.test.com/get_favorites_cities/$cityId',
    );

    // if (_random.nextBool()) {
    //   throw WeatherException('Ошибка загрузки избранных городов');
    // }

    final currentTemp = 10 + _random.nextInt(15);
    final high = currentTemp + _random.nextInt(5);
    final low = currentTemp - _random.nextInt(6);

    return FavoritesCitiesDto(
      cityId: cityId,
      city: '',
      currentTemp: currentTemp,
      high: high,
      low: low,
      condition: WeatherConditions.random(),
    );
  }

  Future<void> addFavoritesCities(int cityId) async {
    // TODO(kshabanov): use POST instead of ADD
    await _myHttpClient.add(
      'https://api.test.com/add_favorites_cities_list/$cityId',
    );
  }

  Future<void> removeFavoritesCities(int cityId) async {
    await _myHttpClient.delete(
      'https://api.test.com/remove_favorites_cities_list/$cityId',
    );
  }
}
