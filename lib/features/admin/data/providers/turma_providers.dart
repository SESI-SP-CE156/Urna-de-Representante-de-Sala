import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/data/repositories/turma_repository.dart';
import 'package:urna/core/providers/core_providers.dart';

part 'turma_providers.g.dart';

@riverpod
TurmaRepository turmaRepository(Ref ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return TurmaRepository(dbHelper);
}
