// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_meteo_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenMeteoDaily _$OpenMeteoDailyFromJson(Map<String, dynamic> json) =>
    OpenMeteoDaily(
      time: (json['time'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
      weatherCode: (json['weathercode'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      temperatureMax: (json['temperature_2m_max'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OpenMeteoDailyToJson(OpenMeteoDaily instance) =>
    <String, dynamic>{
      'time': instance.time.map((e) => e.toIso8601String()).toList(),
      'weathercode': instance.weatherCode,
      'temperature_2m_max': instance.temperatureMax,
    };
