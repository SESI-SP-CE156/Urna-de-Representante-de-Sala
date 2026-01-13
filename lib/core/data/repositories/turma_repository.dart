import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/domain/repositories/i_turma_repository.dart';
import 'package:urna/core/entities/turma.dart';
import 'package:urna/core/model/turma_model.dart';

class TurmaRepository implements ITurmaRepository {
  final DatabaseHelper databaseHelper;

  // Injeção de Dependência via construtor
  TurmaRepository(this.databaseHelper);

  @override
  Future<int> criarTurma(Turma turma) async {
    final db = await databaseHelper.database;
    // Usamos o Model para converter a Entidade para Map
    final model = TurmaModel.fromEntity(turma);
    return await db.insert('TURMA', model.toMap());
  }

  @override
  Future<List<Turma>> listarTurmas() async {
    final db = await databaseHelper.database;
    final result = await db.query('TURMA');

    // Converte a lista de Maps do banco para uma lista de Entidades
    return result.map((map) => TurmaModel.fromMap(map)).toList();
  }

  @override
  Future<void> atualizarTurma(Turma turma) async {
    final db = await databaseHelper.database;
    final model = TurmaModel.fromEntity(turma);

    await db.update(
      'TURMA',
      model.toMap(),
      where: 'ID = ?',
      whereArgs: [turma.id],
    );
  }

  @override
  Future<void> deletarTurma(int id) async {
    final db = await databaseHelper.database;
    await db.delete('TURMA', where: 'ID = ?', whereArgs: [id]);
  }
}
