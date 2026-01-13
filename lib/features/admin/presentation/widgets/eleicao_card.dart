import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';

class EleicaoCard extends StatelessWidget {
  final EleicaoComTurma item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const EleicaoCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Lógica de Status e Dados
    final bool isFinalizada = !item.eleicao.isAberta;
    final primaryColor = Theme.of(context).primaryColor;

    // Tratamento de textos
    final String nomeVencedor = isFinalizada
        ? (item.vencedor ?? "Empate/Sem Votos")
        : "Aguardando término...";

    final String nomeSuplente = isFinalizada ? (item.suplente ?? "-") : "-";

    return Card(
      elevation: 2,
      // Borda e sombra estilo "Corretor"
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Área Visual (Thumbnail com Ícone + Badge Status)
              Expanded(
                child: Stack(
                  children: [
                    // Fundo Cinza com Ícone
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.how_to_vote_outlined, // Ícone da Urna
                          color: isFinalizada
                              ? Colors.grey.shade400
                              : primaryColor.withOpacity(0.5),
                          size: 32.sp,
                        ),
                      ),
                    ),

                    // Badge de Status (Canto Inferior Direito)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isFinalizada ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isFinalizada
                                  ? Icons.check_circle
                                  : Icons.play_circle_fill,
                              color: Colors.white,
                              size: 10.sp,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isFinalizada ? "FINALIZADA" : "ABERTA",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Título da Eleição
              Text(
                item.eleicao.titulo.isNotEmpty
                    ? item.eleicao.titulo
                    : 'Eleição ${item.eleicao.ano}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // 3. Turma (Em destaque com a cor primária, igual ao card de Correção)
              Text(
                item.turma.descricaoCompleta.toUpperCase(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // 4. Detalhes (Vencedor, Suplente, Votos)
              // Usando o widget auxiliar _InfoRow para manter o padrão visual
              _InfoRow(
                icon: Icons.emoji_events_outlined,
                text: "1º: $nomeVencedor",
                highlight: isFinalizada, // Destaca se tiver vencedor
              ),
              const SizedBox(height: 2),
              _InfoRow(icon: Icons.person_outline, text: "2º: $nomeSuplente"),
              const SizedBox(height: 2),
              _InfoRow(
                icon: Icons.bar_chart,
                text: "${item.eleicao.totalVotos} Votos computados",
              ),

              const Divider(height: 16),

              // 5. Rodapé (Botão Excluir)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18, // Tamanho discreto igual ao do Corretor
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Auxiliar para linhas de informação (Estilo Corretor)
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 12,
          color: highlight ? Colors.amber.shade700 : Colors.grey.shade500,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 9.sp,
              color: highlight ? Colors.black87 : Colors.grey.shade700,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
