import 'package:urna/core/domain/repositories/i_turma_repository.dart';
import 'package:urna/core/entities/turma.dart';

class ListarTurmasUseCase {
  final ITurmaRepository repository;

  ListarTurmasUseCase(this.repository);

  Future<List<Turma>> call() async {
    final turmas = await repository.listarTurmas();

    // Regra de Negócio: Ordenação
    // Ordena por Série (crescente) e depois por Letra
    turmas.sort((a, b) {
      int compareSerie = a.serie.compareTo(b.serie);
      if (compareSerie != 0) return compareSerie;
      return a.letra.compareTo(b.letra);
    });

    return turmas;
  }
}
