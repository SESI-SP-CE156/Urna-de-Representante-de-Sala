import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/data/providers/candidato_providers.dart';

part 'candidatos_controller.g.dart';

// Este provider gerencia a LISTA de candidatos (estado de leitura)
@riverpod
class CandidatosList extends _$CandidatosList {
  @override
  Future<List<Candidato>> build() async {
    // Acessa o repositório via provider
    final repository = ref.watch(candidatoRepositoryProvider);
    // Retorna a lista. O Riverpod cuida do try/catch e loading automaticamente.
    return await repository.listarCandidatos();
  }
}

// Este provider serve para AÇÕES (criar, editar, deletar)
@Riverpod(keepAlive: true)
class CandidatosActions extends _$CandidatosActions {
  @override
  void build() {} // Sem estado inicial complexo

  Future<void> cadastrar(Candidato candidato) async {
    final repository = ref.read(candidatoRepositoryProvider);
    await repository.cadastrarCandidato(candidato);

    // Mágica do Riverpod: Invalida a lista para forçar o recarregamento automático
    ref.invalidate(candidatosListProvider);
  }

  Future<void> editar(Candidato candidato) async {
    final repository = ref.read(candidatoRepositoryProvider);
    await repository.atualizarCandidato(candidato);
    ref.invalidate(candidatosListProvider);
  }

  Future<void> deletar(int id) async {
    final repository = ref.read(candidatoRepositoryProvider);
    await repository.deletarCandidato(id);
    ref.invalidate(candidatosListProvider);
  }

  // NOVO MÉTODO
  Future<void> reativar(int id) async {
    final repository = ref.read(candidatoRepositoryProvider);
    await repository.reativarCandidato(id);
    ref.invalidate(candidatosListProvider);
  }
}
