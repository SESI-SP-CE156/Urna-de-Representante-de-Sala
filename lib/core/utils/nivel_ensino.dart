enum NivelEnsino {
  fundamental('Ensino Fundamental'),
  medio('Ensino Médio');

  final String label;
  const NivelEnsino(this.label);

  // Helper para converter String do banco para Enum
  static NivelEnsino fromString(String label) {
    return NivelEnsino.values.firstWhere(
      (e) => e.label == label,
      orElse: () => NivelEnsino.fundamental, // Fallback seguro
    );
  }
}
