import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/core/entities/eleicao.dart';
import 'package:urna/core/entities/turma.dart';
import 'package:urna/core/model/candidato_model.dart';
import 'package:urna/core/model/eleicao_model.dart';
import 'package:urna/core/model/turma_model.dart';
import 'package:urna/features/admin/domain/entities/candidato_resultado.dart';

class EleicaoRepository {
  final DatabaseHelper databaseHelper;

  EleicaoRepository(this.databaseHelper);

  // --- LISTAGEM ---
  Future<List<EleicaoComTurma>> listarEleicoesComTurma() async {
    final db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT 
        E.*, 
        T.ID as TURMA_ID, T.SERIE, T.LETRA, T.NIVEL 
      FROM ELEICAO E
      INNER JOIN TURMA T ON E.FK_TURMA_ID = T.ID
      ORDER BY E.ID DESC 
    ''');

    List<EleicaoComTurma> listaFinal = [];

    for (var row in result) {
      final turma = TurmaModel.fromMap({
        'ID': row['TURMA_ID'],
        'SERIE': row['SERIE'],
        'LETRA': row['LETRA'],
        'NIVEL': row['NIVEL'],
      });

      final eleicao = EleicaoModel.fromMap(row);

      String? nomeVencedor;
      String? nomeSuplente;

      if (!eleicao.isAberta) {
        final ranking = await db.rawQuery(
          '''
          SELECT C.NOME, EC.QTD_VOTOS
          FROM ELEICAO_CANDIDATOS EC
          INNER JOIN CANDIDATOS C ON EC.FK_CANDIDATOS_ID = C.ID
          WHERE EC.FK_ELEICAO_ID = ?
          ORDER BY EC.QTD_VOTOS DESC
          LIMIT 2
        ''',
          [eleicao.id],
        );

        if (ranking.isNotEmpty) {
          nomeVencedor = ranking[0]['NOME'] as String;
        }
        if (ranking.length > 1) {
          nomeSuplente = ranking[1]['NOME'] as String;
        }
      }

      listaFinal.add(
        EleicaoComTurma(
          eleicao: eleicao,
          turma: turma,
          vencedor: nomeVencedor,
          suplente: nomeSuplente,
        ),
      );
    }

    return listaFinal;
  }

  // --- CRIAÇÃO ---
  Future<void> criarEleicao(Eleicao eleicao, List<int> candidatosIds) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      final eleicaoId = await txn.insert('ELEICAO', {
        'TITULO': eleicao.titulo,
        'ANO': eleicao.ano,
        'TOTAL_VOTOS': 0,
        'FK_TURMA_ID': eleicao.turmaId,
        'STATUS': 1,
      });

      for (final candidatoId in candidatosIds) {
        await txn.insert('ELEICAO_CANDIDATOS', {
          'FK_CANDIDATOS_ID': candidatoId,
          'FK_ELEICAO_ID': eleicaoId,
          'QTD_VOTOS': 0,
        });
      }
    });
  }

  // --- VOTAÇÃO ---
  Future<List<Candidato>> listarCandidatosDaEleicao(int eleicaoId) async {
    final db = await databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT C.* FROM CANDIDATOS C
      INNER JOIN ELEICAO_CANDIDATOS EC ON EC.FK_CANDIDATOS_ID = C.ID
      WHERE EC.FK_ELEICAO_ID = ?
    ''',
      [eleicaoId],
    );

    return result.map((row) => CandidatoModel.fromMap(row)).toList();
  }

  Future<void> registrarVoto(int eleicaoId, int candidatoId) async {
    final db = await databaseHelper.database;

    await db.transaction((txn) async {
      await txn.rawUpdate(
        '''
        UPDATE ELEICAO_CANDIDATOS 
        SET QTD_VOTOS = QTD_VOTOS + 1 
        WHERE FK_ELEICAO_ID = ? AND FK_CANDIDATOS_ID = ?
      ''',
        [eleicaoId, candidatoId],
      );

      await txn.rawUpdate(
        '''
        UPDATE ELEICAO 
        SET TOTAL_VOTOS = TOTAL_VOTOS + 1 
        WHERE ID = ?
      ''',
        [eleicaoId],
      );
    });
  }

  Future<void> finalizarEleicao(int eleicaoId) async {
    final db = await databaseHelper.database;
    await db.update(
      'ELEICAO',
      {'STATUS': 0},
      where: 'ID = ?',
      whereArgs: [eleicaoId],
    );
  }

  // --- RESULTADOS ---
  Future<List<CandidatoResultado>> listarResultados(int eleicaoId) async {
    final db = await databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT C.*, EC.QTD_VOTOS
      FROM CANDIDATOS C
      INNER JOIN ELEICAO_CANDIDATOS EC ON EC.FK_CANDIDATOS_ID = C.ID
      WHERE EC.FK_ELEICAO_ID = ?
      ORDER BY EC.QTD_VOTOS DESC
    ''',
      [eleicaoId],
    );

    return result.map((row) {
      final candidato = CandidatoModel.fromMap(row);
      final votos = row['QTD_VOTOS'] as int;
      return CandidatoResultado(candidato: candidato, votos: votos);
    }).toList();
  }

  // --- NOVO MÉTODO: DELETAR ---
  Future<void> deletarEleicao(int id) async {
    final db = await databaseHelper.database;
    // Remove a eleição. O SQLite deve remover os vínculos em cascata se configurado,
    // mas o delete direto resolve o principal.
    await db.delete('ELEICAO', where: 'ID = ?', whereArgs: [id]);
  }
}

// Classe Auxiliar (DTO)
class EleicaoComTurma {
  final Eleicao eleicao;
  final Turma turma;
  final String? vencedor;
  final String? suplente;

  EleicaoComTurma({
    required this.eleicao,
    required this.turma,
    this.vencedor,
    this.suplente,
  });
}
