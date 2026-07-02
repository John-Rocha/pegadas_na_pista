import 'package:equatable/equatable.dart';

class RecordPhoto extends Equatable {
  const RecordPhoto({
    this.localPath,
    this.urlFoto,
    required this.tipoFoto,
    this.ordem = 1,
  });

  final String? localPath;
  final String? urlFoto;
  final String tipoFoto;
  final int ordem;

  @override
  List<Object?> get props => [localPath, urlFoto, tipoFoto, ordem];
}
