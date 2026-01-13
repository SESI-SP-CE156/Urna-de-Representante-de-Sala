import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/features/admin/data/repositories/candidato_repository.dart';
import 'package:urna/features/admin/domain/usecases/editar_candidato_usecase.dart';
import 'package:urna/features/admin/presentation/controllers/editar_candidato_controller.dart';

class EditarCandidatoPage extends StatefulWidget {
  final Candidato candidato; // Recebe o candidato para editar

  const EditarCandidatoPage({super.key, required this.candidato});

  @override
  State<EditarCandidatoPage> createState() => _EditarCandidatoPageState();
}

class _EditarCandidatoPageState extends State<EditarCandidatoPage> {
  late EditarCandidatoController _controller;
  late TextEditingController _nomeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Setup manual de dependências
    final dbHelper = DatabaseHelper.instance;
    final repo = CandidatoRepository(dbHelper);
    final useCase = EditarCandidatoUseCase(repo);

    _controller = EditarCandidatoController(useCase);
    _controller.init(widget.candidato); // Inicializa com os dados

    _nomeController = TextEditingController(text: widget.candidato.nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Editar Candidato'),
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
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              if (_controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- FOTO ---
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _controller.selecionarFoto,
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
                              image: _controller.caminhoFoto != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(_controller.caminhoFoto!),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _controller.caminhoFoto == null
                                ? const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                        ),
                        TextButton(
                          onPressed: _controller.selecionarFoto,
                          child: const Text("Alterar Foto"),
                        ),
                      ],
                    ),

                    SizedBox(width: 4.w),

                    // --- CAMPOS ---
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_controller.errorMessage != null)
                            Text(
                              _controller.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),

                          TextFormField(
                            controller: _nomeController,
                            decoration: const InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                          ),

                          const SizedBox(height: 24),

                          // STATUS SWITCH
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status do Candidato",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _controller.isAtivo ? "Ativo" : "Inativo",
                                      style: TextStyle(
                                        color: _controller.isAtivo
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: _controller.isAtivo,
                                      activeColor: Colors.green,
                                      onChanged: _controller.toggleStatus,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final ok = await _controller.salvarEdicao(
                                    _nomeController.text,
                                  );
                                  if (ok && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Atualizado!"),
                                      ),
                                    );
                                    context.pop();
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD32F2F),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text("SALVAR ALTERAÇÕES"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
