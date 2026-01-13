import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/core/entities/turma.dart';
import 'package:urna/features/admin/domain/usecases/cadastrar_candidato_usecase.dart';

class CadastroCandidatoController extends ChangeNotifier {
  final CadastrarCandidatoUseCase _cadastrarCandidatoUseCase;

  CadastroCandidatoController(this._cadastrarCandidatoUseCase);

  // Estado
  bool isLoading = false;
  String? errorMessage;

  // Dados do Form
  List<Turma> turmasDisponiveis = [];
  Turma? turmaSelecionada;
  String? caminhoFoto;

  Future<void> selecionarFoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      caminhoFoto = result.files.single.path;
      notifyListeners();
    }
  }

  Future<bool> salvarCandidato(String nome) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final candidato = Candidato(nome: nome, foto: caminhoFoto);

      await _cadastrarCandidatoUseCase(candidato);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
