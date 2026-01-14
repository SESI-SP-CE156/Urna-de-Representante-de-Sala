// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votacao_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VotacaoCandidatos)
final votacaoCandidatosProvider = VotacaoCandidatosFamily._();

final class VotacaoCandidatosProvider
    extends $AsyncNotifierProvider<VotacaoCandidatos, List<Candidato>> {
  VotacaoCandidatosProvider._({
    required VotacaoCandidatosFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'votacaoCandidatosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$votacaoCandidatosHash();

  @override
  String toString() {
    return r'votacaoCandidatosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VotacaoCandidatos create() => VotacaoCandidatos();

  @override
  bool operator ==(Object other) {
    return other is VotacaoCandidatosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$votacaoCandidatosHash() => r'9984e19666b6c6c078f8650af888c909a73d23ae';

final class VotacaoCandidatosFamily extends $Family
    with
        $ClassFamilyOverride<
          VotacaoCandidatos,
          AsyncValue<List<Candidato>>,
          List<Candidato>,
          FutureOr<List<Candidato>>,
          int
        > {
  VotacaoCandidatosFamily._()
    : super(
        retry: null,
        name: r'votacaoCandidatosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VotacaoCandidatosProvider call(int eleicaoId) =>
      VotacaoCandidatosProvider._(argument: eleicaoId, from: this);

  @override
  String toString() => r'votacaoCandidatosProvider';
}

abstract class _$VotacaoCandidatos extends $AsyncNotifier<List<Candidato>> {
  late final _$args = ref.$arg as int;
  int get eleicaoId => _$args;

  FutureOr<List<Candidato>> build(int eleicaoId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Candidato>>, List<Candidato>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Candidato>>, List<Candidato>>,
              AsyncValue<List<Candidato>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(VotacaoActions)
final votacaoActionsProvider = VotacaoActionsProvider._();

final class VotacaoActionsProvider
    extends $NotifierProvider<VotacaoActions, void> {
  VotacaoActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'votacaoActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$votacaoActionsHash();

  @$internal
  @override
  VotacaoActions create() => VotacaoActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$votacaoActionsHash() => r'd677930611170f80eb173f575138b4ea3946a1db';

abstract class _$VotacaoActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
