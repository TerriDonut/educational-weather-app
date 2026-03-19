import 'package:flutter/material.dart';
import 'package:test_project_weather/core/di_container.dart';
import 'package:test_project_weather/features/city_details/domain/current_weather_bloc/current_weather_bloc.dart';
import 'package:test_project_weather/features/city_details/domain/current_weather_bloc/current_weather_state.dart';
import 'package:test_project_weather/features/city_details/domain/daily_weather_bloc/daily_weather_bloc.dart';
import 'package:test_project_weather/features/city_details/domain/daily_weather_bloc/daily_weather_state.dart';
import 'package:test_project_weather/features/city_details/domain/hourly_weather_bloc/hourly_weather_bloc.dart';
import 'package:test_project_weather/features/city_details/domain/hourly_weather_bloc/hourly_weather_state.dart';

part 'widgets/current_weather_section.dart';
part 'widgets/daily_weather_section.dart';
part 'widgets/hourly_weather_section.dart';

class WeatherScreen extends StatefulWidget {
  final int cityId;
  final String nameCity;
  final bool openedFromSearch;
  final Future<void> Function(int cityId)? onAddToFavorites;

  const WeatherScreen({
    required this.cityId,
    required this.nameCity,
    this.openedFromSearch = false,
    this.onAddToFavorites,
    super.key,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isAddingToFavorites = false;

  // TODO(kshabanov): не должно быть кнопки на уже избранном городе
  Future<void> _handleAddToFavorites() async {
    if (_isAddingToFavorites) {
      return;
    }

    final onAdd = widget.onAddToFavorites;
    if (onAdd == null) {
      return;
    }

    setState(() {
      _isAddingToFavorites = true;
    });

    try {
      await onAdd(widget.cityId);

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось добавить в избранное: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToFavorites = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = widget.openedFromSearch ? 72.0 : 0.0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 29, 36),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: topPadding),
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: _CurrentWeatherSection(widget.cityId, widget.nameCity),
              ),
              _HorlyWeatherSection(widget.cityId),
              _DailyWeatherSection(widget.cityId),
            ],
          ),

          if (widget.openedFromSearch)
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _isAddingToFavorites
                          ? null
                          : _handleAddToFavorites,
                      icon: _isAddingToFavorites
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final weatherConditionIcons = {
  'Ясно': Icons.wb_sunny,
  'Частично облачно': Icons.wb_cloudy,
  'Преимущественно облачно': Icons.cloud,
  'Дождь': Icons.umbrella,
  'Небольшой дождь': Icons.water_drop,
  'Тумано': Icons.opacity,
};
