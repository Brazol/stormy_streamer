import 'package:json_annotation/json_annotation.dart';

part 'open_meteo_domain.g.dart';

@JsonSerializable()
class OpenMeteoDaily {
  final List<DateTime> time;
  @JsonKey(name: 'weathercode')
  final List<int> weatherCode;
  @JsonKey(name: 'temperature_2m_max')
  final List<double> temperatureMax;

  const OpenMeteoDaily({
    this.time = const [],
    this.weatherCode = const [],
    this.temperatureMax = const [],
  });

  factory OpenMeteoDaily.fromJson(Map<String, dynamic> json) => _$OpenMeteoDailyFromJson(json);
}
