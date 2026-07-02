import '../../domain/entities/sighting_details.dart';

class SightingDetailsModel extends SightingDetails {
  const SightingDetailsModel({
    super.quantity,
    super.observedBehavior,
    super.approximateDistance,
    super.animalAlive,
  });

  factory SightingDetailsModel.fromEntity(SightingDetails details) =>
      SightingDetailsModel(
        quantity: details.quantity,
        observedBehavior: details.observedBehavior,
        approximateDistance: details.approximateDistance,
        animalAlive: details.animalAlive,
      );

  Map<String, dynamic> toJson() => {
    'quantidadeIndividuos': quantity,
    'comportamentoObservado': observedBehavior,
    'distanciaAproximadaM': approximateDistance,
    'animalVivo': animalAlive,
  };
}
