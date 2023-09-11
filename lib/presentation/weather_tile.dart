import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stormy_streamer/predictor/stormy_configuration.dart';
import 'package:stormy_streamer/predictor/stormy_domain.dart';

/// Tile used in [StormyForecastPanel] to display weather forecast for a given day.
class StormyWeatherTile extends StatelessWidget {
  final WeatherForecast forecast;

  const StormyWeatherTile({
    required this.forecast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            DateFormat(DateFormat.ABBR_MONTH_DAY).format(forecast.date),
          ),
          const Divider(
            color: Colors.white,
          ),
          _buildConditionIcon(forecast.condition),
          const SizedBox(height: 4),
          Text(
            '${forecast.temperture?.ceil() ?? ' - '}°${forecast.units == Units.metric ? 'C' : 'F'}',
          ),
        ],
      ),
    );
  }

  Widget _buildConditionIcon(WeatherCondition condition) {
    return switch (condition) {
      WeatherCondition.clear => Image.asset('assets/clear.png', package: 'stormy_streamer', width: 50),
      WeatherCondition.cloudy => Image.asset('assets/cloudy.png', package: 'stormy_streamer', width: 50),
      WeatherCondition.rain => Image.asset('assets/rain.png', package: 'stormy_streamer', width: 50),
      WeatherCondition.snow => Image.asset('assets/snow.png', package: 'stormy_streamer', width: 50),
      WeatherCondition.thunderstorm => Image.asset('assets/thunder.png', package: 'stormy_streamer', width: 50),
    };
  }
}
