// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleicao_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eleicaoRepository)
final eleicaoRepositoryProvider = EleicaoRepositoryProvider._();

final class EleicaoRepositoryProvider
    extends
        $FunctionalProvider<
          EleicaoRepository,
          EleicaoRepository,
          EleicaoRepository
        >
    with $Provider<EleicaoRepository> {
  EleicaoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eleicaoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eleicaoRepositoryHash();

  @$internal
  @override
  $ProviderElement<EleicaoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EleicaoRepository create(Ref ref) {
    return eleicaoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EleicaoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EleicaoRepository>(value),
    );
  }
}

String _$eleicaoRepositoryHash() => r'716125ddfebafa9350fe16e50fd42a4cc82ed6ee';
