library stormy_streamer;

import 'package:stormy_streamer/predictor/stormy_configuration.dart';
import 'package:stormy_streamer/predictor/stormy_domain.dart';

/// Abstract class for weather api access
///
/// See also:
/// * [OpenMeteoApi]
/// * [TomorrowWeatherApi]
abstract class WeatherApi {
  final StormyConfiguration configuration;

  WeatherApi(this.configuration);

  /// Returns a list of [WeatherForecast] for the given location and time range.
  Future<List<WeatherForecast>> weatherForecastForLocation(
      double latitude, double longitude, DateTime from, DateTime to);

  void dispose();
}
