import 'package:urna/core/domain/repositories/i_turma_repository.dart';

class DeletarTurmaUseCase {
  final ITurmaRepository repository;

  DeletarTurmaUseCase(this.repository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw Exception('ID inválido para deleção.');
    }
    await repository.deletarTurma(id);
  }
}
