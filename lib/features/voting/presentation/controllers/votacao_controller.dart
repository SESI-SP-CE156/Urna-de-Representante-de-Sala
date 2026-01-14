import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/data/providers/eleicao_providers.dart';

part 'votacao_controller.g.dart';

// 1. Provider para Listar Candidatos daquela Eleição Específica
// Usamos .family para passar o ID da eleição como parâmetro
@riverpod
class VotacaoCandidatos extends _$VotacaoCandidatos {
  @override
  Future<List<Candidato>> build(int eleicaoId) async {
    final repository = ref.watch(eleicaoRepositoryProvider);
    return await repository.listarCandidatosDaEleicao(eleicaoId);
  }
}

// 2. Provider para Ações (Votar e Finalizar)
@Riverpod(keepAlive: true)
class VotacaoActions extends _$VotacaoActions {
  @override
  void build() {}

  Future<void> votar(int eleicaoId, int candidatoId) async {
    final repository = ref.read(eleicaoRepositoryProvider);
    await repository.registrarVoto(eleicaoId, candidatoId);
    // Não precisamos invalidar a lista de candidatos aqui, pois ela não muda ao votar.
  }

  Future<void> finalizar(int eleicaoId) async {
    final repository = ref.read(eleicaoRepositoryProvider);
    await repository.finalizarEleicao(eleicaoId);

    // Nenhuma invalidação local necessária aqui, pois sairemos da tela.
    // A invalidação deve ocorrer na tela de listagem de eleições.
  }
}
