class CurrentWeatherModel {
  final int cityId;
  final String city;
  final int currentTemp;
  final int high;
  final int low;
  final String condition;
  final int tomorrowHigh;
  final String changes;

  CurrentWeatherModel({
    required this.cityId,
    required this.city,
    required this.currentTemp,
    required this.high,
    required this.low,
    required this.condition,
    required this.tomorrowHigh,
    required this.changes,
  });
}
