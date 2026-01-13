// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidatos_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CandidatosList)
final candidatosListProvider = CandidatosListProvider._();

final class CandidatosListProvider
    extends $AsyncNotifierProvider<CandidatosList, List<Candidato>> {
  CandidatosListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'candidatosListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$candidatosListHash();

  @$internal
  @override
  CandidatosList create() => CandidatosList();
}

String _$candidatosListHash() => r'3f65e3faaac3c32ba8c8319811c59e3cd2812166';

abstract class _$CandidatosList extends $AsyncNotifier<List<Candidato>> {
  FutureOr<List<Candidato>> build();
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
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CandidatosActions)
final candidatosActionsProvider = CandidatosActionsProvider._();

final class CandidatosActionsProvider
    extends $NotifierProvider<CandidatosActions, void> {
  CandidatosActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'candidatosActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$candidatosActionsHash();

  @$internal
  @override
  CandidatosActions create() => CandidatosActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$candidatosActionsHash() => r'1cb24101972a2229f360432b9083c492add509ce';

abstract class _$CandidatosActions extends $Notifier<void> {
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
