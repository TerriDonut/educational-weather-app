import 'package:json_annotation/json_annotation.dart';

part 'current_weather_remote_today_data_dto.g.dart';

@JsonSerializable()
class CurrentWeatherRemoteTodayDataDto {
  // TODO(kshabanov): remove cityId
  final int cityId;
  final String city;
  final int currentTemp;
  final int high;
  final int low;

  CurrentWeatherRemoteTodayDataDto({
    required this.cityId,
    required this.city,
    required this.currentTemp,
    required this.high,
    required this.low,
  });

  factory CurrentWeatherRemoteTodayDataDto.fromJson(
    Map<String, dynamic> json,
  ) => _$CurrentWeatherRemoteTodayDataDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CurrentWeatherRemoteTodayDataDtoToJson(this);
}
