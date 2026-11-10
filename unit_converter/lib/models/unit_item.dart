/// Represents a single unit of measurement (e.g., Centimeter, Kilogram, Celsius).
class UnitItem {
  final String id;
  final String name;
  final String symbol;

  /// Conversion multiplier to convert 1 unit into the category base unit.
  /// For instance, if base unit is Meter: cm -> 0.01, km -> 1000.
  final double toBaseFactor;

  /// For non-linear conversions such as Temperature (°C, °F, K).
  final double Function(double value)? customToBase;
  final double Function(double baseValue)? customFromBase;

  /// Optional helpful description or equivalence hint.
  final String? hint;

  const UnitItem({
    required this.id,
    required this.name,
    required this.symbol,
    this.toBaseFactor = 1.0,
    this.customToBase,
    this.customFromBase,
    this.hint,
  });

  bool get isCustom => customToBase != null && customFromBase != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$name ($symbol)';
}

