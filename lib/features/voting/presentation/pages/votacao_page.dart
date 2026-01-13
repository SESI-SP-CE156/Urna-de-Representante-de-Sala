import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/entities/eleicao.dart';
import 'package:urna/features/voting/presentation/controllers/votacao_controller.dart';
import 'package:urna/features/voting/presentation/pages/widgets/votacao_candidate_card.dart';

class VotacaoPage extends StatefulWidget {
  final Eleicao eleicao;

  const VotacaoPage({super.key, required this.eleicao});

  @override
  State<VotacaoPage> createState() => _VotacaoPageState();
}

class _VotacaoPageState extends State<VotacaoPage> {
  late VotacaoController _controller;

  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper.instance;
    final repo = EleicaoRepository(dbHelper);
    _controller = VotacaoController(repo);
    _controller.iniciarVotacao(widget.eleicao);
  }

  // 1. Lógica do Diálogo de Feedback com Timer
  void _mostrarFeedbackVoto() {
    showDialog(
      context: context,
      barrierDismissible: false, // Impede fechar clicando fora
      builder: (ctx) {
        return _FeedbackDialog(
          onNext: () {
            Navigator.of(ctx).pop(); // Fecha o diálogo
          },
        );
      },
    );
  }

  // Lógica para finalizar a votação (chamada pelo FAB)
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
              await _controller.finalizarVotacao();
              if (mounted) {
                // Força a volta para a Home recarregando tudo
                context.go('/');
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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text("Votação: ${widget.eleicao.titulo}"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      // 2. Botão Flutuante para Finalizar Votação
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _finalizarVotacao,
        label: const Text(
          "FINALIZAR VOTAÇÃO",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.stop_circle_outlined, color: Colors.white),
        backgroundColor: Colors.red[800],
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.candidatos.isEmpty) {
            return const Center(child: Text("Nenhum candidato nesta eleição."));
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "Toque na foto para votar",
                  style: TextStyle(fontSize: 8.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 3.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 32,
                          mainAxisSpacing: 32,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _controller.candidatos.length,
                    itemBuilder: (context, index) {
                      final candidato = _controller.candidatos[index];

                      return VotacaoCandidateCard(
                        candidato: candidato,
                        onTap: () async {
                          await _controller.votar(candidato.id!);
                          _mostrarFeedbackVoto();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- WIDGET AUXILIAR DO DIÁLOGO COM TIMER ---
class _FeedbackDialog extends StatefulWidget {
  final VoidCallback onNext;

  const _FeedbackDialog({required this.onNext});

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  int _seconds = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds--;
        });
      }
      if (_seconds <= 0) {
        timer.cancel();
        widget.onNext(); // Fecha o diálogo automaticamente
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
      title: const Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60),
          SizedBox(height: 16),
          Text(
            "Voto Computado!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("O seu voto foi registrado com sucesso."),
          const SizedBox(height: 24),
          Text(
            "Próximo voto em $_seconds...",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "REALIZAR OUTRO VOTO AGORA",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
