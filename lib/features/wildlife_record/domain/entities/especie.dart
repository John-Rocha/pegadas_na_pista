import 'package:equatable/equatable.dart';

class Especie extends Equatable {
  const Especie({
    required this.idEspecie,
    this.nomePopular,
    this.nomeCientifico,
    this.grupoTaxonomico,
  });

  final String idEspecie;
  final String? nomePopular;
  final String? nomeCientifico;
  final String? grupoTaxonomico;

  @override
  List<Object?> get props => [
    idEspecie,
    nomePopular,
    nomeCientifico,
    grupoTaxonomico,
  ];
}
