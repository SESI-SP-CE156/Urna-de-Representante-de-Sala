import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/data/repositories/candidato_repository.dart';

class CadastrarCandidatoUseCase {
  final CandidatoRepository repository;

  CadastrarCandidatoUseCase(this.repository);

  Future<void> call(Candidato candidato) async {
    if (candidato.nome.isEmpty) throw Exception("Nome é obrigatório");
    await repository.cadastrarCandidato(candidato);
  }
}
