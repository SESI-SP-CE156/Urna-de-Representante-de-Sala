import '../entities/candidato.dart';

class CandidatoModel extends Candidato {
  const CandidatoModel({
    super.id,
    required super.nome,
    super.foto,
    super.isAtivo,
    super.qtdParticipacoes,
    super.qtdVitorias,
  });

  factory CandidatoModel.fromMap(Map<String, dynamic> map) {
    return CandidatoModel(
      id: map['ID'] as int?,
      nome: (map['NOME'] ?? map['nome'] ?? '') as String,
      foto: map['FOTO'] as String?,
      isAtivo: (map['STATUS'] as int? ?? 1) == 1,
      // Mapeia colunas calculadas se existirem
      qtdParticipacoes: (map['QTD_PARTICIPACOES'] as int?) ?? 0,
      qtdVitorias: (map['QTD_VITORIAS'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'ID': id,
      'NOME': nome,
      'FOTO': foto,
      // Converte true para 1, false para 0
      'STATUS': isAtivo ? 1 : 0,
    };
  }

  // Helper para converter da entidade base
  factory CandidatoModel.fromEntity(Candidato entity) {
    return CandidatoModel(
      id: entity.id,
      nome: entity.nome,
      foto: entity.foto,
      isAtivo: entity.isAtivo,
    );
  }
}
