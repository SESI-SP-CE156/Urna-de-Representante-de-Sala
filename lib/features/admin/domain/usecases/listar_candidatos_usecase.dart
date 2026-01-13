import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/data/repositories/candidato_repository.dart';

class ListarCandidatosUseCase {
  final CandidatoRepository repository;

  ListarCandidatosUseCase(this.repository);

  Future<List<Candidato>> call() async {
    return await repository.listarCandidatos();
  }
}
