import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:urna/features/admin/presentation/controllers/candidatos_controller.dart';
import 'package:urna/features/admin/presentation/widgets/candidato_card.dart';

class CandidatosPage extends HookConsumerWidget {
  const CandidatosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // O Riverpod escuta o provider. Se mudar, reconstrói.
    // 'candidatosAsync' contém: data, error ou loading.
    final candidatosAsync = ref.watch(candidatosListProvider);

    // Flutter Hooks para o controller de texto (descarta sozinho)
    final searchController = useTextEditingController();

    return Stack(
      children: [
        Column(
          children: [
            // --- BARRA DE BUSCA ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar Candidato...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  // Hooks: Podemos filtrar a lista localmente ou chamar o provider
                  onChanged: (value) {
                    // Implementação de filtro local seria feita aqui
                  },
                ),
              ),
            ),

            // --- GRID COM ASYNC VALUE ---
            Expanded(
              child: candidatosAsync.when(
                // 1. ESTADO DE LOADING
                loading: () => const Center(child: CircularProgressIndicator()),

                // 2. ESTADO DE ERRO
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      Text('Erro: $err'),
                      TextButton(
                        // Tentar novamente é apenas invalidar o provider
                        onPressed: () => ref.invalidate(candidatosListProvider),
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),

                // 3. ESTADO DE SUCESSO (DADOS)
                data: (candidatos) {
                  if (candidatos.isEmpty) {
                    return const Center(
                      child: Text("Nenhum candidato cadastrado."),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: candidatos.length,
                      itemBuilder: (context, index) {
                        final item = candidatos[index];
                        return CandidatoCard(
                          item: item,
                          onTap: () {
                            context.push('/candidatos/editar', extra: item);
                            // Não precisa .then(carregar), o Riverpod atualiza
                            // se a tela de edição chamar o provider de ação.
                          },
                          onDelete: () {
                            if (item.isAtivo) {
                              // FLUXO DE EXCLUSÃO (DESATIVAR)
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Desativar Candidato"),
                                  content: Text(
                                    "Deseja desativar o candidato ${item.nome}?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        await ref
                                            .read(
                                              candidatosActionsProvider
                                                  .notifier,
                                            )
                                            .deletar(item.id!);
                                      },
                                      child: const Text(
                                        "Desativar",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // FLUXO DE REATIVAÇÃO
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Reativar Candidato"),
                                  content: Text(
                                    "Deseja trazer ${item.nome} de volta à lista de ativos?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(ctx).pop();
                                        // Chama a nova ação de reativar
                                        await ref
                                            .read(
                                              candidatosActionsProvider
                                                  .notifier,
                                            )
                                            .reativar(item.id!);
                                      },
                                      child: const Text("Reativar"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // --- FAB ---
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () => context.push('/candidatos/novo'),
            backgroundColor: const Color(0xFFD32F2F),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
