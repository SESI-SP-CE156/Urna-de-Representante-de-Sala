import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/core/entities/eleicao.dart';

class CadastrarEleicaoUseCase {
  final EleicaoRepository repository;

  CadastrarEleicaoUseCase(this.repository);

  Future<void> call(Eleicao eleicao, List<int> candidatosIds) async {
    if (eleicao.titulo.isEmpty) {
      throw Exception("O título da eleição é obrigatório.");
    }
    if (eleicao.turmaId <= 0) throw Exception("Selecione uma turma.");
    if (candidatosIds.length < 2) {
      throw Exception("Selecione pelo menos 2 candidatos.");
    }

    await repository.criarEleicao(eleicao, candidatosIds);
  }
}
