import 'package:urna/core/entities/turma.dart';
import 'package:urna/core/utils/nivel_ensino.dart';

class TurmaModel extends Turma {
  const TurmaModel({
    required super.id,
    required super.serie,
    required super.letra,
    required super.nivel,
  });

  factory TurmaModel.fromMap(Map<String, dynamic> map) {
    return TurmaModel(
      id: map['ID'] as int,
      serie: map['SERIE'] as int,
      letra: map['LETRA'] as String,
      // Converte a String do banco para o Enum
      nivel: NivelEnsino.fromString(map['NIVEL'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'SERIE': serie,
      'LETRA': letra,
      // Grava a String formatada no banco ('Ensino Fundamental')
      'NIVEL': nivel.label,
    };
  }

  factory TurmaModel.fromEntity(Turma entity) {
    return TurmaModel(
      id: entity.id,
      serie: entity.serie,
      letra: entity.letra,
      nivel: entity.nivel,
    );
  }
}
