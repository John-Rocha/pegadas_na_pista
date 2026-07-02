import '../../domain/entities/roadkill_details.dart';

class RoadkillDetailsModel extends RoadkillDetails {
  const RoadkillDetailsModel({
    super.carcassCondition,
    super.animalPosition,
    super.roadDirection,
    super.roadLane,
  });

  factory RoadkillDetailsModel.fromEntity(RoadkillDetails details) =>
      RoadkillDetailsModel(
        carcassCondition: details.carcassCondition,
        animalPosition: details.animalPosition,
        roadDirection: details.roadDirection,
        roadLane: details.roadLane,
      );

  Map<String, dynamic> toJson() => {
    'condicaoCarcaca': carcassCondition,
    'posicaoAnimal': animalPosition,
    'sentidoVia': roadDirection,
    'faixaRodovia': roadLane,
  };
}
