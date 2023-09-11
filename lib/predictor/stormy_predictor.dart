library stormy_streamer;

import 'package:stormy_streamer/predictor/stormy_configuration.dart';
import 'package:stormy_streamer/predictor/stormy_domain.dart';
import 'package:stormy_streamer/predictor/weather_api/weather_api.dart';
import 'package:stormy_streamer/predictor/weather_api/open_meteo_api.dart';
import 'package:stormy_streamer/predictor/weather_api/tomorrow_api.dart';

/// Weather predictor class, can be used to get weather forecast for a given location and time range.
/// Depending on configuration will use [TomorrowWeatherApi] or [OpenMeteoApi] to get weather forecast.
class StormyPredictor {
  static const Duration _fourDays = Duration(days: 4);

  final StormyConfiguration configuration;
  final WeatherApi _weatherProvider;

  StormyPredictor({this.configuration = const StormyConfiguration()})
      : _weatherProvider = _weatherProviderFactory(configuration);

  StormyPredictor.withCustomApi(WeatherApi weatherApi)
      : configuration = weatherApi.configuration,
        _weatherProvider = weatherApi;

  static WeatherApi _weatherProviderFactory(StormyConfiguration configuration) {
    return switch (configuration.weatheApiService) {
      WeatheApiService.tomorrow => TomorrowWeatherApi(configuration),
      WeatheApiService.openMeteo => OpenMeteoApi(configuration),
    };
  }

  /// Returns a list of [WeatherForecast] for the given location for the given date and next 4 days.
  Future<List<WeatherForecast>> fiveDaysForecast(double latitude, double longitude, DateTime from) {
    return weatherForecast(latitude, longitude, from, from.add(_fourDays));
  }

  /// Returns a [WeatherForecast] for the given location and date.
  Future<WeatherForecast> singleDayForecast(double latitude, double longitude, DateTime date) {
    return weatherForecast(latitude, longitude, date, date).then((value) => value.first);
  }

  /// Returns a list of [WeatherForecast] for the given location and time range.
  Future<List<WeatherForecast>> weatherForecast(
    double latitude,
    double longitude,
    DateTime from,
    DateTime to,
  ) {
    return _weatherProvider.weatherForecastForLocation(latitude, longitude, from, to);
  }

  void dispose() {
    _weatherProvider.dispose();
  }
}
