import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';

class MainLayoutShell extends StatelessWidget {
  final Widget child;

  const MainLayoutShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Row(
        children: [
          // --- SIDEBAR (Estilo SESI) ---
          Container(
            width: 250,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: Color(0xFFE0E0E0)),
              ), // Linha divisória
            ),
            child: Column(
              children: [
                // Logo Area
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Você pode usar o SVG do SESI aqui se tiver os assets
                      Icon(Icons.how_to_vote, size: 32, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'URNA',
                        style: GoogleFonts.oswald(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Navegação
                _buildMenuItem(
                  context,
                  label: 'Eleições',
                  icon: Icons.ballot_outlined,
                  selectedIcon: Icons.ballot,
                  isSelected: location == '/' || location.contains('/eleicoes'),
                  onTap: () => context.go('/'),
                ),
                _buildMenuItem(
                  context,
                  label: 'Candidatos',
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  isSelected: location.contains('/candidatos'),
                  onTap: () => context.go('/candidatos'),
                ),

                const Spacer(),
                const Divider(indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  label: 'Sair do Sistema',
                  icon: Icons.exit_to_app,
                  selectedIcon: Icons.exit_to_app,
                  isSelected: false,
                  isDestructive: true,
                  onTap: () => _confirmarSaida(context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // --- CONTEÚDO PRINCIPAL ---
          Expanded(
            child: Container(
              color: const Color(0xFFF3F3F3), // Fundo Cinza Claro
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sair"),
        content: const Text("Deseja realmente fechar a aplicação?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await windowManager.close();
            },
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    required bool isSelected,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? Colors.red
        : (isSelected ? theme.primaryColor : Colors.grey[700]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Fundo vermelho bem claro quando selecionado
            color: isSelected
                ? theme.primaryColor.withOpacity(0.08)
                : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(isSelected ? selectedIcon : icon, color: color, size: 22),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.openSans(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
