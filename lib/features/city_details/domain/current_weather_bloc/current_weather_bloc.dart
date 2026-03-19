import 'dart:async';

import 'package:test_project_weather/features/city_details/data/city_details_repository.dart';
import 'package:test_project_weather/features/city_details/domain/current_weather_bloc/current_weather_state.dart';
import 'package:test_project_weather/features/common/weather_exception.dart';

class CurrentWeatherBloc {
  final CityDetailsRepository _weatherScreenRepository;

  final StreamController<CurrentWeatherState> _stateController =
      StreamController<CurrentWeatherState>.broadcast();

  Stream<CurrentWeatherState> get state => _stateController.stream;

  CurrentWeatherBloc({
    required CityDetailsRepository weatherScreenRepository,
  }) : _weatherScreenRepository = weatherScreenRepository;

  Future<void> getCurrentWeather(int cityId, String nameCity) async {
    _emitState(const CurrentWeatherState$Loading());

    try {
      final currentWeather = await _weatherScreenRepository.getCurrentWeather(
        cityId,
        nameCity,
      );

      _emitState(CurrentWeatherState$Success(currentWeather));
    } catch (e) {
      final message = e is WeatherException ? e.message : e.toString();

      _emitState(CurrentWeatherState$Error(message));
    }
  }

  void dispose() {
    if (!_stateController.isClosed) {
      _stateController.close();
    }
  }

  void _emitState(CurrentWeatherState state) {
    if (_stateController.isClosed) {
      return;
    }

    _stateController.add(state);
  }
}
