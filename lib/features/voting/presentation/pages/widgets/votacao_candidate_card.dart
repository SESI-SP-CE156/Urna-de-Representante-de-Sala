import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/entities/candidato.dart';

class VotacaoCandidateCard extends StatelessWidget {
  final Candidato candidato;
  final VoidCallback onTap;

  const VotacaoCandidateCard({
    super.key,
    required this.candidato,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fotoPath = candidato.foto;
    final temFoto = fotoPath != null && fotoPath.isNotEmpty;

    return Card(
      elevation: 4, // Elevação maior para parecer um botão clicável
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        // Efeito visual ao tocar (Feedback de clique)
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- ÁREA DA FOTO (Expandida) ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: temFoto
                        ? Image.file(
                            File(fotoPath),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholder();
                            },
                          )
                        : _buildPlaceholder(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // --- NOME E NÚMERO ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    Text(
                      candidato.nome.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp, // Fonte legível
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NÚMERO ${candidato.id}", // Simulando número da urna
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.person, size: 50.sp, color: Colors.grey.shade300),
    );
  }
}
