import 'dart:io'; // Necessário para File e operações de arquivo

import 'package:path/path.dart'; // Necessário para manipular extensões e caminhos
import 'package:path_provider/path_provider.dart'; // Necessário para getApplicationSupportDirectory
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/entities/candidato.dart';
import 'package:urna/core/model/candidato_model.dart';

class CandidatoRepository {
  final DatabaseHelper databaseHelper;

  CandidatoRepository(this.databaseHelper);

  Future<void> cadastrarCandidato(Candidato candidato) async {
    final db = await databaseHelper.database;

    // 1. Inserimos primeiro apenas com o Nome para obter o ID gerado (Auto Increment)
    final modelInicial = CandidatoModel(
      id: null,
      nome: candidato.nome,
      foto: null, // Ainda não salvamos a foto definitiva
      isAtivo: true,
    );

    // O método insert retorna o ID da linha criada
    int novoId = await db.insert('CANDIDATOS', modelInicial.toMap());

    // 2. Se houver uma foto selecionada pelo usuário, fazemos a cópia e o update
    if (candidato.foto != null && candidato.foto!.isNotEmpty) {
      try {
        final sourceFile = File(candidato.foto!);

        if (await sourceFile.exists()) {
          // Pega o diretório de dados da aplicação
          final appSupportDir = await getApplicationSupportDirectory();

          // Garante que o diretório existe
          if (!await appSupportDir.exists()) {
            await appSupportDir.create(recursive: true);
          }

          // Pega a extensão original do arquivo (ex: .jpg, .png)
          final fileExtension = extension(sourceFile.path);

          // Define o novo nome: candidato-<ID>.<extensão>
          final novoNome = 'candidato-$novoId$fileExtension';
          final destinoPath = join(appSupportDir.path, novoNome);

          // Copia o arquivo para o diretório seguro da app
          await sourceFile.copy(destinoPath);

          // 3. Atualiza o registro no banco com o caminho definitivo
          await db.update(
            'CANDIDATOS',
            {'FOTO': destinoPath},
            where: 'ID = ?',
            whereArgs: [novoId],
          );
        }
      } catch (e) {
        print('Erro ao salvar foto do candidato: $e');
        // Opcional: Decidir se lança erro ou apenas deixa sem foto
      }
    }
  }

  Future<void> atualizarCandidato(Candidato candidato) async {
    final db = await databaseHelper.database;

    String? caminhoFotoFinal = candidato.foto;

    // Se a foto mudou (verificamos se o caminho não contém "candidato-ID", indicando que é um arquivo novo temp)
    // Ou simplesmente copiamos se o arquivo existir e não for o mesmo destino.
    if (candidato.foto != null && File(candidato.foto!).existsSync()) {
      final file = File(candidato.foto!);
      final appDir = await getApplicationSupportDirectory();

      // Verifica se o arquivo já está na pasta certa (se não mudou a foto)
      if (!dirname(candidato.foto!).contains(appDir.path)) {
        // É uma foto nova escolhida da galeria, precisamos copiar
        final ext = extension(candidato.foto!);
        final novoNome = 'candidato-${candidato.id}$ext';
        final destino = join(appDir.path, novoNome);

        // Remove foto antiga se existir (opcional, mas boa prática)
        // await File(destino).delete();

        await file.copy(destino);
        caminhoFotoFinal = destino;
      }
    }

    final model = CandidatoModel(
      id: candidato.id,
      nome: candidato.nome,
      foto: caminhoFotoFinal,
      isAtivo: candidato.isAtivo,
    );

    await db.update(
      'CANDIDATOS',
      model.toMap(),
      where: 'ID = ?',
      whereArgs: [candidato.id],
    );
  }

  Future<List<Candidato>> listarCandidatos() async {
    final db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT 
        C.*,
        (SELECT COUNT(*) FROM ELEICAO_CANDIDATOS EC WHERE EC.FK_CANDIDATOS_ID = C.ID) as QTD_PARTICIPACOES
      FROM CANDIDATOS C
      ORDER BY C.NOME
    ''');

    List<CandidatoModel> lista = [];

    for (var row in result) {
      // Cálculo de vitórias "on-the-fly" (Pode ser otimizado futuramente)
      final candidatoId = row['ID'] as int;

      // Busca eleições onde este candidato participou e que estão finalizadas
      final eleicoesParticipadas = await db.rawQuery(
        '''
        SELECT EC.FK_ELEICAO_ID, EC.QTD_VOTOS
        FROM ELEICAO_CANDIDATOS EC
        INNER JOIN ELEICAO E ON EC.FK_ELEICAO_ID = E.ID
        WHERE EC.FK_CANDIDATOS_ID = ? AND E.STATUS = 0
      ''',
        [candidatoId],
      );

      int vitorias = 0;

      for (var ep in eleicoesParticipadas) {
        final eleicaoId = ep['FK_ELEICAO_ID'] as int;
        final meusVotos = ep['QTD_VOTOS'] as int;

        // Verifica se alguém teve mais votos nessa eleição
        final maxVotosResult = await db.rawQuery(
          '''
          SELECT MAX(QTD_VOTOS) as MAX_VOTOS 
          FROM ELEICAO_CANDIDATOS 
          WHERE FK_ELEICAO_ID = ?
        ''',
          [eleicaoId],
        );

        final maxVotos = maxVotosResult.first['MAX_VOTOS'] as int? ?? 0;

        if (meusVotos > 0 && meusVotos == maxVotos) {
          vitorias++;
        }
      }

      // Cria um mapa mutável para injetar a contagem
      final mapCompleto = Map<String, dynamic>.from(row);
      mapCompleto['QTD_VITORIAS'] = vitorias;

      lista.add(CandidatoModel.fromMap(mapCompleto));
    }

    return lista;
  }

  Future<void> deletarCandidato(int id) async {
    final db = await databaseHelper.database;

    // Soft Delete: Atualiza o STATUS para 0 (Inativo) em vez de apagar o registro.
    // Isso evita o erro de "Foreign Key" pois o histórico é mantido.
    await db.update(
      'CANDIDATOS',
      {'STATUS': 0},
      where: 'ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> reativarCandidato(int id) async {
    final db = await databaseHelper.database;
    await db.update(
      'CANDIDATOS',
      {'STATUS': 1}, // Volta para ativo
      where: 'ID = ?',
      whereArgs: [id],
    );
  }
}
