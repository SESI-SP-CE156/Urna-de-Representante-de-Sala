import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/features/admin/domain/entities/candidato_resultado.dart';

class ObterResultadoEleicaoUseCase {
  final EleicaoRepository repository;

  ObterResultadoEleicaoUseCase(this.repository);

  Future<List<CandidatoResultado>> call(int eleicaoId) async {
    return await repository.listarResultados(eleicaoId);
  }
}
