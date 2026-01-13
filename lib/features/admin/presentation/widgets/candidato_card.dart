import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/entities/candidato.dart';

class CandidatoCard extends StatelessWidget {
  final Candidato item;
  final VoidCallback onTap;
  final VoidCallback onDelete; // <--- Callback novo

  const CandidatoCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete, // <--- Recebe no construtor
  });

  @override
  Widget build(BuildContext context) {
    final fotoPath = item.foto;
    final temFoto = fotoPath != null && fotoPath.isNotEmpty;

    // Status visual
    final statusColor = item.isAtivo ? Colors.green : Colors.red;
    final statusLabel = item.isAtivo ? "ATIVO" : "INATIVO";

    return Card(
      elevation: 2,
      color: item.isAtivo ? Colors.white : Colors.grey[100],
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
              // 1. Imagem e Badge
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                        image: temFoto
                            ? DecorationImage(
                                image: FileImage(File(fotoPath)),
                                fit: BoxFit.cover,
                                colorFilter: item.isAtivo
                                    ? null
                                    : const ColorFilter.mode(
                                        Colors.grey,
                                        BlendMode.saturation,
                                      ),
                              )
                            : null,
                      ),
                      child: !temFoto
                          ? Center(
                              child: Icon(
                                Icons.person,
                                size: 40.sp,
                                color: Colors.grey.shade400,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 7.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Nome
              Text(
                item.nome,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: item.isAtivo ? Colors.black87 : Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // 3. Info
              _InfoRow(
                icon: Icons.how_to_vote_outlined,
                text:
                    "${item.qtdParticipacoes} ${item.qtdParticipacoes > 1 ? "Participações" : "Participação"}",
                isDimmed: !item.isAtivo,
              ),

              _InfoRow(
                icon: Icons.how_to_vote_outlined,
                text:
                    "${item.qtdVitorias} ${item.qtdVitorias > 1 ? "Eleições vencidas 🏆" : "Eleição vencida 🏆"}",
                isDimmed: !item.isAtivo,
              ),

              const Divider(height: 16),

              // 4. Botão Deletar (Rodapé)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: item.isAtivo
                        ? "Desativar Candidato"
                        : "Reativar Candidato",
                    child: InkWell(
                      onTap:
                          onDelete, // O callback é o mesmo, a lógica muda na Page
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          // Muda o ícone visualmente
                          item.isAtivo
                              ? Icons.delete_outline
                              : Icons.restore_from_trash,
                          size: 20,
                          // Se estiver inativo (para reativar), usa cor verde para indicar ação positiva
                          color: Colors.grey.shade400,
                        ),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDimmed;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.isDimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDimmed ? Colors.grey.shade400 : Colors.grey.shade700;
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 9.sp, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
