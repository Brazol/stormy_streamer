// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tomorrow_domain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TomorrowTimeline _$TomorrowTimelineFromJson(Map<String, dynamic> json) =>
    TomorrowTimeline(
      timestep: json['timestep'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      intervals: (json['intervals'] as List<dynamic>)
          .map((e) => TomorrowInterval.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TomorrowTimelineToJson(TomorrowTimeline instance) =>
    <String, dynamic>{
      'timestep': instance.timestep,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'intervals': instance.intervals,
    };

TomorrowInterval _$TomorrowIntervalFromJson(Map<String, dynamic> json) =>
    TomorrowInterval(
      startTime: DateTime.parse(json['startTime'] as String),
      values: TomorrowValues.fromJson(json['values'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TomorrowIntervalToJson(TomorrowInterval instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'values': instance.values,
    };

TomorrowValues _$TomorrowValuesFromJson(Map<String, dynamic> json) =>
    TomorrowValues(
      weatherCode: json['weatherCode'] as int?,
      temperature: (json['temperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TomorrowValuesToJson(TomorrowValues instance) =>
    <String, dynamic>{
      'weatherCode': instance.weatherCode,
      'temperature': instance.temperature,
    };
