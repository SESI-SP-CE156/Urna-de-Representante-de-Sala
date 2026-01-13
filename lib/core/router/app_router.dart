import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/core/entities/eleicao.dart';
import 'package:urna/features/admin/presentation/pages/cadastrar_eleicao_page.dart';
import 'package:urna/features/admin/presentation/pages/cadastro_candidato_page.dart';
import 'package:urna/features/admin/presentation/pages/candidatos_page.dart';
import 'package:urna/features/admin/presentation/pages/editar_candidato_page.dart';
import 'package:urna/features/admin/presentation/pages/eleicao_detalhes_page.dart';
import 'package:urna/features/voting/presentation/pages/votacao_page.dart';

import '../../core/ui/layout/main_layout_shell.dart';
import '../../features/admin/presentation/pages/eleicoes_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // SHELL ROUTE: Define o layout fixo (Menu Lateral)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayoutShell(child: child);
        },
        routes: [
          // Todas as rotas aqui dentro herdam o Menu Lateral
          GoRoute(path: '/', builder: (context, state) => const EleicoesPage()),
          GoRoute(
            path: '/candidatos',
            builder: (context, state) => const CandidatosPage(),
          ),
          GoRoute(
            path: '/candidatos/novo',
            builder: (context, state) => const CadastroCandidatoPage(),
          ),
          GoRoute(
            path: '/candidatos/editar',
            builder: (context, state) {
              // Passamos o objeto candidato via 'extra'
              final candidato = state.extra as Candidato;
              return EditarCandidatoPage(candidato: candidato);
            },
          ),
          GoRoute(
            path:
                '/eleicoes/nova', // Esta é a rota que chamamos no FAB da tela de listagem
            builder: (context, state) => const CadastrarEleicaoPage(),
          ),
          GoRoute(
            path: '/votacao',
            builder: (context, state) {
              final eleicao = state.extra as Eleicao;
              return VotacaoPage(eleicao: eleicao);
            },
          ),
          GoRoute(
            path: '/eleicoes/detalhes',
            builder: (context, state) {
              final eleicao = state.extra as Eleicao;
              return EleicaoDetalhesPage(eleicao: eleicao);
            },
          ),
        ],
      ),
    ],
  );
}
