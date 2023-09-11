library stormy_streamer;

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:stormy_streamer/predictor/stormy_configuration.dart';
import 'package:stormy_streamer/predictor/stormy_domain.dart';
import 'package:stormy_streamer/predictor/stormy_exception.dart';
import 'package:stormy_streamer/predictor/weather_api/weather_api.dart';
import 'package:stormy_streamer/predictor/weather_api/open_meteo_domain.dart';

/// Open Meteo API implementation of [WeatherApi].
///
/// API docs: [https://open-meteo.com/]
/// API is free for non-commercial use. For commercial use, you need to register and get an API key.
/// Forecast can be requested for next 16 days in free plan.
class OpenMeteoApi extends WeatherApi {
  OpenMeteoApi(super.configuration, {Dio? dio}) : _dio = dio ?? Dio();

  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';

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
          if (configuration.apiKey != null) 'apikey': configuration.apiKey,
          'latitude': latitude,
          'longitude': longitude,
          'daily': ['temperature_2m_max', 'weathercode'].join(','),
          'units': configuration.units.name,
          'start_date': DateFormat('yyyy-MM-dd').format(from.toUtc()),
          'end_date': DateFormat('yyyy-MM-dd').format(to.toUtc()),
          'timezone': 'GMT',
          'temperature_unit': configuration.units == Units.metric ? 'celsius' : 'fahrenheit',
        },
      );

      if (result.statusCode != 200) {
        throw StormyException('Open Meteo API - Invalid status code: ${result.statusCode}');
      }

      if (result.data == null) {
        return [];
      }

      final daily = OpenMeteoDaily.fromJson(result.data!['daily'] as Map<String, dynamic>);

      final forecast = <WeatherForecast>[];
      for (final (index, item) in daily.time.indexed) {
        forecast.add(
          WeatherForecast(
            date: item,
            temperture: daily.temperatureMax[index],
            condition: _mapCodeToCondition(daily.weatherCode[index]),
            units: configuration.units,
          ),
        );
      }

      return forecast;
    } catch (e) {
      throw StormyException('Open Meteo API - ${e.toString()}');
    }
  }

  /// Maps weather code to [WeatherCondition].
  /// Look for WMO Weather interpretation codes (WW) in [https://open-meteo.com/en/docs]
  WeatherCondition _mapCodeToCondition(int? weatherCode) {
    if (weatherCode == null) {
      return WeatherCondition.clear;
    }

    return switch (weatherCode) {
      < 4 => WeatherCondition.clear,
      <= 60 => WeatherCondition.cloudy,
      <= 70 || (>= 80 && <= 82) => WeatherCondition.rain,
      <= 80 || 85 || 86 => WeatherCondition.snow,
      > 90 => WeatherCondition.thunderstorm,
      _ => WeatherCondition.clear,
    };
  }

  @override
  void dispose() {
    _dio.close();
  }
}
