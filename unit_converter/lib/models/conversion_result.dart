import 'unit_category.dart';
import 'unit_item.dart';

/// Encapsulates the output of a single unit conversion operation.
class ConversionResult {
  final double sourceValue;
  final UnitItem sourceUnit;
  final double targetValue;
  final UnitItem targetUnit;
  final UnitCategory category;
  final String formula;
  final String stepByStepExplanation;
  final DateTime timestamp;

  ConversionResult({
    required this.sourceValue,
    required this.sourceUnit,
    required this.targetValue,
    required this.targetUnit,
    required this.category,
    required this.formula,
    required this.stepByStepExplanation,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Formatted source string with symbol (e.g., "120 cm")
  String get formattedSourceDisplay => '$sourceValue ${sourceUnit.symbol}';

  /// Formatted target string with symbol (e.g., "1.2 m")
  String get formattedTargetDisplay => '$targetValue ${targetUnit.symbol}';

  /// Full descriptive title
  String get summary =>
      '$sourceValue ${sourceUnit.name} = $targetValue ${targetUnit.name}';
}

