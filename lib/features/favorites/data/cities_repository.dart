import 'package:test_project_weather/features/favorites/data/datasources/cities_data_source.dart';
import 'package:test_project_weather/features/favorites/data/models/list_cities_model.dart';

class CitiesRepository {
  final CitiesDataSource _citiesDataSource;

  Future<List<ListCitiesModel>>? _cacheFuture;

  CitiesRepository({
    required CitiesDataSource citiesDataSource,
  }) : _citiesDataSource = citiesDataSource;

  Future<List<ListCitiesModel>> getListCities({bool forceRefresh = false}) {
    if (!forceRefresh && _cacheFuture != null) {
      return _cacheFuture!;
    }

    _cacheFuture = _citiesDataSource.getListCities().then((dtos) {
      final models = dtos
          .map((dto) => ListCitiesModel(cityId: dto.cityId, city: dto.city))
          .toList(growable: false);

      return List<ListCitiesModel>.unmodifiable(models);
    });

    return _cacheFuture!;
  }

  void clearCache() => _cacheFuture = null;
}
