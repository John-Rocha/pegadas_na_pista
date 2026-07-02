import 'package:equatable/equatable.dart';

class EnvironmentalData extends Equatable {
  const EnvironmentalData({
    this.weather,
    this.dayPeriod,
    this.temperature,
    this.humidity,
    this.precipitation,
    this.roadCondition,
    this.luminosity,
    this.visibility,
    this.notes,
  });

  final String? weather;
  final String? dayPeriod;
  final double? temperature;
  final double? humidity;
  final double? precipitation;
  final String? roadCondition;
  final String? luminosity;
  final String? visibility;
  final String? notes;

  @override
  List<Object?> get props => [
    weather,
    dayPeriod,
    temperature,
    humidity,
    precipitation,
    roadCondition,
    luminosity,
    visibility,
    notes,
  ];
}
