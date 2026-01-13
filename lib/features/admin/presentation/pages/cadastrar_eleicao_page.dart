import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/data/repositories/turma_repository.dart';
import 'package:urna/core/entities/turma.dart';
import 'package:urna/features/admin/data/repositories/candidato_repository.dart';
import 'package:urna/features/admin/domain/usecases/cadastrar_eleicao_usecase.dart';
import 'package:urna/features/admin/domain/usecases/listar_candidatos_usecase.dart';
import 'package:urna/features/admin/domain/usecases/listar_turmas_usecase.dart';
import 'package:urna/features/admin/presentation/controllers/cadastrar_eleicao_controller.dart';

class CadastrarEleicaoPage extends StatefulWidget {
  const CadastrarEleicaoPage({super.key});

  @override
  State<CadastrarEleicaoPage> createState() => _CadastrarEleicaoPageState();
}

class _CadastrarEleicaoPageState extends State<CadastrarEleicaoPage> {
  late CadastrarEleicaoController _controller;
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _anoController = TextEditingController(
    text: DateTime.now().year.toString(),
  );

  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper.instance;

    // Repositórios
    final eleicaoRepo = EleicaoRepository(dbHelper);
    final turmaRepo = TurmaRepository(dbHelper);
    final candidatoRepo = CandidatoRepository(dbHelper);

    // UseCases
    _controller = CadastrarEleicaoController(
      CadastrarEleicaoUseCase(eleicaoRepo),
      ListarTurmasUseCase(turmaRepo),
      ListarCandidatosUseCase(candidatoRepo),
    );

    _controller.carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Nova Eleição'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Container(
          width: 70.w, // Um pouco mais largo para caber a lista de candidatos
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
              if (_controller.isLoading && _controller.turmas.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_controller.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _controller.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // --- LINHA 1: Título e Ano ---
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _tituloController,
                            decoration: const InputDecoration(
                              labelText:
                                  'Nome da Eleição (Ex: Representante 2024)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _anoController,
                            decoration: const InputDecoration(
                              labelText: 'Ano',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Inválido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- LINHA 2: Turma ---
                    DropdownButtonFormField<Turma>(
                      decoration: const InputDecoration(
                        labelText: 'Turma Votante',
                        border: OutlineInputBorder(),
                      ),
                      value: _controller.turmaSelecionada,
                      items: _controller.turmas.map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text(t.descricaoCompleta),
                        );
                      }).toList(),
                      onChanged: (val) => _controller.turmaSelecionada = val,
                      validator: (v) => v == null ? 'Selecione a turma' : null,
                    ),
                    const SizedBox(height: 24),

                    // --- SELEÇÃO DE CANDIDATOS ---
                    const Text(
                      "Selecione os Candidatos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _controller.candidatosDisponiveis.isEmpty
                            ? const Center(
                                child: Text(
                                  "Nenhum candidato ativo encontrado.",
                                ),
                              )
                            : ListView.separated(
                                itemCount:
                                    _controller.candidatosDisponiveis.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final candidato =
                                      _controller.candidatosDisponiveis[index];
                                  final isSelected = _controller
                                      .candidatosSelecionadosIds
                                      .contains(candidato.id);

                                  return CheckboxListTile(
                                    value: isSelected,
                                    onChanged: (val) {
                                      _controller.toggleCandidato(
                                        candidato.id!,
                                      );
                                    },
                                    title: Text(
                                      candidato.nome,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    secondary: CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: (candidato.foto != null)
                                          ? FileImage(File(candidato.foto!))
                                          : null,
                                      child: (candidato.foto == null)
                                          ? const Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                    activeColor: const Color(0xFFD32F2F),
                                  );
                                },
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- BOTÃO SALVAR ---
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final ok = await _controller.salvarEleicao(
                              _tituloController.text,
                              _anoController.text,
                            );
                            if (ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Eleição criada com sucesso!"),
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
                        child: _controller.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("CRIAR ELEIÇÃO"),
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
