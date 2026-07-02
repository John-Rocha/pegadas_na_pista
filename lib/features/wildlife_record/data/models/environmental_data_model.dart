import '../../domain/entities/environmental_data.dart';

class EnvironmentalDataModel extends EnvironmentalData {
  const EnvironmentalDataModel({
    super.weather,
    super.dayPeriod,
    super.temperature,
    super.humidity,
    super.precipitation,
    super.roadCondition,
    super.luminosity,
    super.visibility,
    super.notes,
  });

  factory EnvironmentalDataModel.fromEntity(EnvironmentalData data) =>
      EnvironmentalDataModel(
        weather: data.weather,
        dayPeriod: data.dayPeriod,
        temperature: data.temperature,
        humidity: data.humidity,
        precipitation: data.precipitation,
        roadCondition: data.roadCondition,
        luminosity: data.luminosity,
        visibility: data.visibility,
        notes: data.notes,
      );

  Map<String, dynamic> toJson() => {
    'clima': weather,
    'periodoDia': dayPeriod,
    'temperaturaC': temperature,
    'umidadePercentual': humidity,
    'precipitacaoMm': precipitation,
    'condicaoPista': roadCondition,
    'luminosidade': luminosity,
    'visibilidade': visibility,
    'observacaoAmbiental': notes,
  };
}
