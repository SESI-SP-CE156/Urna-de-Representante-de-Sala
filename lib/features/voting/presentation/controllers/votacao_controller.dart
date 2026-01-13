import 'package:flutter/material.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/core/entities/eleicao.dart';

class VotacaoController extends ChangeNotifier {
  final EleicaoRepository _repository;

  // Dados da Eleição atual
  late Eleicao eleicao;
  List<Candidato> candidatos = [];

  bool isLoading = false;

  VotacaoController(this._repository);

  // Inicializa a tela carregando os candidatos
  Future<void> iniciarVotacao(Eleicao eleicaoSelecionada) async {
    eleicao = eleicaoSelecionada;
    isLoading = true;
    notifyListeners();

    try {
      candidatos = await _repository.listarCandidatosDaEleicao(eleicao.id!);
    } catch (e) {
      debugPrint("Erro ao carregar candidatos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> votar(int candidatoId) async {
    isLoading = true;
    notifyListeners();
    try {
      await _repository.registrarVoto(eleicao.id!, candidatoId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> finalizarVotacao() async {
    await _repository.finalizarEleicao(eleicao.id!);
  }
}
