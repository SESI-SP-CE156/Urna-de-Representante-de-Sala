import 'package:flutter/material.dart';
import 'package:urna/features/admin/domain/entities/candidato_resultado.dart';
import 'package:urna/features/admin/domain/usecases/obter_resultado_eleicao_usecase.dart';

class EleicaoDetalhesController extends ChangeNotifier {
  final ObterResultadoEleicaoUseCase _useCase;

  EleicaoDetalhesController(this._useCase);

  List<CandidatoResultado> resultados = [];
  bool isLoading = false;

  // Getter para o total calculado (caso queira validar com o da eleição)
  int get totalVotosCalculado =>
      resultados.fold(0, (sum, item) => sum + item.votos);

  Future<void> carregarDados(int eleicaoId) async {
    isLoading = true;
    notifyListeners();

    try {
      resultados = await _useCase(eleicaoId);
    } catch (e) {
      debugPrint("Erro ao carregar resultados: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
