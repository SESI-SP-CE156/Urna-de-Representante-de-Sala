import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/database/db_helper.dart';
import 'package:urna/core/providers/core_providers.dart';
import 'package:urna/features/admin/data/repositories/candidato_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


part 'candidato_providers.g.dart';

@riverpod
CandidatoRepository candidatoRepository(Ref ref) {
  // O Riverpod gerencia a dependência do DatabaseHelper automaticamente
  final dbHelper = ref.watch(databaseHelperProvider);
  return CandidatoRepository(dbHelper);
}
