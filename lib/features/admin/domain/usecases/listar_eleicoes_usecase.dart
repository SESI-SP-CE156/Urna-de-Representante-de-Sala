import 'package:urna/core/data/repositories/eleicao_repository.dart';

class ListarEleicoesUseCase {
  final EleicaoRepository repository;

  ListarEleicoesUseCase(this.repository);

  Future<List<EleicaoComTurma>> call() async {
    return await repository.listarEleicoesComTurma();
  }
}
