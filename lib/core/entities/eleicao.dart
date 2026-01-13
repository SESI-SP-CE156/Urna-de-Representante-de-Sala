class Eleicao {
  final int? id;
  final String titulo;
  final int ano;
  final int totalVotos;
  final int turmaId;
  final bool isAberta; // Novo campo status

  const Eleicao({
    this.id,
    required this.titulo,
    required this.ano,
    this.totalVotos = 0,
    required this.turmaId,
    this.isAberta = true,
  });
}
