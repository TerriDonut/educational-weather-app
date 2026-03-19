import 'package:flutter/material.dart';
import 'package:test_project_weather/core/di_container.dart';
import 'package:test_project_weather/features/favorites/data/models/favorites_cities_model.dart';
import 'package:test_project_weather/features/favorites/data/models/list_cities_model.dart';
import 'package:test_project_weather/features/favorites/domain/favorites_cities_bloc/favorites_cities_bloc.dart';
import 'package:test_project_weather/features/favorites/domain/favorites_cities_bloc/favorites_state.dart';
import 'package:test_project_weather/features/favorites/domain/search_button_bloc/search_button_bloc.dart';
import 'package:test_project_weather/features/favorites/domain/search_button_bloc/search_button_state.dart';

part 'widgets/list_favorites_cities_section.dart';
part 'widgets/search_button_cities_section.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesCitiesBloc _favoritesCitiesBloc;
  late final SearchButtonBloc _searchButtonBloc;

  FavoritesStateGet$Success? _lastLoadedFavoritesState;
  bool _isWeatherScreenPushed = false;

  @override
  void initState() {
    super.initState();

    _favoritesCitiesBloc = FavoritesCitiesBloc(
      citiesRepository: DIContainer.citiesRepository,
      favoritesRepository: DIContainer.favoritesScreenRepository,
    );

    _searchButtonBloc = SearchButtonBloc(
      citiesRepository: DIContainer.citiesRepository,
    );

    _favoritesCitiesBloc.getFavoritesCities();
    _searchButtonBloc.init();
  }

  @override
  void dispose() {
    _favoritesCitiesBloc.dispose();
    _searchButtonBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: StreamBuilder<FavoritesState>(
        stream: _favoritesCitiesBloc.state,
        builder: (context, snapshot) {
          final state = snapshot.data;

          if (state is FavoritesStateGet$Success) {
            _lastLoadedFavoritesState = state;
          }

          final dataState = state is FavoritesStateGet$Success
              ? state
              : _lastLoadedFavoritesState;

          if (dataState == null) {
            if (state is FavoritesState$Error) {
              return _FavoritesErrorSection(
                message: state.message,
                onRetry: _favoritesCitiesBloc.getFavoritesCities,
              );
            }

            return const Center(child: CircularProgressIndicator());
          }

          _tryOpenWeatherScreen(
            dataState.favoriteCities,
            dataState.weatherByCity,
          );

          return Stack(
            children: [
              _ListFavoritesCitiesSection(
                favoriteCities: dataState.favoriteCities,
                weatherByCity: dataState.weatherByCity,
                onTapCity: _openWeatherFromFavorites,
                onRemoveCity: _favoritesCitiesBloc.removeFavoriteCity,
              ),
              if (state is FavoritesState$Loading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(22),
        child: StreamBuilder<SearchButtonState>(
          stream: _searchButtonBloc.state,
          initialData: const SearchButtonState$LoadingCities(),
          builder: (context, snapshot) {
            final state =
                snapshot.data ?? const SearchButtonState$LoadingCities();

            return _SearchButtonCitiesSection(
              state: state,
              onQueryChanged: _searchButtonBloc.onQueryChanged,
              onSelectedCity: (city) {
                _searchButtonBloc.clear();
                _openWeatherFromSearch(city);
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _addCityToFavorites(int cityId) async {
    await _favoritesCitiesBloc.addFavoriteCity(cityId);
  }

  void _openWeatherFromFavorites(FavoritesCitiesModel cityWeather) {
    Navigator.pushNamed(
      context,
      '/weather',
      arguments: {
        'cityId': cityWeather.cityId,
        'cityName': cityWeather.city,
        'openedFromSearch': false,
        'onAddToFavorites': _addCityToFavorites,
      },
    );
  }

  void _openWeatherFromSearch(ListCitiesModel city) {
    Navigator.pushNamed(
      context,
      '/weather',
      arguments: {
        'cityId': city.cityId,
        'cityName': city.city,
        'openedFromSearch': true,
        'onAddToFavorites': _addCityToFavorites,
      },
    );
  }

  void _tryOpenWeatherScreen(
    List<String> favoriteCities,
    Map<String, FavoritesCitiesModel> weatherByCity,
  ) {
    if (_isWeatherScreenPushed || favoriteCities.isEmpty) {
      return;
    }

    final firstCityName = favoriteCities.first;
    final firstCityWeather = weatherByCity[firstCityName];

    if (firstCityWeather == null) {
      return;
    }

    _isWeatherScreenPushed = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _openWeatherFromFavorites(firstCityWeather);
    });
  }
}

class _FavoritesErrorSection extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FavoritesErrorSection({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}

/////
/// internationalization - i18n
/// localization - l10n
enum Language { en, ru, fr, cn }

Language selectedLanguage = Language.en;

void changeLanguage(Language language) {
  selectedLanguage = language;
}

Map<String, String> frDictionary = {
  'changeLanguage': 'Changer la langue',
  'settings': 'Paramètres',
  'profile': 'Profil',
  'favorites': 'Favoris',
};

Map<String, String> enDictionary = {
  'changeLanguage': 'Change language',
  'settings': 'Settings',
  'profile': 'Profile',
  'favorites': 'Favorites',
};

Map<String, String> ruDictionary = {
  'changeLanguage': 'Изменить язык',
  'settings': 'Настройки',
  'profile': 'Профиль',
  'favorites': 'Избранное',
};

Map<String, String> cnDictionary = {
  'changeLanguage': '更改语言',
  'settings': '设置',
  'profile': '个人资料',
  'favorites': '收藏',
};

String getText(String key) {
  switch (selectedLanguage) {
    case Language.en:
      return enDictionary[key]!;
    case Language.ru:
      return ruDictionary[key]!;
    case Language.fr:
      return frDictionary[key]!;
    case Language.cn:
      return cnDictionary[key]!;
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          child: Text(getText('changeLanguage')),
          onPressed: () {
            changeLanguage(
              selectedLanguage == Language.en ? Language.ru : Language.en,
            );
          },
        ),
        Text(getText('settings')),
        Text(getText('profile')),
        Text(getText('favorites')),
      ],
    );
  }
}

//// Themes
/// dark theme
/// light theme
/// same implementation
