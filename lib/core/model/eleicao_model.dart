import '../entities/eleicao.dart';

class EleicaoModel extends Eleicao {
  const EleicaoModel({
    super.id,
    required super.titulo,
    required super.ano,
    super.totalVotos,
    required super.turmaId,
    super.isAberta,
  });

  factory EleicaoModel.fromMap(Map<String, dynamic> map) {
    return EleicaoModel(
      id: map['ID'] as int?,
      titulo: map['TITULO'] as String? ?? '',
      ano: map['ANO'] as int,
      totalVotos: (map['TOTAL_VOTOS'] as int?) ?? 0,
      turmaId: map['FK_TURMA_ID'] as int,
      isAberta: (map['STATUS'] as int? ?? 1) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'ID': id,
      'TITULO': titulo,
      'ANO': ano,
      'TOTAL_VOTOS': totalVotos,
      'FK_TURMA_ID': turmaId,
      'STATUS': isAberta ? 1 : 0,
    };
  }
}
