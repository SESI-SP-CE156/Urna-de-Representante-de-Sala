import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/features/admin/data/providers/eleicao_providers.dart';

part 'eleicoes_controller.g.dart';

// 1. Provider da LISTA (Gerencia o estado de leitura)
// Este pode continuar AutoDispose (padrão), pois a UI o assiste (watch)
@riverpod
class EleicoesList extends _$EleicoesList {
  @override
  Future<List<EleicaoComTurma>> build() async {
    final repository = ref.watch(eleicaoRepositoryProvider);
    return await repository.listarEleicoesComTurma();
  }
}

// 2. Provider de AÇÕES (Gerencia cadastros e exclusões)
// ALTERAÇÃO AQUI: Adicione keepAlive: true para evitar o descarte prematuro
@Riverpod(keepAlive: true)
class EleicoesActions extends _$EleicoesActions {
  @override
  void build() {}

  Future<void> deletar(int eleicaoId) async {
    final repository = ref.read(eleicaoRepositoryProvider);
    await repository.deletarEleicao(eleicaoId);

    // Agora é seguro chamar ref.invalidate, pois o provider continua vivo
    ref.invalidate(eleicoesListProvider);
  }
}
