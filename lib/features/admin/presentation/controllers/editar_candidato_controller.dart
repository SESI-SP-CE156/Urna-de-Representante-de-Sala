import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/domain/usecases/editar_candidato_usecase.dart';

class EditarCandidatoController extends ChangeNotifier {
  final EditarCandidatoUseCase _editarCandidatoUseCase;

  EditarCandidatoController(this._editarCandidatoUseCase);

  bool isLoading = false;
  String? errorMessage;

  // Estado do Formulário
  late int _id;
  String? caminhoFoto;
  bool isAtivo = true;

  // Inicializa os dados com o candidato vindo da tela anterior
  void init(Candidato candidato) {
    _id = candidato.id!;
    caminhoFoto = candidato.foto;
    isAtivo = candidato.isAtivo;
    notifyListeners();
  }

  Future<void> selecionarFoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      caminhoFoto = result.files.single.path;
      notifyListeners();
    }
  }

  void toggleStatus(bool valor) {
    isAtivo = valor;
    notifyListeners();
  }

  Future<bool> salvarEdicao(String nome) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final candidatoEditado = Candidato(
        id: _id,
        nome: nome,
        foto: caminhoFoto,
        isAtivo: isAtivo,
      );

      await _editarCandidatoUseCase(candidatoEditado);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
