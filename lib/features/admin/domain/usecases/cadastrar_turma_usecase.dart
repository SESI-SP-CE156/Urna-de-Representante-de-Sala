import 'package:urna/core/domain/repositories/i_turma_repository.dart';
import 'package:urna/core/entities/turma.dart';

class CadastrarTurmaUseCase {
  final ITurmaRepository repository;

  CadastrarTurmaUseCase(this.repository);

  // O método 'call' permite chamar a classe como se fosse uma função
  Future<void> call(Turma turma) async {
    // 1. Regra de Negócio: Validação
    if (turma.serie <= 0) {
      throw Exception('A série deve ser maior que zero.');
    }

    if (turma.letra.trim().isEmpty) {
      throw Exception('A letra da turma não pode ser vazia.');
    }

    // 2. Regra de Negócio: Higienização de dados
    // Vamos criar uma nova instância garantindo letra maiúscula e sem espaços
    final turmaHigienizada = Turma(
      id: turma.id,
      serie: turma.serie,
      letra: turma.letra.trim().toUpperCase(),
      nivel: turma.nivel,
    );

    // 3. Persistência
    // Se tem ID atualiza, se não tem, cria.
    await repository.atualizarTurma(turmaHigienizada);
  }
}
