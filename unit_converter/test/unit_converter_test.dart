import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/models/unit_category.dart';
import 'package:unit_converter/services/conversion_engine.dart';
import 'package:unit_converter/state/converter_notifier.dart';

void main() {
  group('Length Conversion Tests', () {
    final categories = UnitCategory.getAllCategories();
    final lengthCategory = categories.firstWhere((c) => c.id == 'length');
    final cmUnit = lengthCategory.units.firstWhere((u) => u.id == 'cm');
    final mUnit = lengthCategory.units.firstWhere((u) => u.id == 'm');
    final kmUnit = lengthCategory.units.firstWhere((u) => u.id == 'km');
    final inUnit = lengthCategory.units.firstWhere((u) => u.id == 'in');
    final ftUnit = lengthCategory.units.firstWhere((u) => u.id == 'ft');

    test('100 cm should equal 1 m', () {
      final result = ConversionEngine.convert(
        sourceValue: 100.0,
        category: lengthCategory,
        sourceUnit: cmUnit,
        targetUnit: mUnit,
      );
      expect(result.targetValue, closeTo(1.0, 0.0001));
    });

    test('1 km should equal 1000 m', () {
      final result = ConversionEngine.convert(
        sourceValue: 1.0,
        category: lengthCategory,
        sourceUnit: kmUnit,
        targetUnit: mUnit,
      );
      expect(result.targetValue, closeTo(1000.0, 0.0001));
    });

    test('1 inch should equal 2.54 cm', () {
      final result = ConversionEngine.convert(
        sourceValue: 1.0,
        category: lengthCategory,
        sourceUnit: inUnit,
        targetUnit: cmUnit,
      );
      expect(result.targetValue, closeTo(2.54, 0.0001));
    });

    test('1 foot should equal 0.3048 m', () {
      final result = ConversionEngine.convert(
        sourceValue: 1.0,
        category: lengthCategory,
        sourceUnit: ftUnit,
        targetUnit: mUnit,
      );
      expect(result.targetValue, closeTo(0.3048, 0.0001));
    });
  });

  group('Weight Conversion Tests', () {
    final categories = UnitCategory.getAllCategories();
    final weightCategory = categories.firstWhere((c) => c.id == 'weight');
    final gUnit = weightCategory.units.firstWhere((u) => u.id == 'g');
    final kgUnit = weightCategory.units.firstWhere((u) => u.id == 'kg');
    final lbUnit = weightCategory.units.firstWhere((u) => u.id == 'lb');

    test('1000 grams should equal 1 kilogram', () {
      final result = ConversionEngine.convert(
        sourceValue: 1000.0,
        category: weightCategory,
        sourceUnit: gUnit,
        targetUnit: kgUnit,
      );
      expect(result.targetValue, closeTo(1.0, 0.0001));
    });

    test('1 kilogram should equal ~2.20462 pounds', () {
      final result = ConversionEngine.convert(
        sourceValue: 1.0,
        category: weightCategory,
        sourceUnit: kgUnit,
        targetUnit: lbUnit,
      );
      expect(result.targetValue, closeTo(2.20462, 0.001));
    });
  });

  group('Temperature Non-Linear Conversion Tests', () {
    final categories = UnitCategory.getAllCategories();
    final tempCategory = categories.firstWhere((c) => c.id == 'temperature');
    final cUnit = tempCategory.units.firstWhere((u) => u.id == 'c');
    final fUnit = tempCategory.units.firstWhere((u) => u.id == 'f');
    final kUnit = tempCategory.units.firstWhere((u) => u.id == 'k');

    test('0 °C should equal 32 °F (Freezing point of water)', () {
      final result = ConversionEngine.convert(
        sourceValue: 0.0,
        category: tempCategory,
        sourceUnit: cUnit,
        targetUnit: fUnit,
      );
      expect(result.targetValue, closeTo(32.0, 0.0001));
    });

    test('100 °C should equal 212 °F (Boiling point of water)', () {
      final result = ConversionEngine.convert(
        sourceValue: 100.0,
        category: tempCategory,
        sourceUnit: cUnit,
        targetUnit: fUnit,
      );
      expect(result.targetValue, closeTo(212.0, 0.0001));
    });

    test('-40 °C should equal -40 °F (Parity point)', () {
      final result = ConversionEngine.convert(
        sourceValue: -40.0,
        category: tempCategory,
        sourceUnit: cUnit,
        targetUnit: fUnit,
      );
      expect(result.targetValue, closeTo(-40.0, 0.0001));
    });

    test('0 °C should equal 273.15 K', () {
      final result = ConversionEngine.convert(
        sourceValue: 0.0,
        category: tempCategory,
        sourceUnit: cUnit,
        targetUnit: kUnit,
      );
      expect(result.targetValue, closeTo(273.15, 0.0001));
    });

    test('-273.15 °C should equal 0 K (Absolute Zero)', () {
      final result = ConversionEngine.convert(
        sourceValue: -273.15,
        category: tempCategory,
        sourceUnit: cUnit,
        targetUnit: kUnit,
      );
      expect(result.targetValue, closeTo(0.0, 0.0001));
    });
  });

  group('Volume & Speed Conversion Tests', () {
    final categories = UnitCategory.getAllCategories();
    final volumeCat = categories.firstWhere((c) => c.id == 'volume');
    final mlUnit = volumeCat.units.firstWhere((u) => u.id == 'ml');
    final lUnit = volumeCat.units.firstWhere((u) => u.id == 'l');

    test('1000 mL should equal 1 L', () {
      final result = ConversionEngine.convert(
        sourceValue: 1000.0,
        category: volumeCat,
        sourceUnit: mlUnit,
        targetUnit: lUnit,
      );
      expect(result.targetValue, closeTo(1.0, 0.0001));
    });

    final speedCat = categories.firstWhere((c) => c.id == 'speed');
    final kmhUnit = speedCat.units.firstWhere((u) => u.id == 'kmh');
    final mpsUnit = speedCat.units.firstWhere((u) => u.id == 'mps');

    test('36 km/h should equal 10 m/s', () {
      final result = ConversionEngine.convert(
        sourceValue: 36.0,
        category: speedCat,
        sourceUnit: kmhUnit,
        targetUnit: mpsUnit,
      );
      expect(result.targetValue, closeTo(10.0, 0.0001));
    });
  });

  group('Validation Tests', () {
    final categories = UnitCategory.getAllCategories();
    final lengthCategory = categories.firstWhere((c) => c.id == 'length');
    final tempCategory = categories.firstWhere((c) => c.id == 'temperature');
    final mUnit = lengthCategory.units.firstWhere((u) => u.id == 'm');
    final cUnit = tempCategory.units.firstWhere((u) => u.id == 'c');
    final kUnit = tempCategory.units.firstWhere((u) => u.id == 'k');

    test('Empty input should throw ValidationException', () {
      expect(
        () => ConversionEngine.validateAndParseInput(
          rawInput: '',
          category: lengthCategory,
          sourceUnit: mUnit,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('Non-numeric input should throw ValidationException', () {
      expect(
        () => ConversionEngine.validateAndParseInput(
          rawInput: 'abc',
          category: lengthCategory,
          sourceUnit: mUnit,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('Negative length should throw ValidationException', () {
      expect(
        () => ConversionEngine.validateAndParseInput(
          rawInput: '-5',
          category: lengthCategory,
          sourceUnit: mUnit,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('Temperature below absolute zero in Celsius should throw ValidationException', () {
      expect(
        () => ConversionEngine.validateAndParseInput(
          rawInput: '-300',
          category: tempCategory,
          sourceUnit: cUnit,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('Negative Kelvin should throw ValidationException', () {
      expect(
        () => ConversionEngine.validateAndParseInput(
          rawInput: '-10',
          category: tempCategory,
          sourceUnit: kUnit,
        ),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('ConverterNotifier State Tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('Category switch resets source and target units to category defaults', () {
      final notifier = ConverterNotifier();
      final weightCategory = notifier.categories.firstWhere((c) => c.id == 'weight');

      notifier.selectCategory(weightCategory);

      expect(notifier.selectedCategory.id, equals('weight'));
      expect(notifier.fromUnit.id, equals(weightCategory.defaultFromUnit.id));
      expect(notifier.toUnit.id, equals(weightCategory.defaultToUnit.id));
    });

    test('swapUnits exchanges fromUnit and toUnit', () {
      final notifier = ConverterNotifier();
      final initialFrom = notifier.fromUnit;
      final initialTo = notifier.toUnit;

      notifier.swapUnits();

      expect(notifier.fromUnit, equals(initialTo));
      expect(notifier.toUnit, equals(initialFrom));
    });
  });
}

