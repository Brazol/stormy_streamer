library stormy_streamer;

/// Configuration class for the StormyPredictor
/// Supports two weather api services: Tomorrow and OpenMeteo
///
/// See also:
/// * [TomorrowWeatherApi]
/// * [OpenMeteoApi]
class StormyConfiguration {
  /// Units used for weather forecast, default is [Units.metric]
  final Units units;

  /// API key for weather api service
  final String? apiKey;

  /// Weather api service, default is [WeatheApiService.openMeteo]
  final WeatheApiService weatheApiService;

  const StormyConfiguration({
    this.apiKey,
    this.units = Units.metric,
    this.weatheApiService = WeatheApiService.openMeteo,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return (other is StormyConfiguration &&
        other.runtimeType == runtimeType &&
        other.units == units &&
        other.apiKey == apiKey &&
        other.weatheApiService == weatheApiService);
  }

  @override
  int get hashCode => Object.hash(apiKey, units, weatheApiService);
}

enum Units {
  metric,
  imperial,
}

enum WeatheApiService { tomorrow, openMeteo }
