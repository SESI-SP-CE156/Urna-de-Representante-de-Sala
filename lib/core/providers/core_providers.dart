import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/database/db_helper.dart';

part 'core_providers.g.dart';

// O keepAlive: true mantém a instância do banco viva por toda a vida do app
@Riverpod(keepAlive: true)
DatabaseHelper databaseHelper(Ref ref) {
  return DatabaseHelper.instance;
}
