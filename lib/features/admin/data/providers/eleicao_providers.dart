import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:urna/core/data/repositories/eleicao_repository.dart';
import 'package:urna/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'eleicao_providers.g.dart';

@riverpod
EleicaoRepository eleicaoRepository(Ref ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return EleicaoRepository(dbHelper);
}
