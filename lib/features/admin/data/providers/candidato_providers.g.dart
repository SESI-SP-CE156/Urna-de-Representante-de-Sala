// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidato_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(candidatoRepository)
final candidatoRepositoryProvider = CandidatoRepositoryProvider._();

final class CandidatoRepositoryProvider
    extends
        $FunctionalProvider<
          CandidatoRepository,
          CandidatoRepository,
          CandidatoRepository
        >
    with $Provider<CandidatoRepository> {
  CandidatoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'candidatoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$candidatoRepositoryHash();

  @$internal
  @override
  $ProviderElement<CandidatoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CandidatoRepository create(Ref ref) {
    return candidatoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CandidatoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CandidatoRepository>(value),
    );
  }
}

String _$candidatoRepositoryHash() =>
    r'3267b654308e37690f091738dd0f4930af651629';
