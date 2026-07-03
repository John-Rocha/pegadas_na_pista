import '../models/especie_model.dart';

abstract class EspecieLocalDataSource {
  Future<List<EspecieModel>> getEspecies();
}

class EspecieLocalDataSourceImpl implements EspecieLocalDataSource {
  @override
  Future<List<EspecieModel>> getEspecies() async => _seedEspecies;
}

const _seedEspecies = <EspecieModel>[
  EspecieModel(
    idEspecie: 'especie-1',
    nomePopular: 'Tamanduá-mirim',
    nomeCientifico: 'Tamandua tetradactyla',
    grupoTaxonomico: 'Mamífero',
  ),
  EspecieModel(
    idEspecie: 'especie-2',
    nomePopular: 'Jacaré-açu',
    nomeCientifico: 'Melanosuchus niger',
    grupoTaxonomico: 'Réptil',
  ),
  EspecieModel(
    idEspecie: 'especie-3',
    nomePopular: 'Tucano-toco',
    nomeCientifico: 'Ramphastos toco',
    grupoTaxonomico: 'Ave',
  ),
];
