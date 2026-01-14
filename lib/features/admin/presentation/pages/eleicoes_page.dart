import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:urna/features/admin/presentation/controllers/eleicoes_controller.dart';
import 'package:urna/features/admin/presentation/widgets/eleicao_card.dart';

class EleicoesPage extends ConsumerWidget {
  const EleicoesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuta a lista de eleições (Loading / Data / Error)
    final eleicoesAsync = ref.watch(eleicoesListProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Eleições Cadastradas",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: eleicoesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text(
                      'Erro ao carregar: $err',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  data: (eleicoes) {
                    if (eleicoes.isEmpty) {
                      return const Center(
                        child: Text("Nenhuma eleição encontrada."),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            3, // Ajuste conforme a largura da tela se quiser responsivo
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: eleicoes.length,
                      itemBuilder: (context, index) {
                        final item = eleicoes[index];
                        return EleicaoCard(
                          item: item,
                          onTap: () async {
                            if (item.eleicao.isAberta) {
                              final result = await context.push<bool>(
                                '/votacao',
                                extra: item.eleicao,
                              );

                              if (result == true || result == null) {
                                ref.invalidate(eleicoesListProvider);
                              }
                            } else {
                              context.push(
                                '/eleicoes/detalhes',
                                extra: item.eleicao,
                              );
                            }
                          },
                          onDelete: () async {
                            // Chama a ação de deletar via Provider
                            await ref
                                .read(eleicoesActionsProvider.notifier)
                                .deletar(item.eleicao.id!);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // FAB
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () {
              context.push('/eleicoes/nova').then((_) {
                // Ao voltar do cadastro, recarrega a lista
                ref.invalidate(eleicoesListProvider);
              });
            },
            backgroundColor: const Color(0xFFD32F2F),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
