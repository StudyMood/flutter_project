import '../models/unit_category.dart';
import '../models/unit_item.dart';
import '../models/conversion_result.dart';

/// Result envelope containing either successful conversion data or a validation error.
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => message;
}

class ConversionEngine {
  /// Validates input string and returns parsed double, or throws [ValidationException].
  static double validateAndParseInput({
    required String rawInput,
    required UnitCategory category,
    required UnitItem sourceUnit,
  }) {
    final trimmed = rawInput.trim();

    if (trimmed.isEmpty) {
      throw ValidationException('Please enter a value to convert.');
    }

    // Replace comma with dot if user typed localized decimal comma
    final normalized = trimmed.replaceAll(',', '.');

    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      throw ValidationException('Invalid number. Please enter numeric digits.');
    }

    // Category physical constraints
    if (!category.allowNegative && parsed < 0) {
      throw ValidationException(
        '${category.name} values cannot be negative. Please enter a value >= 0.',
      );
    }

    // Temperature absolute zero validation
    if (category.id == 'temperature') {
      if (sourceUnit.id == 'k' && parsed < 0) {
        throw ValidationException('Temperature in Kelvin cannot be below absolute zero (0 K).');
      } else if (sourceUnit.id == 'c' && parsed < -273.15) {
        throw ValidationException(
          'Temperature in Celsius cannot be below absolute zero (-273.15 °C).',
        );
      } else if (sourceUnit.id == 'f' && parsed < -459.67) {
        throw ValidationException(
          'Temperature in Fahrenheit cannot be below absolute zero (-459.67 °F).',
        );
      }
    }

    return parsed;
  }

  /// Performs the actual conversion and returns a [ConversionResult].
  static ConversionResult convert({
    required double sourceValue,
    required UnitCategory category,
    required UnitItem sourceUnit,
    required UnitItem targetUnit,
    int precision = 4,
  }) {
    double targetValue;
    String formula;
    String stepByStep;

    // Handle identical units shortcut
    if (sourceUnit.id == targetUnit.id) {
      targetValue = sourceValue;
      formula = '1 ${sourceUnit.symbol} = 1 ${targetUnit.symbol}';
      stepByStep = 'Source and target units are identical.';
      return ConversionResult(
        sourceValue: sourceValue,
        sourceUnit: sourceUnit,
        targetValue: targetValue,
        targetUnit: targetUnit,
        category: category,
        formula: formula,
        stepByStepExplanation: stepByStep,
      );
    }

    if (category.id == 'temperature') {
      // Non-linear temperature conversion
      final celsiusBase = sourceUnit.customToBase!(sourceValue);
      targetValue = targetUnit.customFromBase!(celsiusBase);

      formula = _getTemperatureFormula(sourceUnit.id, targetUnit.id);
      stepByStep = _getTemperatureExplanation(
        sourceValue: sourceValue,
        sourceUnit: sourceUnit,
        targetValue: targetValue,
        targetUnit: targetUnit,
        celsiusBase: celsiusBase,
        precision: precision,
      );
    } else {
      // Linear conversion via Base Unit
      // 1. source -> base
      final baseValue = sourceValue * sourceUnit.toBaseFactor;
      // 2. base -> target
      targetValue = baseValue / targetUnit.toBaseFactor;

      // Equivalent ratio: 1 sourceUnit = X targetUnit
      final ratio = sourceUnit.toBaseFactor / targetUnit.toBaseFactor;
      final formattedRatio = formatNumber(ratio, precision: precision);
      formula = '1 ${sourceUnit.symbol} = $formattedRatio ${targetUnit.symbol}';

      stepByStep =
          'Multiply the ${category.name.toLowerCase()} value by $formattedRatio';
    }

    return ConversionResult(
      sourceValue: sourceValue,
      sourceUnit: sourceUnit,
      targetValue: targetValue,
      targetUnit: targetUnit,
      category: category,
      formula: formula,
      stepByStepExplanation: stepByStep,
    );
  }

  /// Cleanly formats a double value with given decimal precision.
  /// Removes trailing zeroes (e.g. 12.000 -> 12, 12.500 -> 12.5).
  static String formatNumber(double value, {int precision = 4}) {
    if (value.isNaN || value.isInfinite) return value.toString();

    // Use scientific notation for very large or tiny non-zero numbers
    final absVal = value.abs();
    if (absVal > 0 && (absVal >= 1e12 || absVal < 1e-6)) {
      return value.toStringAsExponential(precision);
    }

    // Format with maximum precision, then strip trailing zeros and unnecessary decimal point
    String formatted = value.toStringAsFixed(precision);
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      if (formatted.endsWith('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }
    return formatted;
  }

  static String _getTemperatureFormula(String fromId, String toId) {
    if (fromId == 'c' && toId == 'f') return '°F = (°C × 9/5) + 32';
    if (fromId == 'f' && toId == 'c') return '°C = (°F - 32) × 5/9';
    if (fromId == 'c' && toId == 'k') return 'K = °C + 273.15';
    if (fromId == 'k' && toId == 'c') return '°C = K - 273.15';
    if (fromId == 'f' && toId == 'k') return 'K = (°F - 32) × 5/9 + 273.15';
    if (fromId == 'k' && toId == 'f') return '°F = (K - 273.15) × 9/5 + 32';
    return '';
  }

  static String _getTemperatureExplanation({
    required double sourceValue,
    required UnitItem sourceUnit,
    required double targetValue,
    required UnitItem targetUnit,
    required double celsiusBase,
    required int precision,
  }) {
    final from = sourceUnit.id;
    final to = targetUnit.id;
    final sVal = formatNumber(sourceValue, precision: precision);
    final tVal = formatNumber(targetValue, precision: precision);

    if (from == 'c' && to == 'f') {
      return '($sVal °C × 9/5) + 32 = $tVal °F';
    } else if (from == 'f' && to == 'c') {
      return '($sVal °F - 32) × 5/9 = $tVal °C';
    } else if (from == 'c' && to == 'k') {
      return '$sVal °C + 273.15 = $tVal K';
    } else if (from == 'k' && to == 'c') {
      return '$sVal K - 273.15 = $tVal °C';
    } else if (from == 'f' && to == 'k') {
      return '($sVal °F - 32) × 5/9 + 273.15 = $tVal K';
    } else if (from == 'k' && to == 'f') {
      return '($sVal K - 273.15) × 9/5 + 32 = $tVal °F';
    }
    return '$sVal ${sourceUnit.symbol} = $tVal ${targetUnit.symbol}';
  }
}

