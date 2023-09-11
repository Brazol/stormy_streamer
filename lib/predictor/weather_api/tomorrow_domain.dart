import 'package:json_annotation/json_annotation.dart';

part 'tomorrow_domain.g.dart';

@JsonSerializable()
class TomorrowTimeline {
  final String timestep;
  final DateTime startTime;
  final DateTime endTime;
  final List<TomorrowInterval> intervals;

  const TomorrowTimeline({
    required this.timestep,
    required this.startTime,
    required this.endTime,
    required this.intervals,
  });

  factory TomorrowTimeline.fromJson(Map<String, dynamic> json) => _$TomorrowTimelineFromJson(json);
}

@JsonSerializable()
class TomorrowInterval {
  final DateTime startTime;
  final TomorrowValues values;

  const TomorrowInterval({
    required this.startTime,
    required this.values,
  });

  factory TomorrowInterval.fromJson(Map<String, dynamic> json) => _$TomorrowIntervalFromJson(json);
}

@JsonSerializable()
class TomorrowValues {
  final int? weatherCode;
  final double? temperature;

  const TomorrowValues({this.weatherCode, this.temperature});

  factory TomorrowValues.fromJson(Map<String, dynamic> json) => _$TomorrowValuesFromJson(json);
}
