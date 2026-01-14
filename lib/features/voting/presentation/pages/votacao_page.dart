import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/entities/eleicao.dart';
import 'package:urna/features/voting/presentation/controllers/votacao_controller.dart';
import 'package:urna/features/voting/presentation/pages/widgets/votacao_candidate_card.dart';

class VotacaoPage extends ConsumerStatefulWidget {
  final Eleicao eleicao;

  const VotacaoPage({super.key, required this.eleicao});

  @override
  ConsumerState<VotacaoPage> createState() => _VotacaoPageState();
}

class _VotacaoPageState extends ConsumerState<VotacaoPage> {
  // Lógica do Diálogo de Feedback com Timer
  void _mostrarFeedbackVoto() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return _FeedbackDialog(
          onNext: () {
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  void _finalizarVotacao() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Encerrar Votação"),
        content: const Text(
          "Tem certeza que deseja finalizar esta eleição? Não será possível receber mais votos.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Fecha o alerta

              // 1. Chama o provider para finalizar no banco
              await ref
                  .read(votacaoActionsProvider.notifier)
                  .finalizar(widget.eleicao.id!);

              if (mounted) {
                // 2. Retorna 'true' para indicar que houve alteração de status
                context.pop(true);
              }
            },
            child: const Text(
              "FINALIZAR",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o provider de candidatos passando o ID da família
    final candidatosAsync = ref.watch(
      votacaoCandidatosProvider(widget.eleicao.id!),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text("Votação: ${widget.eleicao.titulo}"),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Remove botão de voltar padrão para evitar saída acidental
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _finalizarVotacao,
        label: const Text(
          "FINALIZAR VOTAÇÃO",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Toque na foto para votar",
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 3.h),

            Expanded(
              child: candidatosAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text("Erro: $err")),
                data: (candidatos) {
                  if (candidatos.isEmpty) {
                    return const Center(
                      child: Text("Nenhum candidato nesta eleição."),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 32,
                          mainAxisSpacing: 32,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: candidatos.length,
                    itemBuilder: (context, index) {
                      final candidato = candidatos[index];

                      return VotacaoCandidateCard(
                        candidato: candidato,
                        onTap: () async {
                          // Registra o voto via provider
                          await ref
                              .read(votacaoActionsProvider.notifier)
                              .votar(widget.eleicao.id!, candidato.id!);

                          _mostrarFeedbackVoto();
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
    );
  }
}

// Widget Auxiliar (FeedbackDialog) mantido igual, apenas convertido para StatefulWidget simples se necessário
// ou mantido como estava no seu código anterior.
class _FeedbackDialog extends StatefulWidget {
  final VoidCallback onNext;
  const _FeedbackDialog({required this.onNext});
  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  int _seconds = 3; // Reduzi para 3s para ser mais ágil
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _seconds--);
      }
      if (_seconds <= 0) {
        timer.cancel();
        widget.onNext();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          const Text(
            "Voto Computado!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            "Próximo eleitor em $_seconds...",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onNext,
            child: const Text("PROSSEGUIR"),
          ),
        ),
      ],
    );
  }
}
