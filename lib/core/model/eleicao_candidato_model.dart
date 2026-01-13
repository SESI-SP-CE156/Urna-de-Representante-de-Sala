import 'package:urna/core/entities/eleicao_candidato.dart';

class EleicaoCandidatoModel extends EleicaoCandidato {
  const EleicaoCandidatoModel({
    required super.id,
    required super.candidatoId,
    required super.eleicaoId,
    super.qtdVotos,
  });

  factory EleicaoCandidatoModel.fromMap(Map<String, dynamic> map) {
    return EleicaoCandidatoModel(
      id: map['ID'] as int,
      candidatoId: map['FK_CANDIDATOS_ID'] as int,
      eleicaoId: map['FK_ELEICAO_ID'] as int,
      qtdVotos: (map['QTD_VOTOS'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'FK_CANDIDATOS_ID': candidatoId,
      'FK_ELEICAO_ID': eleicaoId,
      'QTD_VOTOS': qtdVotos,
    };
  }

  factory EleicaoCandidatoModel.fromEntity(EleicaoCandidato entity) {
    return EleicaoCandidatoModel(
      id: entity.id,
      candidatoId: entity.candidatoId,
      eleicaoId: entity.eleicaoId,
      qtdVotos: entity.qtdVotos,
    );
  }
}
