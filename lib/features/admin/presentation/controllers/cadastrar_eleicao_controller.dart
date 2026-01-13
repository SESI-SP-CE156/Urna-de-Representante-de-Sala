import 'package:flutter/material.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/core/entities/eleicao.dart';
import 'package:urna/core/entities/turma.dart';
import 'package:urna/features/admin/domain/usecases/cadastrar_eleicao_usecase.dart';
import 'package:urna/features/admin/domain/usecases/listar_candidatos_usecase.dart';
import 'package:urna/features/admin/domain/usecases/listar_turmas_usecase.dart';

class CadastrarEleicaoController extends ChangeNotifier {
  final CadastrarEleicaoUseCase _cadastrarEleicaoUseCase;
  final ListarTurmasUseCase _listarTurmasUseCase;
  final ListarCandidatosUseCase _listarCandidatosUseCase;

  CadastrarEleicaoController(
    this._cadastrarEleicaoUseCase,
    this._listarTurmasUseCase,
    this._listarCandidatosUseCase,
  );

  bool isLoading = false;
  String? errorMessage;

  // Dados para Seleção
  List<Turma> turmas = [];
  List<Candidato> candidatosDisponiveis = [];

  // Dados do Formulário
  Turma? turmaSelecionada;
  final Set<int> candidatosSelecionadosIds =
      {}; // Set para evitar duplicatas e busca rápida

  Future<void> carregarDados() async {
    isLoading = true;
    notifyListeners();
    try {
      // Carrega turmas e candidatos em paralelo
      await Future.wait([
        _listarTurmasUseCase().then((value) => turmas = value),
        _listarCandidatosUseCase().then((value) {
          // Filtra apenas ativos
          candidatosDisponiveis = value.where((c) => c.isAtivo).toList();
        }),
      ]);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleCandidato(int id) {
    if (candidatosSelecionadosIds.contains(id)) {
      candidatosSelecionadosIds.remove(id);
    } else {
      candidatosSelecionadosIds.add(id);
    }
    notifyListeners();
  }

  Future<bool> salvarEleicao(String titulo, String anoStr) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final ano = int.tryParse(anoStr);
      if (ano == null) throw Exception("Ano inválido");
      if (turmaSelecionada == null) throw Exception("Selecione uma turma");

      final novaEleicao = Eleicao(
        titulo: titulo,
        ano: ano,
        turmaId: turmaSelecionada!.id,
      );

      await _cadastrarEleicaoUseCase(
        novaEleicao,
        candidatosSelecionadosIds.toList(),
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
