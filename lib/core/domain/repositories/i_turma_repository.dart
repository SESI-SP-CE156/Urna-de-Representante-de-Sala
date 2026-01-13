import 'package:urna/core/entities/turma.dart';

abstract class ITurmaRepository {
  Future<int> criarTurma(Turma turma);
  Future<List<Turma>> listarTurmas();
  Future<void> atualizarTurma(Turma turma);
  Future<void> deletarTurma(int id);
}
