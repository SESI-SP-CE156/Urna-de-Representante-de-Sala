class Candidato {
  final int? id;
  final String nome;
  final String? foto;
  final bool isAtivo;

  // Novos campos para estatísticas (opcionais, usados na listagem)
  final int qtdParticipacoes;
  final int qtdVitorias;

  const Candidato({
    this.id,
    required this.nome,
    this.foto,
    this.isAtivo = true,
    this.qtdParticipacoes = 0,
    this.qtdVitorias = 0,
  });
}
