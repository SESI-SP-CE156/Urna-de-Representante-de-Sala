// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turma_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(turmaRepository)
final turmaRepositoryProvider = TurmaRepositoryProvider._();

final class TurmaRepositoryProvider
    extends
        $FunctionalProvider<TurmaRepository, TurmaRepository, TurmaRepository>
    with $Provider<TurmaRepository> {
  TurmaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'turmaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$turmaRepositoryHash();

  @$internal
  @override
  $ProviderElement<TurmaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TurmaRepository create(Ref ref) {
    return turmaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TurmaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TurmaRepository>(value),
    );
  }
}

String _$turmaRepositoryHash() => r'6bdd6827cc9625073a7226cf312e42c572b89d4a';
