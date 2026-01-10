import 'generate.dart';
import 'package:flutter/material.dart';


class WeatherHeader extends StatelessWidget {
  final WeatherData weather;

  const WeatherHeader({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {

    final scale = MediaQuery.of(context).size.width / 375;

    return Column(
      children: [
        Text(
          "Мое местоположение",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16 * scale,
          ),
        ),
        Text(
          weather.city,
          style: TextStyle(
            color: Colors.white,
            fontSize: 36 * scale,
          ),
        ),
        Text(
          "${weather.currentTemp}°",
          style: TextStyle(
            fontSize: 90 * scale,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          weather.condition,
          style: TextStyle(fontSize: 22 * scale),
        ),
        Text(
          "H:${weather.high}°  L:${weather.low}°",
          style: TextStyle(fontSize: 14 * scale),
        ),
      ],
    );
  }
}


//     return Column(
//       children: [
//         const Text(
//           "Мое местоположение",
//           style: TextStyle(
//             color: Color.fromARGB(204, 255, 255, 255),
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           weather.city,
//           style: const TextStyle(color: Colors.white, fontSize: 36),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           "${weather.currentTemp}°",
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 100,
//             fontWeight: FontWeight.w200,
//           ),
//         ),
//         Text(
//           weather.condition,
//           style: const TextStyle(color: Colors.white70, fontSize: 24),
//         ),
//         Text(
//           "H:${weather.high}°  L:${weather.low}°",
//           style: const TextStyle(color: Colors.white60, fontSize: 16),
//         ),
//       ],
//     );
//   }
// }

class WeatherSummary extends StatelessWidget {
  final WeatherData weather;

  const WeatherSummary({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(26, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Завтра ожидается ${weather.changes} температуры, "
        "максимальная температура составит ${weather.tomorrowHigh}°.",
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecast({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
      //return SizedBox(
      return AspectRatio (
      //height: 120,
      aspectRatio: 4.5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final dataHour = hourly[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(dataHour.time, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Icon(
                WeatherGenerator.getWeatherIcon(dataHour.condition),
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text("${dataHour.temperature}°",
                  style: const TextStyle(color: Colors.white)),
              Text("${dataHour.precipitation}%",
                  style: const TextStyle(
                      color: Colors.lightBlueAccent, fontSize: 12)),
            ],
          );
        },
      ),
    );
  }
}

class ForecastInfo extends StatelessWidget {
  const ForecastInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.event_note,
            color: Color.fromARGB(179, 177, 173, 173),
            size: 16,
          ),
          SizedBox(width: 8),
          Text(
            "Прогноз погоды на 10 дней",
            style: TextStyle(
              color: Color.fromARGB(179, 177, 173, 173),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}


class DailyForecast extends StatelessWidget {
  final List<DailyWeather> daily;

  const DailyForecast({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: daily.map((dataDay) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(dataDay.day,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 18)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      WeatherGenerator.getWeatherIcon(dataDay.condition),
                      color: Colors.white,
                      size: 20,
                    ),
                    Text("${dataDay.precipitation}%",
                        style: const TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  "${dataDay.low}° / ${dataDay.high}°",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}