import 'package:test_project_weather/features/favorites/data/models/favorites_cities_model.dart';

interface class FavoritesState {
  const FavoritesState();
}

class FavoritesState$Loading extends FavoritesState {
  const FavoritesState$Loading();
}

class FavoritesStateGet$Success extends FavoritesState {
  final List<String> favoriteCities;
  final Map<String, FavoritesCitiesModel> weatherByCity;

  const FavoritesStateGet$Success({
    required this.favoriteCities,
    required this.weatherByCity,
  });
}

class FavoritesStateAdd$Success extends FavoritesState {
  final List<String> favoriteCities;

  const FavoritesStateAdd$Success({
    required this.favoriteCities,
  });
}

class FavoritesStateDel$Success extends FavoritesState {
  final List<String> favoriteCities;

  const FavoritesStateDel$Success({
    required this.favoriteCities,
  });
}

class FavoritesState$Error extends FavoritesState {
  final String message;

  const FavoritesState$Error(this.message);
}
