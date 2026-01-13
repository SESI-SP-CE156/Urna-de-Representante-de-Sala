// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleicoes_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EleicoesList)
final eleicoesListProvider = EleicoesListProvider._();

final class EleicoesListProvider
    extends $AsyncNotifierProvider<EleicoesList, List<EleicaoComTurma>> {
  EleicoesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eleicoesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eleicoesListHash();

  @$internal
  @override
  EleicoesList create() => EleicoesList();
}

String _$eleicoesListHash() => r'01cbc67429da3ab7f0e44766d4fcec14cc7dfc0d';

abstract class _$EleicoesList extends $AsyncNotifier<List<EleicaoComTurma>> {
  FutureOr<List<EleicaoComTurma>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<EleicaoComTurma>>, List<EleicaoComTurma>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<EleicaoComTurma>>,
                List<EleicaoComTurma>
              >,
              AsyncValue<List<EleicaoComTurma>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(EleicoesActions)
final eleicoesActionsProvider = EleicoesActionsProvider._();

final class EleicoesActionsProvider
    extends $NotifierProvider<EleicoesActions, void> {
  EleicoesActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eleicoesActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eleicoesActionsHash();

  @$internal
  @override
  EleicoesActions create() => EleicoesActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$eleicoesActionsHash() => r'0b9fa7043aebebd630ce094578cc3236bc5cb706';

abstract class _$EleicoesActions extends $Notifier<void> {
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
