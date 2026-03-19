class FavoritesCitiesModel {
  final int cityId;
  final String city;
  final int currentTemp;
  final int high;
  final int low;
  final String condition;

  FavoritesCitiesModel({
    required this.cityId,
    required this.city,
    required this.currentTemp,
    required this.high,
    required this.low,
    required this.condition,
  });
}

// TODO(kshabanov): use this model instead of FavoritesCitiesModel
// class FavoriteCityModel {
//   final int id;
//   final String name;
//   final FavoriteCityWeatherModel weather;

//   FavoriteCityModel({
//     required this.id,
//     required this.name,
//     required this.weather,
//   });
// }

// class FavoriteCityWeatherModel {
//   final int temperatureCurrent;
//   final int temperatureMax;
//   final int temperatureMin;
//   final String condition;

//   FavoriteCityWeatherModel({
//     required this.temperatureCurrent,
//     required this.temperatureMax,
//     required this.temperatureMin,
//     required this.condition,
//   });
// }
