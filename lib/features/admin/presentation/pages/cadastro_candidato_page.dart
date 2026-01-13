import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/presentation/controllers/candidatos_controller.dart';

class CadastroCandidatoPage extends HookConsumerWidget {
  const CadastroCandidatoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HOOKS: Gerenciam o ciclo de vida dos controllers automaticamente
    final nomeController = useTextEditingController();
    final fotoPath = useState<String?>(null); // Estado local da foto
    final isLoading = useState(false);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Função local para selecionar foto
    Future<void> selecionarFoto() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        fotoPath.value = result.files.single.path;
      }
    }

    // Função de Salvar
    Future<void> salvar() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        try {
          final novoCandidato = Candidato(
            nome: nomeController.text,
            foto: fotoPath.value,
          );

          // Chama o Provider de Ações criado no Passo 4
          await ref
              .read(candidatosActionsProvider.notifier)
              .cadastrar(novoCandidato);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Candidato salvo com sucesso!')),
            );
            context.pop();
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
            );
          }
        } finally {
          isLoading.value = false;
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Novo Candidato'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Container(
          width: 60.w,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- COLUNA FOTO ---
                      Column(
                        children: [
                          GestureDetector(
                            onTap: selecionarFoto,
                            child: Container(
                              width: 15.w,
                              height: 15.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                                image: fotoPath.value != null
                                    ? DecorationImage(
                                        image: FileImage(File(fotoPath.value!)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: fotoPath.value == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ),
                          if (fotoPath.value != null)
                            TextButton(
                              onPressed: selecionarFoto,
                              child: const Text("Alterar Foto"),
                            ),
                        ],
                      ),
                      SizedBox(width: 4.w),
                      // --- COLUNA CAMPOS ---
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: nomeController,
                              decoration: const InputDecoration(
                                labelText: 'Nome Completo',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Obrigatório' : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: salvar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD32F2F),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('SALVAR CANDIDATO'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
