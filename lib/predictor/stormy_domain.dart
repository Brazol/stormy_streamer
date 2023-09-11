import 'package:stormy_streamer/predictor/stormy_configuration.dart';

/// Holds result of a weather forecast request for a given date
class WeatherForecast {
  final DateTime date;
  final double? temperture;
  final WeatherCondition condition;
  final Units units;

  const WeatherForecast({
    required this.date,
    required this.temperture,
    required this.condition,
    required this.units,
  });
}

enum WeatherCondition {
  clear,
  cloudy,
  rain,
  snow,
  thunderstorm,
}
