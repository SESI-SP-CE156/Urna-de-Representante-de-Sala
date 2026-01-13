// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(databaseHelper)
final databaseHelperProvider = DatabaseHelperProvider._();

final class DatabaseHelperProvider
    extends $FunctionalProvider<DatabaseHelper, DatabaseHelper, DatabaseHelper>
    with $Provider<DatabaseHelper> {
  DatabaseHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseHelperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHelperHash();

  @$internal
  @override
  $ProviderElement<DatabaseHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DatabaseHelper create(Ref ref) {
    return databaseHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatabaseHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatabaseHelper>(value),
    );
  }
}

String _$databaseHelperHash() => r'3c872a6be504a5942fbf7213cf260628ebc873ed';
