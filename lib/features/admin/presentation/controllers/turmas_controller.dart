import 'package:flutter/material.dart';
import 'package:urna/core/entities/turma.dart';
import 'package:urna/features/admin/domain/usecases/cadastrar_turma_usecase.dart';
import 'package:urna/features/admin/domain/usecases/deletar_turma_usecase.dart';
import 'package:urna/features/admin/domain/usecases/listar_turmas_usecase.dart';

class TurmasController extends ChangeNotifier {
  // Dependências (UseCases)
  final ListarTurmasUseCase _listarTurmasUseCase;
  final CadastrarTurmaUseCase _cadastrarTurmaUseCase;
  final DeletarTurmaUseCase _deletarTurmaUseCase;

  // Estado
  List<Turma> _turmas = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters para a View acessar o estado de forma segura (leitura)
  List<Turma> get turmas => _turmas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Construtor com Injeção de Dependências
  TurmasController(
    this._listarTurmasUseCase,
    this._cadastrarTurmaUseCase,
    this._deletarTurmaUseCase,
  );

  // Método para carregar a lista inicial
  Future<void> carregarTurmas() async {
    _setLoading(true);
    _clearError();

    try {
      _turmas = await _listarTurmasUseCase();
    } catch (e) {
      _errorMessage = 'Erro ao carregar turmas: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Método para salvar (criar ou atualizar)
  Future<bool> salvarTurma(Turma turma) async {
    _setLoading(true);
    _clearError();

    try {
      await _cadastrarTurmaUseCase(turma);
      // Recarrega a lista para refletir a mudança
      await carregarTurmas();
      return true; // Sucesso
    } catch (e) {
      _errorMessage = e
          .toString(); // Pega a mensagem do UseCase (ex: "Série deve ser > 0")
      _setLoading(false);
      return false; // Falha
    }
  }

  // Método para deletar
  Future<void> deletarTurma(int id) async {
    _setLoading(true);
    _clearError();

    try {
      await _deletarTurmaUseCase(id);
      await carregarTurmas();
    } catch (e) {
      _errorMessage = 'Erro ao deletar turma: $e';
      _setLoading(false);
    }
  }

  // Helpers privados para atualizar o estado e notificar a UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    // Não precisa de notifyListeners aqui pois geralmente é chamado junto com setLoading
  }
}
