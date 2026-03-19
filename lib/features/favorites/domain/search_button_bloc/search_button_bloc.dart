import 'dart:async';

import 'package:test_project_weather/features/common/weather_exception.dart';
import 'package:test_project_weather/features/favorites/data/cities_repository.dart';
import 'package:test_project_weather/features/favorites/data/models/list_cities_model.dart';
import 'package:test_project_weather/features/favorites/domain/search_button_bloc/search_button_state.dart';

class SearchButtonBloc {
  final CitiesRepository _citiesRepository;

  final StreamController<SearchButtonState> _stateController =
      StreamController<SearchButtonState>.broadcast();

  Stream<SearchButtonState> get state => _stateController.stream;

  List<_IndexedCity>? _indexed;
  String? _citiesError;

  Timer? _debounce;
  String _lastQuery = '';

  SearchButtonBloc({
    required CitiesRepository citiesRepository,
  }) : _citiesRepository = citiesRepository;

  Future<void> init() async {
    _emitState(const SearchButtonState$LoadingCities());

    try {
      final cities = await _citiesRepository.getListCities();

      _indexed = cities
          .map((c) => _IndexedCity(model: c, normName: _norm(c.city)))
          .toList(growable: false);

      _emitState(
        const SearchButtonState$Ready(
          query: '',
          suggestions: <ListCitiesModel>[],
        ),
      );
    } catch (e) {
      _citiesError = e is WeatherException ? e.message : e.toString();

      _emitState(
        SearchButtonState$Ready(
          query: '',
          suggestions: const <ListCitiesModel>[],
          citiesErrorMessage: _citiesError,
        ),
      );
    }
  }

  void onQueryChanged(String query) {
    _lastQuery = query;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 180), () {
      _recomputeSuggestions(_lastQuery);
    });
  }

  // void selectSuggestion(ListCitiesModel city) {
  //   _emitState(SearchButtonState$Selected(
  //     cityId: city.cityId,
  //     cityName: city.city,
  //   ));
  // }

  void clear() {
    _lastQuery = '';
    _emitState(
      SearchButtonState$Ready(
        query: '',
        suggestions: const <ListCitiesModel>[],
        citiesErrorMessage: _citiesError,
      ),
    );
  }

  void dispose() {
    _debounce?.cancel();
    if (!_stateController.isClosed) {
      _stateController.close();
    }
  }

  void _recomputeSuggestions(String queryRaw) {
    final idx = _indexed;

    if (idx == null) {
      _emitState(SearchButtonState$LoadingCities(query: queryRaw));
      return;
    }

    final q = _norm(queryRaw);

    if (q.isEmpty) {
      _emitState(
        SearchButtonState$Ready(
          query: queryRaw,
          suggestions: const <ListCitiesModel>[],
          citiesErrorMessage: _citiesError,
        ),
      );

      return;
    }

    final scored = <_ScoredCity>[];

    for (final c in idx) {
      final score = _score(q, c.normName);

      if (score > 0) {
        scored.add(_ScoredCity(model: c.model, score: score));
      }
    }

    scored.sort((a, b) {
      final s = b.score.compareTo(a.score);

      if (s != 0) {
        return s;
      }

      return a.model.city.compareTo(b.model.city);
    });

    final top = scored.take(5).map((e) => e.model).toList(growable: false);

    if (top.isEmpty) {
      _emitState(SearchButtonState$NoMatch(query: queryRaw));

      return;
    }

    _emitState(
      SearchButtonState$Ready(
        query: queryRaw,
        suggestions: top,
        citiesErrorMessage: _citiesError,
      ),
    );
  }

  String _norm(String s) {
    return s
        .trim()
        .toLowerCase()
        .replaceAll('ё', 'е')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  // TODO(kshabanov): переименовать в глагол
  // TODO(kshabanov): не использовать непонятные имена
  // TODO(kshabanov): возможно стоит разбить на несколько функций, если внутри этой несколько независимых сложных действий

  int _score(String q, String name) {
    if (name == q) {
      return 100000;
    }

    if (name.startsWith(q)) {
      return 90000 - (name.length - q.length);
    }

    final pos = name.indexOf(q);

    if (pos >= 0) {
      return 70000 - pos * 50 - (name.length - q.length);
    }

    final matched = _orderedMatchCount(q, name);
    final ratioOk = matched >= (q.length * 0.7).ceil();

    if (!ratioOk) {
      return 0;
    }

    return 40000 + matched * 500 - name.length;
  }

  int _orderedMatchCount(String q, String s) {
    int i = 0;
    int j = 0;
    int matched = 0;
    while (i < q.length && j < s.length) {
      if (q.codeUnitAt(i) == s.codeUnitAt(j)) {
        matched++;
        i++;
        j++;
      } else {
        j++;
      }
    }
    return matched;
  }

  void _emitState(SearchButtonState state) {
    if (_stateController.isClosed) {
      return;
    }
    _stateController.add(state);
  }
}

class _IndexedCity {
  final ListCitiesModel model;
  final String normName;

  const _IndexedCity({required this.model, required this.normName});
}

class _ScoredCity {
  final ListCitiesModel model;
  final int score;

  const _ScoredCity({required this.model, required this.score});
}
