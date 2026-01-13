import 'package:urna/core/utils/nivel_ensino.dart';

class Turma {
  final int id;
  final int serie;
  final String letra;
  final NivelEnsino nivel;

  const Turma({
    required this.id,
    required this.serie,
    required this.letra,
    required this.nivel,
  });

  // Helper visual para UI (ex: "3º A - Ensino Médio")
  String get descricaoCompleta => '$serieº $letra - ${nivel.label}';
}
