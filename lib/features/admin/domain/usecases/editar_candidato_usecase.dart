import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/data/repositories/candidato_repository.dart';

class EditarCandidatoUseCase {
  final CandidatoRepository repository;

  EditarCandidatoUseCase(this.repository);

  Future<void> call(Candidato candidato) async {
    if (candidato.id == null) {
      throw Exception("ID do candidato é obrigatório para edição");
    }
    if (candidato.nome.isEmpty) throw Exception("Nome é obrigatório");

    await repository.atualizarCandidato(candidato);
  }
}
