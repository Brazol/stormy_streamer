library stormy_streamer;

import 'package:dio/dio.dart';
import 'package:stormy_streamer/predictor/stormy_domain.dart';
import 'package:stormy_streamer/predictor/stormy_exception.dart';
import 'package:stormy_streamer/predictor/weather_api/weather_api.dart';
import 'package:stormy_streamer/predictor/weather_api/tomorrow_domain.dart';

/// Tomorrow API implementation of [WeatherApi].
///
/// API docs: [https://docs.tomorrow.io/reference/weather-forecast]
/// API requires an API key. In free plan forecast can be requested for next 5 days.
class TomorrowWeatherApi extends WeatherApi {
  TomorrowWeatherApi(super.configuration, {Dio? dio})
      : _dio = dio ?? Dio(),
        assert(configuration.apiKey != null, 'API key is required');

  static const String _baseUrl = 'https://api.tomorrow.io/v4/timelines';

  final Dio _dio;

  @override
  Future<List<WeatherForecast>> weatherForecastForLocation(
    double latitude,
    double longitude,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final result = await _dio.get<Map<String, dynamic>>(
        _baseUrl,
        queryParameters: <String, dynamic>{
          'apikey': configuration.apiKey,
          'location': [latitude, longitude].join(','),
          'fields': ['temperature', 'weatherCode'].join(','),
          'startTime': from.toUtc().toIso8601String(),
          'endTime': to.toUtc().toIso8601String(),
          'timesteps': '1d',
          'units': configuration.units.name,
        },
      );

      if (result.statusCode != 200) {
        throw StormyException('Tomorrow API - Invalid status code: ${result.statusCode}');
      }

      if (result.data == null) {
        return [];
      }

      final timelines = (result.data!['data']['timelines'] as List)
          .map<Map<String, dynamic>>((dynamic e) => e as Map<String, dynamic>)
          .map((map) => TomorrowTimeline.fromJson(map))
          .toList();

      final forcastByDay = timelines.firstOrNull?.intervals
          .map(
            (interval) => WeatherForecast(
              date: interval.startTime,
              temperture: interval.values.temperature,
              condition: _mapCodeToCondition(interval.values.weatherCode),
              units: configuration.units,
            ),
          )
          .toList();

      return forcastByDay ?? <WeatherForecast>[];
    } catch (e) {
      if (e is DioException) {
        throw StormyException('Tomorrow API - ${e.response?.data}');
      }

      throw StormyException('Tomorrow API - ${e.toString()}');
    }
  }

  /// Maps weather code to [WeatherCondition].
  /// More detailed codes can be found in [https://docs.tomorrow.io/reference/data-layers-weather-codes]
  WeatherCondition _mapCodeToCondition(int? weatherCode) {
    if (weatherCode == null) {
      return WeatherCondition.clear;
    }

    return switch (weatherCode) {
      1000 || 1100 => WeatherCondition.clear,
      1001 || (>= 1101 && <= 2100) => WeatherCondition.cloudy,
      >= 4000 && <= 4201 => WeatherCondition.rain,
      >= 5000 && <= 7102 => WeatherCondition.snow,
      8000 => WeatherCondition.thunderstorm,
      _ => WeatherCondition.clear,
    };
  }

  @override
  void dispose() {
    _dio.close();
  }
}
