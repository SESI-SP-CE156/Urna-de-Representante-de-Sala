import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/entities/eleicao.dart';
import 'package:urna/features/admin/domain/usecases/obter_resultado_eleicao_usecase.dart';
import 'package:urna/features/admin/presentation/controllers/eleicao_detalhes_controller.dart';

class EleicaoDetalhesPage extends StatefulWidget {
  final Eleicao eleicao;

  const EleicaoDetalhesPage({super.key, required this.eleicao});

  @override
  State<EleicaoDetalhesPage> createState() => _EleicaoDetalhesPageState();
}

class _EleicaoDetalhesPageState extends State<EleicaoDetalhesPage> {
  late EleicaoDetalhesController _controller;

  @override
  void initState() {
    super.initState();
    final dbHelper = DatabaseHelper.instance;
    final repo = EleicaoRepository(dbHelper);
    final useCase = ObterResultadoEleicaoUseCase(repo);
    _controller = EleicaoDetalhesController(useCase);

    _controller.carregarDados(widget.eleicao.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Resultados da Eleição'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.resultados.isEmpty) {
            return const Center(child: Text("Sem dados para exibir."));
          }

          // Encontra o maior número de votos para escalar o gráfico (Y-axis)
          final maxVotos = _controller.resultados.isNotEmpty
              ? _controller.resultados.first.votos.toDouble()
              : 10.0;

          // Margem superior do gráfico
          final maxY = maxVotos + (maxVotos * 0.2);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- CABEÇALHO ---
                _buildHeaderCard(),

                const SizedBox(height: 24),

                // --- GRÁFICO (FL_CHART) ---
                Container(
                  height: 40.h, // Altura responsiva
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gráfico de Votação",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxY == 0
                                ? 1
                                : maxY, // Evita crash se 0 votos
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (_) => Colors.blueGrey,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                      final nome = _controller
                                          .resultados[group.x.toInt()]
                                          .candidato
                                          .nome;
                                      return BarTooltipItem(
                                        '$nome\n',
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '${rod.toY.toInt()} votos',
                                            style: const TextStyle(
                                              color: Colors.yellow,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index >= 0 &&
                                        index < _controller.resultados.length) {
                                      // Pega apenas o primeiro nome para caber no gráfico
                                      final nome = _controller
                                          .resultados[index]
                                          .candidato
                                          .nome
                                          .split(' ')
                                          .first;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          nome,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                  reservedSize: 30,
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: _controller.resultados.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final item = entry.value;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: item.votos.toDouble(),
                                    color: index == 0
                                        ? Colors.green
                                        : Colors
                                              .blue, // Destaque para o vencedor
                                    width: 30,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                    backDrawRodData: BackgroundBarChartRodData(
                                      show: true,
                                      toY: maxY,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- LISTA DE CANDIDATOS ---
                const Text(
                  "Detalhamento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _controller.resultados.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _controller.resultados[index];
                    final isVencedor = index == 0 && item.votos > 0;

                    // --- CÁLCULO DA PORCENTAGEM ---
                    final double percentage = widget.eleicao.totalVotos > 0
                        ? (item.votos / widget.eleicao.totalVotos) * 100
                        : 0.0;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: isVencedor
                            ? Border.all(
                                color: Colors.green.withOpacity(0.5),
                                width: 2,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Foto
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: (item.candidato.foto != null)
                                ? FileImage(File(item.candidato.foto!))
                                : null,
                            child: item.candidato.foto == null
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 16),

                          // Nome e Posição
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.candidato.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isVencedor)
                                  const Text(
                                    "Vencedor(a) 🏆",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                else if (index == 1 && item.votos > 0)
                                  const Text(
                                    "Suplente",
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // --- COLUNA DE VOTOS E PORCENTAGEM ---
                          SizedBox(
                            width: 110, // Largura fixa para alinhar
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${item.votos} votos",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                // Exibe a porcentagem
                                Text(
                                  "${percentage.toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: widget.eleicao.totalVotos > 0
                                      ? item.votos / widget.eleicao.totalVotos
                                      : 0,
                                  backgroundColor: Colors.grey[100],
                                  color: isVencedor
                                      ? Colors.green
                                      : Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[800]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.eleicao.titulo.isNotEmpty
                    ? widget.eleicao.titulo
                    : "Eleição ${widget.eleicao.ano}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.eleicao.isAberta ? "Em Andamento" : "Finalizada",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                "Total de Votos",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "${widget.eleicao.totalVotos}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
