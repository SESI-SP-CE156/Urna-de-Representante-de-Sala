class EleicaoCandidato {
  final int id;
  final int candidatoId;
  final int eleicaoId;
  final int qtdVotos;

  const EleicaoCandidato({
    required this.id,
    required this.candidatoId,
    required this.eleicaoId,
    this.qtdVotos = 0,
  });
}
