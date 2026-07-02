import '../../domain/entities/especie.dart';

class EspecieModel extends Especie {
  const EspecieModel({
    required super.idEspecie,
    super.nomePopular,
    super.nomeCientifico,
    super.grupoTaxonomico,
  });

  factory EspecieModel.fromJson(Map<String, dynamic> json) => EspecieModel(
    idEspecie: json['idEspecie'] as String,
    nomePopular: json['nomePopular'] as String?,
    nomeCientifico: json['nomeCientifico'] as String?,
    grupoTaxonomico: json['grupoTaxonomico'] as String?,
  );
}
